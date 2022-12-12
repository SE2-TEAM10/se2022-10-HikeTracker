"use strict";

const dayjs = require("dayjs");
require("dotenv").config();
const nodemailer = require("nodemailer");
const express = require("express");
const path = require("path");
const morgan = require("morgan"); // logging middleware
const cors = require("cors");
const Database = require("./database.js");
const db = new Database("./hiketracker.db");
const passport = require("passport"); // auth middleware
const LocalStrategy = require("passport-local").Strategy; // username and password for login
const session = require("express-session"); // enable sessions
const { check, validationResult, body, param } = require("express-validator"); // validation middleware */
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");
const { request } = require("express");

// set up the "username and password" login strategy
// by setting a function to verify username and password
passport.use(
  new LocalStrategy(async function verify(username, password, cb) {
    const user = await db.login(username, password);
    if (!user) return cb(null, false, "Incorrect username or password.");
    if (user.verified == 0) return cb(null, false, "User is not verified.");

    return cb(null, user);
  })
);

// serialize and de-serialize the user (user object <-> session)
// we serialize the user id and we store it in the session: the session is very small in this way
passport.serializeUser((user, done) => {
  done(null, user.ID);
});

// starting from the data in the session, we extract the current (logged-in) user
passport.deserializeUser((ID, done) => {
  db.getUserByID(ID)
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

// fixing "413 Request Entity Too Large" errors
app.use(bodyParser.json({ limit: "500mb" }));
app.use(bodyParser.urlencoded({ extended: true, limit: "500mb" }));

// set-up the middlewares
app.use(morgan("common"));
app.use(express.json());
const corsOptions = {
  origin: "http://localhost:8000",
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

/*function getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  let R = 6371; // Radius of the earth in km
  let dLat = deg2rad(lat2-lat1);  // deg2rad below
  let dLon = deg2rad(lon2-lon1);
  let a =
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
      Math.sin(dLon/2) * Math.sin(dLon/2)
  ;
  let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  let d = R * c; // Distance in km
  return d;
}

function deg2rad(deg) {
  return deg * (Math.PI/180)
}*/

//This function takes in latitude and longitude of two location and returns the distance between them as the crow flies (in km)
function getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  var R = 6371; // km
  var dLat = toRad(lat2 - lat1);
  var dLon = toRad(lon2 - lon1);
  var lat1 = toRad(lat1);
  var lat2 = toRad(lat2);

  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c;
  return d;
}

// Converts numeric degrees to radians
function toRad(Value) {
  return Value * Math.PI / 180;
}


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
    res.status(200).json({
      ID: req.user.ID,
      name: req.user.name,
      username: req.user.mail,
      role: req.user.role,
    });
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
        .json({ error: `Database error while retrieving hike` })
        .end();
    });
});

/* app.get("/api/distance", async (req, res) => {

  let parking = [];
  try {
    let array = await db.getCoordinatesHike();
    await db.getCoordinatesParking().then((coordinates) => {
      coordinates.map((row) => {
          let distance = getDistanceFromLatLonInKm(44.699197, 7.156556, row.latitude, row.longitude);
          if (distance < 45) {
            console.log("DISTANCE", distance);
            parking.push({
              name: row.name,
              capacity: row.capacity,
              latitude: row.latitude,
              longitude: row.longitude,
              city: row.city,
              province: row.province,
              distanceFromPoint: distance,
            })
            return parking;
          }
        })

      });
      res.json(parking);
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
}); */

app.get(
  "/api/hikesdetails/:hike_ID",
  /*isLoggedIn,*/ async (req, res) => {
    /* let user = await db.getUserByID(req.user.id);
     if (user.role !== "Hiker") {
       return res.status(422).json({ error: `not a hiker` }).end();
     }*/
    await db
      .getHikesDetailsByHikeID(req.params.hike_ID)
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
          .json({ error: `Database error while retrieving hike` })
          .end();
      });
  }
);

app.get("/api/sendEmail", async (req, res) => {
  let transport = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASSWORD,
    },
    tls: {
      rejectUnauthorized: false,
    },
  });

  let mailOptions = {
    from: "Hike Tracker <hiketracker10@gmail.com>",
    to: "hiketracker10@gmail.com",
    subject: "Confirm Email",
    text: "Please,confirm your email to activate the hike tracker account! ",
  };

  transport.sendMail(mailOptions, (error, info) => {
    if (error) {
      return console.log(error);
    }
    console.log("Message sent: %s", info.messageId);
  });
});

