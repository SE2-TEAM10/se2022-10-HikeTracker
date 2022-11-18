"use strict";

const dayjs = require("dayjs");
const express = require("express");
const morgan = require("morgan"); // logging middleware
const cors = require("cors");
const Database = require("./database.js");
const db = new Database("./hiketracker.db");
const passport = require("passport"); // auth middleware
const LocalStrategy = require("passport-local").Strategy; // username and password for login
const session = require("express-session"); // enable sessions
const { check, validationResult, body, param } = require("express-validator"); // validation middleware */

// set up the "username and password" login strategy
// by setting a function to verify username and password
passport.use(
  new LocalStrategy(async function verify(username, password, cb) {
    const user = await db.login(username, password);
    if (!user) return cb(null, false, "Incorrect username or password.");

    return cb(null, user);
  })
);

// serialize and de-serialize the user (user object <-> session)
// we serialize the user id and we store it in the session: the session is very small in this way
passport.serializeUser((user, done) => {
  done(null, user.id);
});

// starting from the data in the session, we extract the current (logged-in) user
passport.deserializeUser((id, done) => {
  db.getUserById(id)
    .then((user) => {
      done(null, user); // this will be available in req.user
    })
    .catch((err) => {
      done(err, null);
    });
});

const errorFormatter = ({ location, msg, param, value, nestedErrors }) => {
  return `${location}[${param}]: ${msg}`;
};

// init express
const app = express();
const port = 3001;

// set-up the middlewares
app.use(morgan("common"));
app.use(express.json());
const corsOptions = {
  origin: 'http://localhost:8000',
  credentials: true,
};
app.use(cors(corsOptions));

// custom middleware: check if a given request is coming from an authenticated user
const isLoggedIn = (req, res, next) => {
  if (req.isAuthenticated()) return next();

  return res.status(401).json({ error: "not authenticated" });
};

// set up the session
app.use(
  session({
    // by default, Passport uses a MemoryStore to keep track of the sessions
    secret:
      "a secret sentence not to share with anybody and anywhere, used to sign the session ID cookie",
    resave: false,
    saveUninitialized: false,
  })
);

// then, init passport
app.use(passport.initialize());
app.use(passport.session());

// POST /sessions
// login
app.post("/api/sessions", function (req, res, next) {
  passport.authenticate("local", (err, user, info) => {
    if (err) return next(err);
    if (!user) {
      // display wrong login messages
      return res.status(401).json(info);
    }
    // success, perform the login
    req.login(user, (err) => {
      if (err) return next(err);
      return res.json(req.user);
    });
  })(req, res, next);
});

// DELETE /sessions/current
// logout
app.delete("/api/sessions/current", (req, res) => {
  req.logout(() => {
    res.end();
  });
});

// GET /sessions/current
// check whether the manager is logged in or not
app.get("/api/sessions/current", (req, res) => {
  if (req.isAuthenticated()) {
    res.status(200).json(req.user);
  } else res.status(401).json({ error: "Unauthenticated user!" });
});

// EXAMPLE OF URL: http://localhost:3001/api/hike?difficulty=T&start_asc=300
app.get("/api/hike", async (req, res) => {
  await db
    .getHikeWithFilters(req.query)
    .then((lists) => {
      lists.map((row) => {
        if (row.location !== null && !Array.isArray(row.location))
          row.location = [row.location];
        return row;
      });
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving courses` })
        .end();
    });
});

app.post(
  "/api/hike",
  isLoggedIn,
  [
    /*
        check('name').isLength({ min: 1, max: 100 }),
        check('length').isInt(),
        check('expected_time').islength({ min: 5, max: 5 }),
        check('ascent').isInt(),
        check('difficulty').islength({ min: 1, max: 2 }),
      */
  ],
  async (req, res) => {
    /* const errors = validationResult(req).formatWith(errorFormatter); // format error message
        if (!errors.isEmpty()) {
            return res.status(422).json({ error: errors.array().join(", ") }); // error message is a single string with all error joined together
        }*/

    try {
      const result1 = await db.addNewHike(req.body.hike);
      const result2 = await db.addNewLocation(req.body.startp);
      const result3 = await db.addNewLocation(req.body.endp);
      const result4 = await db.linkHikeUser(req.user.id);
      res.status(201).json(result1);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  }
);

app.post(
  "/api/hike/gpx",
  isLoggedIn,
  [
    /*
        check('name').isLength({ min: 1, max: 100 }),
        check('length').isInt(),
        check('expected_time').islength({ min: 5, max: 5 }),
        check('ascent').isInt(),
        check('difficulty').islength({ min: 1, max: 2 }),
      */
  ],
  async (req, res) => {
    /* const errors = validationResult(req).formatWith(errorFormatter); // format error message
        if (!errors.isEmpty()) {
            return res.status(422).json({ error: errors.array().join(", ") }); // error message is a single string with all error joined together
        }*/

    try {
      const result1 = await db.addNewHikeGPX(req.body);
      res.status(201).json(result1);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  }
);

// Activate the server
app.listen(port, () => {
  console.log(`server listening at http://localhost:${port}`);
});
