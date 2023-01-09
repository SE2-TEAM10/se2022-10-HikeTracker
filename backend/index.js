"use strict";

const dayjs = require("dayjs");
require("dotenv").config();
const nodemailer = require("nodemailer");
const express = require("express");
const path = require("path");
const morgan = require("morgan");
const cors = require("cors");
const Database = require("./database.js");
const db = new Database("./hiketracker.db");
const passport = require("passport");
const LocalStrategy = require("passport-local").Strategy;
const session = require("express-session");
const { check, validationResult, body, param } = require("express-validator");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");
const { request } = require("express");
const fs = require("fs");
const sharp = require("sharp");

passport.use(
  new LocalStrategy(async function verify(username, password, cb) {
    const user = await db.login(username, password);
    if (!user) return cb(null, false, "Incorrect username or password.");
    if (user.verified == 0) return cb(null, false, "User is not verified.");

    return cb(null, user);
  })
);

passport.serializeUser((user, done) => {
  done(null, user.ID);
});

passport.deserializeUser((ID, done) => {
  db.getUserByID(ID)
    .then((user) => {
      done(null, user);
    })
    .catch((err) => {
      done(err, null);
    });
});

const errorFormatter = ({ location, msg, param, value, nestedErrors }) => {
  return `${location}[${param}]: ${msg}`;
};

const app = express();
const port = 3001;

app.use(bodyParser.json({ limit: "500mb" }));
app.use(bodyParser.urlencoded({ extended: true, limit: "500mb" }));

app.use(morgan("common"));
app.use(express.json());
const corsOptions = {
  origin: "http://localhost:8000",
  credentials: true,
};
app.use(cors(corsOptions));
app.use(express.static('./assets'));

const isLoggedIn = (req, res, next) => {
  if (req.isAuthenticated()) return next();

  return res.status(401).json({ error: "not authenticated" });
};

app.use(
  session({
    secret:
      "a secret sentence not to share with anybody and anywhere, used to sign the session ID cookie",
    resave: false,
    saveUninitialized: false,
  })
);

app.use(passport.initialize());
app.use(passport.session());

function getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
  let R = 6371;
  let dLat = toRad(lat2 - lat1);
  let dLon = toRad(lon2 - lon1);
  lat1 = toRad(lat1);
  lat2 = toRad(lat2);

  let a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
  let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  let d = R * c;
  return d;
}

function toRad(Value) {
  return Value * Math.PI / 180;
}

function calculateDuration(start, end) {
  let s_year = parseInt(start.slice(0, 4));
  let s_month = parseInt(start.slice(5, 7));
  let s_day = parseInt(start.slice(8, 10));
  let s_hour = parseInt(start.slice(11, 13));
  let s_mins = parseInt(start.slice(14, 16));
  let e_year = parseInt(end.slice(0, 4));
  let e_month = parseInt(end.slice(5, 7));
  let e_day = parseInt(end.slice(8, 10));
  let e_hour = parseInt(end.slice(11, 13));
  let e_mins = parseInt(end.slice(14, 16));
  let duration = "";

  let year_diff = e_year - s_year;
  let month_diff = e_month - s_month;
  if (year_diff > 0 && month_diff < 0) {
    month_diff = year_diff * 12 + month_diff;
    year_diff -= 1;
  }

  let day_diff = e_day - s_day;
  if (month_diff > 0 && day_diff < 0) {
    day_diff = 30 + day_diff;
    month_diff -= 1;
  }

  let hour_diff = e_hour - s_hour;
  if (day_diff > 0 && hour_diff < 0) {
    hour_diff = 24 + hour_diff;
    day_diff -= 1;
  }
  let mins_diff = e_mins - s_mins;
  if (hour_diff > 0 && mins_diff < 0) {
    mins_diff = 60 + mins_diff;
    hour_diff -= 1;
  }

  if (year_diff > 0)
    duration += year_diff.toString().concat("Y ");
  if (month_diff > 0)
    duration += month_diff.toString().concat("M ");
  if (day_diff > 0)
    duration += day_diff.toString().concat("D ");
  if (hour_diff > 0)
    duration += hour_diff.toString().concat("h ");
  if (mins_diff > 0)
    duration += mins_diff.toString().concat("m ");
  duration = duration.slice(0, duration.length - 1);
  return duration;
}