app.post("/api/hike", isLoggedIn, [], async (req, res) => {
  try {
    if (typeof req.body.gpx !== "string") {
      res.status(422).json(err); //UNPROCESSABLE
    }

    const gpx_len = req.body.gpx.length;
    if (gpx_len === 0) {
      res.status(422).json("Error: the gpx file is empty!"); //UNPROCESSABLE
    }

    const result1 = await db.addNewHike(
      req.body.hike,
      req.body.gpx,
      req.user.ID
    );
    console.log("res1 - ", result1);
    const result2 = await db.addNewLocation(
      req.body.startp,
      "start",
      result1,
      req.body.gpx
    );
    console.log("res2 - ", result2);
    const result3 = await db.addNewLocation(
      req.body.endp,
      "end",
      result1,
      req.body.gpx
    );
    console.log("res3 - ", result3);
    const result4 = await db.addNewHikeGPX(req.body.gpx, result1);
    console.log("res4 - ", result4);

    //console.log(result1);
    res.status(201).json("Hike " + result1 + " correctly created!");
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

app.post(
  "/api/gpx",
  //isLoggedIn,
  [],
  async (req, res) => {
    try {
      const result5 = await db.addGpx(req.body.gpx);

      res.status(201).json(result5);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  }
);

app.post("/api/addUser", async (req, res) => {
  try {
    const result1 = await db.addUser(req.body);

    console.log("RESULT", result1);
    const token_mail_verification = jwt.sign({ id: result1 }, "ourSecretKey", {
      expiresIn: "1d",
    });

    const message = `http://localhost:3001/api/user/verify/${token_mail_verification}`;
    //to insert: req.body.user.mail
    await sendEmail(req.body.mail, "Verify Email", message);
    res.status(201).json(result1);
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

//addHut
app.post(
  "/api/addHut",
  isLoggedIn,
  [
    check("name").isString(),
    check("description").isString(),
    check("opening_time").isString(),
    check("closing_time").isString(),
    check("bed_num").isInt(),
    check("altitude").isInt(),
    check("city").isString(),
    check("province").isString(),
    check("phone").isString(),
    check("mail").isString(),
    check("website").isString(),
  ],
  async (req, res) => {
    const errors = validationResult(req).formatWith(errorFormatter); // format error message
    if (!errors.isEmpty()) {
      return res.status(422).json({ error: errors.array().join(", ") }); // error message is a single string with all error joined together
    }

    console.log("TYPE USER", req.user.role);
    console.log("USER ID", req.user.ID);

    try {
      // check if a user is a local guide or a hut worker
      if (req.user.role === "LocalGuide" || req.user.role === "HutWorker") {
        const result1 = await db.addHut(req.body, req.user.ID);

        res.status(201).json(result1);
      }
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  }
);

//addParking
app.post("/api/addParking", isLoggedIn, [], async (req, res) => {
  const errors = validationResult(req).formatWith(errorFormatter); // format error message
  if (!errors.isEmpty()) {
    return res.status(422).json({ error: errors.array().join(", ") }); // error message is a single string with all error joined together
  }

  console.log("TYPE USER", req.user.role);
  console.log("USER ID", req.user.ID);

  try {
    // check if a user is a local guide or a hut worker
    if (req.user.role === "LocalGuide" || req.user.role === "HutWorker") {
      const result1 = await db.addParking(req.body, req.user.ID);

      res.status(201).json(result1);
    }
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

app.get("/api/hutWithFilters", async (req, res) => {
  await db
    .getHutsWithFilters(req.query)
    .then((lists) => {
    res.json(lists);
  })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving hike` })
        .end();
    });
});

//api get parking from hike_ID
app.get("/api/parkingFromHike/:hike_ID", async (req, res) => {
  await db
    .getParkingFromHike(req.params.hike_ID)
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving hike` })
        .end();
    });
});


//api per la verifica
app.get("/api/user/verify/:token", (req, res) => {
  const { token } = req.params;

  // Verifing the JWT token
  jwt.verify(token, "ourSecretKey", async function (err, decoded) {
    console.log("Decoded", decoded);
    try {
      const userToAdd = await db.getUserByID(decoded.id);
      console.log("user to add: ", userToAdd);
      const verifyToCheck = userToAdd.verified;
      console.log(verifyToCheck);
      if (err || verifyToCheck === 1) {
        /* user already registered */
        console.log(err);
        res.sendFile(path.join(__dirname + "/indexNotVerified.html"));
      } else if (verifyToCheck === 0) {
        await db.setVerified(decoded.id);
        res.sendFile(path.join(__dirname + "/indexVerified.html"));
      }
    } catch (error) {
      console.error(error);
      res.status(503).json(error);
    }
  });
});

//set a boolean value (verified) to 1
app.put("/api/:id/setVerified", async (req, res) => {
  try {
    const result1 = await db.setVerified(req.params.id);

    res.status(201).json(result1);
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

const sendEmail = async (email, subject, text) => {
  let transport = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
      user: process.env.EMAIL,
      pass: process.env.PASSWORD,
    },
    tls: {
      rejectUnauthorized: false,
    },
  });

  let mailOptions = {
    from: "Hike Tracker <" + process.env.EMAIL + ">",
    to: email,
    subject: subject,
    html:
      '<h2 style="color:#59ac11;">Hello, Welcome to Hike Tracker!</h2></br><h4>Please confirm your email address by clicking the link below :</h4>' +
      text,
  };

  transport.sendMail(mailOptions, (error, info) => {
    if (error) {
      return console.log(error);
    }
    console.log("Message sent: %s", info.messageId);
  });
};

/* const getLinkUser = async (req,res) => {
  // check if a user is a local guide or a hut worker
  const user_res = await db.getLinkUser(req.body.hike_ID);
  console.log("USER ID :", req.user.ID);
  if (user_res !== req.user.ID) {
    res.status(422).json("User and hike not linked");
  } else if (req.user.role !== "LocalGuide" || req.user.role !== "HutWorker") {
    res.status(422).json("User isnt't a local guide or a hut worker");
  }
}; */

app.get("/api/locationToLinkHutOrParking", async (req, res) => {
  try {
    const loc = await db.getLocationToLink(req.body.hike_ID, req.body.start_end);
    if (req.body.ref === "hut") {
      let final_huts = [];
      const huts = await db.getHutsByProvince(loc.province);
      huts.map((h) => {
        let distance = getDistanceFromLatLonInKm(loc.latitude, loc.longitude, h.latitude, h.longitude);
        if (distance < 5) {
          console.log("HUTS - DISTANCE: ", distance);
          final_huts.push({
            ID: h.ID,
            name: h.name,
            description: h.description,
            opening_time: h.opening_time,
            closing_time: h.closing_time,
            bed_num: h.bed_num,
            altitude: h.altitude,
            latitude: h.latitude,
            longitude: h.longitude,
            city: h.city,
            province: h.province,
            phone: h.phone,
            mail: h.mail,
            website: h.website
          })
          return final_huts;
        }
      })
      res.json(final_huts);
    } else if (req.body.ref === "p_lot") {
      let final_parks = [];
      const parks = await db.getParkingsByProvince(loc.province);
      parks.map((p) => {
        let distance = getDistanceFromLatLonInKm(loc.latitude, loc.longitude, p.latitude, p.longitude);
        if (distance < 5) {
          console.log("PARKING LOTS - DISTANCE: ", distance);
          final_parks.push({
            ID: p.ID,
            name: p.name,
            capacity: p.capacity,
            latitude: p.latitude,
            longitude: p.longitude,
            city: p.city,
            province: p.province
          })
          return final_parks;
        }
      })
      res.json(final_parks);
    } else {
      res.status(422).json("The reference point is not defined correctly!");
    }
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

/*index.js - link hut to the hike*/
app.post("/api/linkHut", isLoggedIn, [],
  async (req, res) => {
    try {
      const result = await db.addHikeUserHut(req.body.hike_ID, req.user.ID, req.body.hut_ID, req.body.ref_type);
      res.status(201).json(result);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  });

/*index.js - link parking lot to the hike*/
app.post("/api/linkParking", isLoggedIn, [],
  async (req, res) => {
    try {
      const result = await db.addHikeUserParking(req.body.hike_ID, req.user.ID, req.body.parking_ID, req.body.ref_type);
      res.status(201).json(result);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  });

//APIs for regions, provinces, municipalities and borders

app.get("/api/regions/", async (req, res) => {
  await db
    .getRegions()
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving regions` })
        .end();
    });
});

app.get("/api/provinces/:region_ID", async (req, res) => {
  await db
    .getProvinces(req.params.region_ID)
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving provinces` })
        .end();
    });
});

app.get("/api/municipalities/:province_ID", async (req, res) => {
  await db
    .getMunicipalities(req.params.province_ID)
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving municipalities` })
        .end();
    });
});

app.get("/api/border/:ID", async (req, res) => {
  await db
    .getBorder(req.params.ID)
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving border` })
        .end();
    });
});

// Activate the server
app.listen(port, () => {
  console.log(`server listening at http://localhost:${port}`);
});