app.post("/api/sessions", function (req, res, next) {
  passport.authenticate("local", (err, user, info) => {
    if (err) return next(err);
    if (!user) {
      return res.status(401).json(info);
    }
    req.login(user, (err) => {
      if (err) return next(err);
      return res.json(req.user);
    });
  })(req, res, next);
});

app.delete("/api/sessions/current", (req, res) => {
  req.logout(() => {
    res.end();
  });
});


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


app.get(
  "/api/hikesdetails/:hike_ID",
  isLoggedIn, async function (req, res) {
    let thisuser
    if (req.user != undefined) {
      thisuser = await db.getUserByID(req.user.ID);
    }
    if (thisuser.role !== "Hiker") {
      return res.status(422).json({ error: `the logged in user is not a hiker` }).end();
    }
    await db
      .getHikesDetailsByHikeID(req.params.hike_ID)
      .then((lists) => {
        lists.map((row) => {
          if (row.location !== null && !Array.isArray(row.location))
            row.location = [row.location];
          return row;
        });
        res.json(lists[0]);
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

app.get("/api/hut", async (req, res) => {
  await db
    .getAllHuts()
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

app.get("/api/completedHike", async (req, res) => {
  await db
    .getCompletedHikesByUserID(req.user.ID)
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

app.get("/api/user/verify/:token", (req, res) => {
  const { token } = req.params;

  jwt.verify(token, "ourSecretKey", async function (err, decoded) {
    try {
      const userToAdd = await db.getUserByID(decoded.id);
      const verifyToCheck = userToAdd.verified;
      if (err || verifyToCheck === 1) {
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


app.post("/api/hike", isLoggedIn, [], async (req, res) => {
  try {
    let thisuser = await db.getUserByID(req.user.ID);
    if (thisuser.role !== "LocalGuide") {
      return res.status(422).json({ error: `the logged in user is not a local guide!` }).end();
    }
    if (typeof req.body.gpx !== "string") {
      res.status(422).json(err);
    }

    const gpx_len = req.body.gpx.length;
    if (gpx_len === 0) {
      res.status(422).json("Error: the gpx file is empty!");
    }


    const hike_ID = await db.addNewHike(
      req.body.hike,
      req.body.gpx,
      req.user.ID
    );
    const result2 = await db.addNewLocation(
      req.body.startp,
      "start",
      hike_ID,
      req.body.gpx
    );
    const result3 = await db.addNewLocation(
      req.body.endp,
      "end",
      hike_ID,
      req.body.gpx
    );
    let gpx_path = await saveHikeGpx(req.body.gpx, hike_ID)
    const result4 = await db.addNewHikeGPX(gpx_path, hike_ID);

    if (req.body.image_base_64 != undefined) {
      const imagePath = await saveHikeImage(
        req.body.image_base_64,
        hike_ID,
        "cover"
      );
      await db.addNewHikeImage(imagePath, hike_ID, "cover");
    }

    res.status(201).json("Hike " + hike_ID + " correctly created!");
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

app.get("/api/getReferencePointByHike/:hike_ID", async (req, res) => {
  await db
    .getReferencePointOfScheduledHike(req.params.hike_ID, req.user.ID)
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving reference points` })
        .end();
    });
});

app.get("/api/getAllReferencePointByHike/:hike_ID", async (req, res) => {
  await db
    .getReferencePointByHike(req.params.hike_ID)
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving reference points` })
        .end();
    });
});

app.get("/api/getGenericHutsPointByHike/:hike_ID", async (req, res) => {
  await db
    .getGenericHutsPointByHike(req.params.hike_ID)
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving reference points` })
        .end();
    });
});

app.post("/api/addSchedule", async (req, res) => {
  try {
    let user = await db.getUserByID(req.user.ID);
    if (user.role !== "Hiker") {
      return res.status(422).json({ error: `the logged in user is not a hiker!` }).end();
    }

    const result1 = await db.addSchedule(req.body, req.user.ID);
    const result2 = await db.getReferencePointByHike(req.body.hike_ID);
    let references = [];
    result2.map((res) => {
      references.push({
        ID: res.ref_ID
      })
      return references;
    })
    references.forEach(async (ref) => {
      await db.addRefReached(req.body.hike_ID, req.user.ID, ref.ID, 0);
    })

    res.status(201).json(result2);
  } catch (err) {
    console.log(err);
    res.status(503).json(err);
  }
});


app.put("/api/updateSchedule", async (req, res) => {
  try {
    let user = await db.getUserByID(req.user.ID);
    if (user.role !== "Hiker") {
      return res.status(422).json({ error: `the logged in user is not a hiker!` }).end();
    }
    const schedule = await db.getScheduleByID(req.body.ID);
    let duration = calculateDuration(schedule.start_time, req.body.end_time);

    const result = await db.updateSchedule(Number(req.body.ID), req.body.end_time, duration);
    await db.cleanRefReached(Number(schedule.hike_ID), Number(req.user.ID))
    res.status(200).json(result);
  } catch (err) {
    console.log(err);
    res.status(503).json(err);
  }
});

app.put("/api/updateRefReached", async (req, res) => {
  try {
    let user = await db.getUserByID(req.user.ID);
    if (user.role !== "Hiker") {
      return res.status(422).json({ error: `the logged in user is not a hiker!` }).end();
    }

    const result = await db.updateRefReached(Number(req.body.hike_ID), req.user.ID, Number(req.body.ref_ID));

    res.status(200).json("Reference point " + req.body.ref_ID + " reached!");
  } catch (err) {
    console.log(err);
    res.status(503).json(err);
  }
});

app.get("/api/getOnGoingHike",
  isLoggedIn, async (req, res) => {
    await db
      .getOnGoingHikeByUserID(req.user.ID)
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

app.post("/api/addUser", async (req, res) => {
  try {
    const result1 = await db.addUser(req.body);

    const token_mail_verification = jwt.sign({ id: result1 }, "ourSecretKey", {
      expiresIn: "1d",
    });

    const message = `http://localhost:3001/api/user/verify/${token_mail_verification}`;
    await sendEmail(req.body.mail, "Verify Email", message);
    res.status(201).json(result1);
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});


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
    const errors = validationResult(req).formatWith(errorFormatter); 
    if (!errors.isEmpty()) {
      return res.status(422).json({ error: errors.array().join(", ") });
    }
    try {
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


app.post("/api/addParking", isLoggedIn, [], async (req, res) => {
  const errors = validationResult(req).formatWith(errorFormatter); 
  if (!errors.isEmpty()) {
    return res.status(422).json({ error: errors.array().join(", ") });
  }

  try {
    if (req.user.role === "LocalGuide" || req.user.role === "HutWorker") {
      const result1 = await db.addParking(req.body, req.user.ID);

      res.status(201).json(result1);
    }
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

app.post("/api/addReferencePoint", isLoggedIn, [], async (req, res) => {
  const errors = validationResult(req).formatWith(errorFormatter); 
  if (!errors.isEmpty()) {
    return res.status(422).json({ error: errors.array().join(", ") });
  }
  try {
    if (req.user.role === "LocalGuide") {
      const result1 = await db.addReferencePoint(req.body, req.user.ID);

      res.status(201).json(result1);
    }
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});


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


app.get("/api/locationToLinkHutOrParking", async (req, res) => {
  try {
    let loc = await db.getLocationToLink(req.query.hike_ID, req.query.start_end);
    loc = loc[0]
    if (req.query.ref == "hut") {
      let final_huts = [];
      const huts = await db.getAllHuts();
      huts.map((h) => {
        let distance = getDistanceFromLatLonInKm(loc.latitude, loc.longitude, h.latitude, h.longitude);
        if (distance < 5) {
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
    } else if (req.query.ref == "p_lot") {
      let final_parks = [];
      const parks = await db.getAllParkings();
      parks.map((p) => {
        let distance = getDistanceFromLatLonInKm(loc.latitude, loc.longitude, p.latitude, p.longitude);
        if (distance < 5) {
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

app.get("/api/linkHut/:hike_ID", isLoggedIn, async (req, res) => {
  await db
    .getHutsLinkedToHike(Number(req.params.hike_ID))
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving huts` })
        .end();
    });
});

app.post("/api/linkHut", isLoggedIn, [],
  async (req, res) => {
    try {
      await db.deleteLinkedHut(req.body.hike_ID, req.body.ref_type);
      await db.deleteLinkedParking(req.body.hike_ID, req.body.ref_type);
      const result = await db.addHikeUserHut(req.body.hike_ID, req.user.ID, req.body.hut_ID);
      res.status(201).json(result);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  });

app.get("/api/linkParking/:hike_ID", isLoggedIn, async (req, res) => {
  await db
    .getParkingsLinkedToHike(Number(req.params.hike_ID))
    .then((lists) => {
      res.json(lists);
    })
    .catch((err) => {
      console.log(err);
      res
        .status(500)
        .json({ error: `Database error while retrieving parkings` })
        .end();
    });
});

app.post("/api/linkParking", isLoggedIn, [],
  async (req, res) => {
    try {
      await db.deleteLinkedParking(req.body.hike_ID, req.body.ref_type);
      await db.deleteLinkedHut(req.body.hike_ID, req.body.ref_type);
      const result = await db.addHikeUserParking(req.body.hike_ID, req.user.ID, req.body.parking_ID, req.body.ref_type);
      res.status(201).json(result);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  });

app.post("/api/linkReferencePoint", isLoggedIn, [],
  async (req, res) => {
    try {
      const result = await db.addHikeUserRef(Number(req.body.hike_id), req.user.ID, Number(req.body.ref_ID), req.body.ref_type);
      res.status(201).json(result);
    } catch (err) {
      console.error(err);
      res.status(503).json(err);
    }
  });

app.get("/api/pointToLinkHut", async (req, res) => {
  try {
    if (req.query.ref == "hut") {
      let final_huts = [];
      const huts = await db.getAllHuts();
      huts.map((h) => {
        let distance = getDistanceFromLatLonInKm(Number(req.query.latitude), Number(req.query.longitude), h.latitude, h.longitude);
        if (distance < 5) {
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
    } else {
      res.status(422).json("The reference point is not defined correctly!");
    }
  } catch (err) {
    console.error(err);
    res.status(503).json(err);
  }
});

const saveHikeImage = async function (imageBase64, hike_ID, type) {
  const image = Buffer.from(imageBase64, "base64");
  const path =
    "./assets/hike/" +
    type +
    "/hike_" +
    hike_ID +
    "_" +
    generateRandomString(16) +
    ".png";

  await sharp(image).resize(1000).png({ quality: 90 }).toFile(path);

  console.log("image saved as" + path);
  return path;
};

const saveHikeGpx = async function (gpx, hike_ID) {
  const path =
    "./assets/gpx/" +
    hike_ID +
    "_" +
    generateRandomString(16) +
    ".gpx";

  await fs.promises.writeFile(path, gpx)

  console.log("gpx saved as" + path);
  return path;
};

const generateRandomString = function (n) {
  let str = "";
  for (let i = 0; i < n; i++) {
    let randomNumber = Math.floor(Math.random() * 36);
    str += randomNumber.toString(36);
  }
  return str;
};

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

app.listen(port, () => {
  console.log(`server listening at http://localhost:${port}`);
});
