"use strict";

const sqlite = require("sqlite3");
const crypto = require("crypto");
const dayjs = require("dayjs");
const GpxParser = require("gpxparser");
const fs = require("fs");
const { Buffer } = require("buffer");

function checkPassword(password) {
  let count = 0;

  if (password.length >= 8) {
    count += 1;
  }

  //UpperCase
  if (/[A-Z]/.test(password)) {
    count += 1;
  }
  //Lowercase
  if (/[a-z]/.test(password)) {
    count += 1;
  }
  //Numbers
  if (/\d/.test(password)) {
    count += 1;
  }

  return count;
}

class Database {
  constructor(dbName) {
    this.db = new sqlite.Database(dbName, (err) => {
      if (err) throw err;
    });
  }

  getHikeWithFilters = (filters) => {
    console.log(filters);
    console.log(Object.keys(filters).length);

    return new Promise((resolve, reject) => {
      let query =
        "SELECT * FROM hike INNER JOIN location ON hike.ID = location.hike_ID";
      let query2 = "";
      if (Object.entries(filters).length != 0) {
        query2 = query.concat(" WHERE ");
        for (let entry of Object.entries(filters)) {
          let key = entry[0];
          let value = entry[1];
          if (
            key == "start_asc" ||
            key == "end_asc" ||
            key == "start_len" ||
            key == "end_len"
          ) {
            value = parseInt(value);
          }
          if (
            (typeof value === "string" || value instanceof String) &&
            key.length !== 0
          ) {
            if (key == "start_time") {
              query2 = query2.concat("expected_time", " > ", "'" + value + "'");
            } else if (key == "end_time") {
              query2 = query2.concat("expected_time", "<", "'" + value + "'");
            } else {
              query2 = query2.concat(key, "=", "'" + value + "'");
            }
          } else if (typeof value === "number" || value instanceof Number) {
            if (key == "start_asc") {
              query2 = query2.concat("ascent", " > ", value);
            } else if (key == "end_asc") {
              query2 = query2.concat("ascent", " < ", value);
            } else if (key == "start_len") {
              query2 = query2.concat("length", " > ", value);
            } else if (key == "end_len") {
              query2 = query2.concat("length", " < ", value);
            }
          }
          query2 = query2.concat(" AND ");
        }
        query2 = query2.slice(0, query2.length - 4);
        console.log(query2);
      } else {
        query2 = query2.concat(query);
        console.log(query2);
      }

      console.log("final query: ", query2);
      this.db.all(query2, [], async (err, rows) => {
        if (err) {
          reject(err);
          return;
        }
        const list = rows.map((e) => ({
          ID: e.ID,
          name: e.name,
          length: e.length,
          expected_time: e.expected_time,
          ascent: e.ascent,
          difficulty: e.difficulty,
          start_point: e.start_point,
          end_point: e.end_point,
          description: e.description,
          location_name: e.location_name,
          latitude: e.latitude,
          longitude: e.longitude,
          city: e.city,
          province: e.province,
          hike_ID: e.hike_ID,
          user_ID: e.user_ID,
        }));
        let array = [];
        list.forEach((i) => {
          if (array.find((a) => a.ID === i.ID) === undefined) {
            let temp = list.filter((elem) => elem.ID === i.ID);
            if (temp.length === 1) {
              array.push(temp[0]);
            } else {
              let location = [];
              temp.map((t) => {
                location.push({
                  name: t.location_name,
                  latitude: t.latitude,
                  longitude: t.longitude,
                  city: t.city,
                  province: t.province,
                });
                return t;
              });
              array.push({
                ID: temp[0].ID,
                userID: temp[0].user_ID,
                name: temp[0].name,
                length: temp[0].length,
                expected_time: temp[0].expected_time,
                ascent: temp[0].ascent,
                difficulty: temp[0].difficulty,
                start_point: temp[0].start_point,
                end_point: temp[0].end_point,
                description: temp[0].description,
                location: location,
              });
            }
          }
        });

        const promises = array.map(async (h) => {
          return this.getCoverImageByHikeID(h.ID);
        });
        const results = await Promise.all(promises);

        array.forEach((element, index) => {
          array[index] = {
            ...element,
            coverUrl: results[index],
          };
        });

        return resolve(array);
      });
    });
  };

  /*
    getCompletedHikeWithFilters = (filters) => {
      console.log(filters);
      console.log(Object.keys(filters).length);
  
      return new Promise((resolve, reject) => {
        let query =
          "SELECT * FROM hike INNER JOIN location ON hike.ID = location.hike_ID INNER JOIN hike_schedule ON hike.ID = hike_schedule.hike_ID";
        let query2 = "";
        if (Object.entries(filters).length != 0) {
          query2 = query.concat(" WHERE user_ID = 5 status = 'completed' ");
          for (let entry of Object.entries(filters)) {
            let key = entry[0];
            let value = entry[1];
            if (
              key == "start_asc" ||
              key == "end_asc" ||
              key == "start_len" ||
              key == "end_len"
            ) {
              value = parseInt(value);
            }
            if (
              (typeof value === "string" || value instanceof String) &&
              key.length !== 0
            ) {
              if (key == "start_time") {
                query2 = query2.concat("expected_time", " > ", "'" + value + "'");
              } else if (key == "end_time") {
                query2 = query2.concat("expected_time", "<", "'" + value + "'");
              } else {
                query2 = query2.concat(key, "=", "'" + value + "'");
              }
            } else if (typeof value === "number" || value instanceof Number) {
              if (key == "start_asc") {
                query2 = query2.concat("ascent", " > ", value);
              } else if (key == "end_asc") {
                query2 = query2.concat("ascent", " < ", value);
              } else if (key == "start_len") {
                query2 = query2.concat("length", " > ", value);
              } else if (key == "end_len") {
                query2 = query2.concat("length", " < ", value);
              }
            }
            query2 = query2.concat(" AND ");
          }
          query2 = query2.slice(0, query2.length - 4);
          console.log(query2);
        } else {
          query2 = query2.concat(query);
          console.log(query2);
        }
  
        console.log("final query: ", query2);
        this.db.all(query2, [], async (err, rows) => {
          if (err) {
            reject(err);
            return;
          }
          const list = rows.map((e) => ({
            ID: e.ID,
            name: e.name,
            length: e.length,
            expected_time: e.expected_time,
            ascent: e.ascent,
            difficulty: e.difficulty,
            start_point: e.start_point,
            end_point: e.end_point,
            description: e.description,
            location_name: e.location_name,
            latitude: e.latitude,
            longitude: e.longitude,
            city: e.city,
            province: e.province,
            hike_ID: e.hike_ID,
            user_ID: e.user_ID,
          }));
          let array = [];
          list.forEach((i) => {
            if (array.find((a) => a.ID === i.ID) === undefined) {
              let temp = list.filter((elem) => elem.ID === i.ID);
              if (temp.length === 1) {
                array.push(temp[0]);
              } else {
                let location = [];
                temp.map((t) => {
                  location.push({
                    name: t.location_name,
                    latitude: t.latitude,
                    longitude: t.longitude,
                    city: t.city,
                    province: t.province,
                  });
                  return t;
                });
                array.push({
                  ID: temp[0].ID,
                  userID: temp[0].user_ID,
                  name: temp[0].name,
                  length: temp[0].length,
                  expected_time: temp[0].expected_time,
                  ascent: temp[0].ascent,
                  difficulty: temp[0].difficulty,
                  start_point: temp[0].start_point,
                  end_point: temp[0].end_point,
                  description: temp[0].description,
                  location: location,
                });
              }
            }
          });
  
          const promises = array.map(async (h) => {
            return this.getCoverImageByHikeID(h.ID);
          });
          const results = await Promise.all(promises);
  
          array.forEach((element, index) => {
            array[index] = {
              ...element,
              coverUrl: results[index],
            };
          });
  
          return resolve(array);
        });
      });
    };
  */



  getHikesDetailsByHikeID = (hike_ID) => {
    return new Promise((resolve, reject) => {
      const sql =
        "SELECT * FROM hike INNER JOIN location ON hike.ID = location.hike_ID INNER JOIN hike_gpx ON hike.ID = hike_gpx.hike_ID WHERE hike.ID = ?";
      this.db.all(sql, [hike_ID], async (err, rows) => {
        if (err || rows.length === 0) reject(err);
        else {
          const list = rows.map((e) => ({
            ID: e.ID,
            name: e.name,
            length: e.length,
            expected_time: e.expected_time,
            ascent: e.ascent,
            difficulty: e.difficulty,
            start_point: e.start_point,
            end_point: e.end_point,
            description: e.description,
            location_name: e.location_name,
            latitude: e.latitude,
            longitude: e.longitude,
            city: e.city,
            province: e.province,
            hike_ID: e.hike_ID,
            user_ID: e.user_ID,
            gpx: e.gpx,
          }));
          let array = [];
          list.forEach((i) => {
            if (array.find((a) => a.ID === i.ID) === undefined) {
              let temp = list.filter((elem) => elem.ID === i.ID);
              if (temp.length === 1) {
                array.push(temp[0]);
              } else {
                let location = [];
                temp.map((t) => {
                  location.push({
                    name: t.location_name,
                    latitude: t.latitude,
                    longitude: t.longitude,
                    city: t.city,
                    province: t.province,
                  });
                  return t;
                });
                array.push({
                  ID: temp[0].ID,
                  userID: temp[0].user_ID,
                  name: temp[0].name,
                  length: temp[0].length,
                  expected_time: temp[0].expected_time,
                  ascent: temp[0].ascent,
                  difficulty: temp[0].difficulty,
                  start_point: temp[0].start_point,
                  end_point: temp[0].end_point,
                  description: temp[0].description,
                  location: location,
                  gpx: temp[0].gpx,
                });
              }
            }
          });

          var promises = array.map(async (h) => {
            return this.getCoverImageByHikeID(h.ID);
          });
          var results = await Promise.all(promises);

          array.forEach((element, index) => {
            array[index] = {
              ...element,
              coverUrl: results[index],
            };
          });

          promises = array.map(async (h) => {
            return fs.promises.readFile(h.gpx, 'utf8')
          });
          results = await Promise.all(promises);

          array.forEach((element, index) => {
            array[index].gpx = results[index]
          });

          return resolve(array);
        }
      });
    });
  };

  /*testing code START*/
  getHikeByID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hike WHERE ID = ?";
      this.db.get(sql, [ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getLocationByHikeID = (hike_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM location WHERE hike_ID = ?";
      this.db.all(sql, [hike_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getGpxByHikeID = (hike_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hike_gpx WHERE hike_ID = ?";
      this.db.all(sql, [hike_ID], async function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getCoverImageByHikeID = (hike_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT path FROM hike_image WHERE hike_ID = ?";
      this.db.get(sql, [hike_ID], async function (err, res) {
        if (err) reject(err);

        if (res == undefined) {
          res = "hike/cover/default.png";
          resolve(res);
          return;
        }

        res = res.path;
        res = res.split('./assets/')

        resolve(res[res.length - 1]);
      });
    });
  };

  getLinkUser = (hike_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT user_ID FROM hike WHERE hike_ID=? ";
      this.db.all(sql, [hike_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getUserByID = (user_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM user WHERE ID = ?";
      this.db.get(sql, [user_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getHutByID = (hut_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hut WHERE ID = ?";
      this.db.get(sql, [hut_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getParkingLotByID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM parking_lot WHERE ID = ?";
      this.db.get(sql, [ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getReferencePointByID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM reference_point WHERE ID = ?";
      this.db.get(sql, [ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getRefReached = () => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM ref_reached";
      this.db.get(sql, [], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };


  getLinkHikeUserHut = (hike_ID, user_ID, hut_ID) => {
    return new Promise((resolve, reject) => {
      const sql =
        "SELECT * FROM hike_user_hut WHERE hike_ID=? AND user_ID=? AND hut_ID=?";
      this.db.all(sql, [hike_ID, user_ID, hut_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getLinkHikeUserParkingLot = (hike_ID, user_ID, parking_lot_ID) => {
    return new Promise((resolve, reject) => {
      const sql =
        "SELECT * FROM hike_user_parking WHERE hike_ID=? AND user_ID=? AND parking_ID=?";
      this.db.all(
        sql,
        [hike_ID, user_ID, parking_lot_ID],
        function (err, rows) {
          if (err) reject(err);
          else resolve(rows);
        }
      );
    });
  };

  getHikeUserHut = (hike_ID, user_ID, hut_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hike_user_hut WHERE hike_ID=? AND user_ID=? AND hut_ID=?";
      this.db.all(sql, [hike_ID, user_ID, hut_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getHikeUserParking = (hike_ID, user_ID, parking_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hike_user_parking WHERE hike_ID=? AND user_ID=? AND parking_ID=?";
      this.db.all(sql, [hike_ID, user_ID, parking_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getHikeUserRef = (hike_ID, user_ID, ref_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hike_user_ref WHERE hike_ID=? AND user_ID=? AND ref_ID=?";
      this.db.all(sql, [hike_ID, user_ID, ref_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };


  getScheduleByID = (schedule_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hike_schedule WHERE ID=?";
      this.db.get(sql, [schedule_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getOnGoingHikeByUserID = (user_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hike_schedule WHERE user_ID=? AND status = 'on going'";
      this.db.get(sql, [user_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getCompletedHikesByUserID = (user_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof user_ID !== 'number'
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "SELECT * FROM hike_schedule INNER JOIN hike ON hike_schedule.hike_ID = hike.ID WHERE hike_schedule.user_ID=? AND status = 'completed'";
      this.db.all(sql, [user_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getRefReached = (hike_ID, user_ID, ref_ID) => {
    return new Promise((resolve, reject) => {
      const sql =
        "SELECT * FROM ref_reached WHERE hike_ID=? AND user_ID=? AND ref_ID=?";
      this.db.all(sql, [hike_ID, user_ID, ref_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };


  deleteHikeByID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM hike WHERE ID=?";
      this.db.run(sql, [ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteLocationByHikeID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM location WHERE hike_ID=?";
      this.db.run(sql, [ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteGpxByHikeID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM hike_gpx WHERE hike_ID=?";
      this.db.run(sql, [ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteUserByID = (user_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM user WHERE ID=?";
      this.db.run(sql, [user_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteHutByID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM hut WHERE ID=?";
      this.db.run(sql, [ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteLinkHikeUserHut = (hike_ID, user_ID, hut_ID) => {
    return new Promise((resolve, reject) => {
      const sql =
        "DELETE FROM hike_user_hut WHERE hike_ID=? AND user_ID=? AND hut_ID=?";
      this.db.run(sql, [hike_ID, user_ID, hut_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteParkingLotByID = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM parking_lot WHERE ID=?";
      this.db.run(sql, [ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteLinkHikeUserParking = (hike_ID, user_ID, parking_ID) => {
    return new Promise((resolve, reject) => {
      const sql =
        "DELETE FROM hike_user_parking WHERE hike_ID=? AND user_ID=? AND parking_ID=?";
      this.db.run(sql, [hike_ID, user_ID, parking_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  setVerifiedBack = (user_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (typeof user_ID !== "number") {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      let query = "UPDATE user SET verified = 0 WHERE ID=?";

      this.db.run(query, [user_ID], function (err) {
        if (err) reject(err);
        else {
          if (this.changes > 0) resolve();
          else {
            reject(new Error("User not found!"));
          }
        }
      });
    });
  };

  deleteHikeUserHut = (hike_ID, user_ID, hut_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM hike_user_hut WHERE hike_ID=? AND user_ID=? AND hut_ID=?";
      this.db.run(sql, [hike_ID, user_ID, hut_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteHikeUserParking = (hike_ID, user_ID, parking_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM hike_user_parking WHERE hike_ID=? AND user_ID=? AND parking_ID=?";
      this.db.run(sql, [hike_ID, user_ID, parking_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteHikeUserReferencePoint = (hike_ID, user_ID, ref_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM hike_user_ref WHERE hike_ID=? AND user_ID=? AND ref_ID=?";
      this.db.run(sql, [hike_ID, user_ID, ref_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteScheduleByID = (schedule_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM hike_schedule WHERE ID=?";
      this.db.run(sql, [schedule_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  deleteReferencePointByID = (rp_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "DELETE FROM reference_point WHERE ID=?";
      this.db.run(sql, [rp_ID], function (err) {
        if (err) reject(err);
        else resolve(true);
      });
    });
  };

  /*testing code END*/

  addNewHike = (hike, gpx_string, user_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof hike.name !== "string" ||
          typeof hike.expected_time !== "string" ||
          typeof hike.difficulty !== "string" ||
          typeof hike.description !== "string" ||
          typeof gpx_string !== "string" ||
          typeof user_ID !== "number"
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      let gpx = new GpxParser();
      gpx.parse(gpx_string);
      let length = parseInt(gpx.tracks[0].distance.total / 1000);
      let ascent = parseInt(gpx.tracks[0].elevation.max);
      const sql =
        "INSERT INTO hike(name,length,expected_time,ascent,difficulty,description, user_ID) VALUES(?,?,?,?,?,?,?)";
      this.db.run(
        sql,
        [
          hike.name,
          length,
          hike.expected_time,
          ascent,
          hike.difficulty,
          hike.description,
          user_ID,
        ],
        function (err) {
          if (err) reject(err);
          else resolve(this.lastID);
        }
      );
    });
  };

  addNewLocation = (loc, position, hike_ID, gpx_string) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof loc.location_name !== "string" ||
          typeof loc.city !== "string" ||
          typeof loc.province !== "string" ||
          typeof position !== "string" ||
          typeof hike_ID !== "number"
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      let gpx = new GpxParser();
      gpx.parse(gpx_string);
      let lat = gpx.tracks[0].points[0].lat;
      let lon = gpx.tracks[0].points[0].lon;

      let len = gpx.tracks[0].points.length - 1;
      let lat_end = gpx.tracks[0].points[len].lat;
      let lon_end = gpx.tracks[0].points[len].lon;
      let latitude, longitude;
      if (position === "start") {
        latitude = lat;
        longitude = lon;
        position = "start";
      } else if (position === "end") {
        latitude = lat_end;
        longitude = lon_end;
        position = "end";
      } else {
        return reject(422); //UNPROCESSABLE
      }
      const sql =
        "INSERT INTO location(location_name, latitude, longitude, city, province, hike_ID, start_end) VALUES(?,?,?,?,?,?,?)";
      this.db.run(
        sql,
        [
          loc.location_name,
          latitude,
          longitude,
          loc.city,
          loc.province,
          hike_ID,
          position,
        ],
        function (err) {
          if (err) reject(err);
          else resolve(true);
        }
      );
    });
  };

  addNewHikeGPX = (gpx_path, hike_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (typeof gpx_path !== "string" || typeof hike_ID !== "number") {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "INSERT INTO hike_gpx(gpx,hike_ID) VALUES(?,?)";
      this.db.run(sql, [gpx_path, hike_ID], function (err) {
        if (err) reject(err);
        else resolve(this.lastID);
      });
    });
  };

  addNewHikeImage = (imagePath, hike_ID, type) => {
    return new Promise((resolve, reject) => {
      try {
        if (typeof imagePath !== "string" || typeof hike_ID !== "number") {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "INSERT INTO hike_image(path, hike_ID, type) VALUES(?,?,?)";
      this.db.run(sql, [imagePath, hike_ID, type], function (err) {
        if (err) reject(err);
        else resolve(this.lastID);
      });
    });
  };

  addSchedule = (schedule, user_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof schedule.start_time !== "string" ||
          typeof schedule.hike_ID !== "number" ||
          typeof user_ID !== "number"
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql =
        "INSERT INTO hike_schedule(start_time,end_time,status,duration,hike_ID, user_ID) VALUES(?,'on going','on going','on going',?,?)";
      this.db.run(
        sql,
        [
          schedule.start_time,
          schedule.hike_ID,
          user_ID,
        ],
        function (err) {
          if (err) reject(err);
          else resolve(this.lastID);
        }
      );
    });
  };

  updateSchedule = (schedule_ID, end_time, duration) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof schedule_ID !== "number" ||
          typeof end_time !== "string" ||
          typeof duration !== "string"
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql =
        "UPDATE hike_schedule SET end_time = ?, duration = ?, status = 'completed' WHERE ID =?";
      this.db.run(
        sql,
        [
          end_time,
          duration,
          schedule_ID,
        ],
        function (err) {
          if (err) reject(err);
          else resolve(true);
        }
      );
    });
  };

  addUser = (user) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof user.name !== "string" ||
          typeof user.surname !== "string" ||
          typeof user.mail !== "string" ||
          typeof user.role !== "string" ||
          typeof user.password !== "string"
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }

      let countCheck = checkPassword(user.password);
      if (countCheck < 4) {
        return reject(new Error("Password doesn't match all the criterias!"));
      }

      let database = this.db;
      let salt = crypto.randomBytes(16);
      crypto.scrypt(
        user.password,
        salt.toString("hex"),
        32,
        function (err, hashedPassword) {
          const sql =
            "INSERT INTO user(name,surname,mail,password,salt,role,verified) VALUES(?,?,?,?,?,?,?)";
          database.run(
            sql,
            [
              user.name,
              user.surname,
              user.mail,
              hashedPassword.toString("hex"),
              salt.toString("hex"),
              user.role,
              0,
            ],
            function (err) {
              if (err) reject(err);
              else {
                console.log(this.lastID);
                resolve(this.lastID);
              }
            }
          );
        }
      );
    });
  };

  addHut = (hut, user_ID) => {
    return new Promise((resolve, reject) => {
      if (
        typeof hut.name !== "string" ||
        typeof hut.description !== "string" ||
        typeof hut.opening_time !== "string" ||
        typeof hut.closing_time !== "string" ||
        typeof hut.bed_num !== "number" ||
        typeof hut.altitude !== "number" ||
        typeof hut.latitude !== "number" ||
        typeof hut.longitude !== "number" ||
        typeof hut.city !== "string" ||
        typeof hut.province !== "string" ||
        typeof hut.phone !== "string" ||
        typeof hut.mail !== "string" ||
        typeof hut.website !== "string" ||
        typeof user_ID !== "number"
      ) {
        return reject(422); // 422 - UNPROCESSABLE
      }
      const sql =
        "INSERT INTO hut(name,description,opening_time,closing_time,bed_num,altitude,latitude,longitude,city,province,phone,mail,website, user_ID) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
      this.db.run(
        sql,
        [
          hut.name,
          hut.description,
          hut.opening_time,
          hut.closing_time,
          hut.bed_num,
          hut.altitude,
          hut.latitude,
          hut.longitude,
          hut.city,
          hut.province,
          hut.phone,
          hut.mail,
          hut.website,
          user_ID,
        ],
        function (err) {
          if (err) reject(err);
          else {
            resolve(this.lastID);
          }
        }
      );
    });
  };

  addParking = (parking, user_ID) => {
    return new Promise((resolve, reject) => {
      if (
        typeof parking.name !== "string" ||
        typeof parking.capacity !== "number" ||
        typeof parking.latitude !== "number" ||
        typeof parking.longitude !== "number" ||
        typeof parking.city !== "string" ||
        typeof parking.province !== "string" ||
        typeof user_ID !== "number"
      ) {
        return reject(422); // 422 - UNPROCESSABLE
      }

      const sql =
        "INSERT INTO parking_lot(name,capacity,latitude,longitude,city,province, user_ID) VALUES(?,?,?,?,?,?,?)";
      this.db.run(
        sql,
        [
          parking.name,
          parking.capacity,
          parking.latitude,
          parking.longitude,
          parking.city,
          parking.province,
          user_ID,
        ],
        function (err) {
          if (err) reject(err);
          else {
            resolve(this.lastID);
          }
        }
      );
    });
  };

  addReferencePoint = (referencePoint, user_ID) => {
    return new Promise((resolve, reject) => {
      if (
        typeof referencePoint.name !== "string" ||
        typeof referencePoint.type !== "string" ||
        typeof referencePoint.latitude !== "number" ||
        typeof referencePoint.longitude !== "number" ||
        typeof referencePoint.city !== "string" ||
        typeof referencePoint.province !== "string" ||
        typeof user_ID !== "number"
      ) {
        return reject(422); // 422 - UNPROCESSABLE
      }

      const sql =
        "INSERT INTO reference_point(name,type,latitude,longitude,city,province, user_ID) VALUES(?,?,?,?,?,?,?)";
      this.db.run(
        sql,
        [
          referencePoint.name,
          referencePoint.type,
          referencePoint.latitude,
          referencePoint.longitude,
          referencePoint.city,
          referencePoint.province,
          user_ID,
        ],
        function (err) {
          if (err) reject(err);
          else {
            resolve(this.lastID);
          }
        }
      );
    });
  };

  getHutsWithFilters = (filters) => {
    return new Promise((resolve, reject) => {
      let query = "SELECT * FROM hut";
      let query2 = "";
      if (Object.entries(filters).length != 0) {
        query2 = query.concat(" WHERE ");
        for (let entry of Object.entries(filters)) {
          let key = entry[0];
          let value = entry[1];
          if (
            key == "min_altitude" ||
            key == "max_altitude" ||
            key == "min_bed_num" ||
            key == "max_bed_num"
          ) {
            value = parseInt(value);
          }
          if (
            (typeof value === "string" || value instanceof String) &&
            key.length !== 0
          ) {
            if (key == "min_opening_time") {
              query2 = query2.concat("opening_time", " > ", "'" + value + "'");
            } else if (key == "max_opening_time") {
              query2 = query2.concat("opening_time", "<", "'" + value + "'");
            } else if (key == "min_closing_time") {
              query2 = query2.concat("closing_time", " > ", "'" + value + "'");
            } else if (key == "max_closing_time") {
              query2 = query2.concat("closing_time", "<", "'" + value + "'");
            } else {
              query2 = query2.concat(key, "=", "'" + value + "'"); //city, province
            }
          } else if (typeof value === "number" || value instanceof Number) {
            if (key == "min_altitude") {
              //min_altitude
              query2 = query2.concat("altitude", " > ", value); //altitude
            } else if (key == "max_altitude") {
              //max_altitude
              query2 = query2.concat("altitude", " < ", value); //altitude
            } else if (key == "min_bed_num") {
              //min_bed_num
              query2 = query2.concat("bed_num", " > ", value); //bed_num
            } else if (key == "max_bed_num") {
              //max_bed_num
              query2 = query2.concat("bed_num", " < ", value); //bed_num
            }
          }
          query2 = query2.concat(" AND ");
        }
        query2 = query2.slice(0, query2.length - 4);
        console.log(query2);
      } else {
        query2 = query2.concat(query);
        console.log(query2);
      }

      console.log("final query: ", query2);
      this.db.all(query2, [], (err, rows) => {
        if (err) {
          reject(err);
          return;
        }
        const list = rows.map((e) => ({
          ID: e.ID,
          name: e.name,
          description: e.description,
          opening_time: e.opening_time,
          closing_time: e.closing_time,
          bed_num: e.bed_num,
          altitude: e.altitude,
          latitude: e.latitude,
          longitude: e.longitude,
          city: e.city,
          province: e.province,
          phone: e.phone,
          mail: e.mail,
          website: e.website,
        }));

        return resolve(list);
      });
    });
  };

  /*HT-8 - GET LOCATION GIVEN HIKE_ID AND TYPE OF POINT*/
  getLocationToLink = (hike_ID, start_end) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM location WHERE hike_ID = ? AND start_end = ?";
      this.db.all(sql, [hike_ID, start_end], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  /*HT-8 - GET ALL HUTS*/
  getAllHuts = () => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM hut";
      this.db.all(sql, [], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getReferencePointByHike = (hike_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT *\n" +
        "FROM hike_user_ref INNER JOIN hike ON hike_user_ref.hike_ID = hike.ID INNER JOIN reference_point ON hike_user_ref.ref_ID = reference_point.ID\n" +
        "WHERE hike_ID = ?";
      this.db.all(sql, [hike_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };


  /*HT-8 - GET ALL PARKING LOTS*/
  getAllParkings = () => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM parking_lot";
      this.db.all(sql, [], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  /*HT-8 - ADD HUT LINKED TO THE HIKE*/
  addHikeUserHut = (hike_ID, user_ID, hut_ID, ref_type) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof hike_ID !== 'number' ||
          typeof user_ID !== 'number' ||
          typeof hut_ID !== 'number' ||
          typeof ref_type !== 'string'
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "INSERT INTO hike_user_hut(hike_ID, user_ID, hut_ID, ref_type) VALUES(?,?,?,?)";
      this.db.run(
        sql, [hike_ID, user_ID, hut_ID, ref_type], function (err) {
          if (err) reject(err);
          else {
            resolve(true);
          }
        });
    });
  };

  addRefReached = (hike_ID, user_ID, ref_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof hike_ID !== 'number' ||
          typeof user_ID !== 'number' ||
          typeof ref_ID !== 'number'
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "INSERT INTO ref_reached(hike_ID, user_ID, ref_ID, state) VALUES(?,?,?,0)";
      this.db.run(
        sql, [hike_ID, user_ID, ref_ID], function (err) {
          if (err) reject(err);
          else {
            resolve(true);
          }
        });
    });
  };

  updateRefReached = (hike_ID, user_ID, ref_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof hike_ID !== 'number' ||
          typeof user_ID !== 'number' ||
          typeof ref_ID !== 'number'
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "UPDATE ref_reached SET state = 1 WHERE hike_ID = ? AND user_ID = ? AND ref_ID = ?";
      this.db.run(
        sql, [hike_ID, user_ID, ref_ID], function (err) {
          if (err) reject(err);
          else {
            resolve(true);
          }
        });
    });
  };


  /*HT-8 - ADD PARKING LOT LINKED TO THE HIKE*/
  addHikeUserParking = (hike_ID, user_ID, parking_ID, ref_type) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof hike_ID !== 'number' ||
          typeof user_ID !== 'number' ||
          typeof parking_ID !== 'number' ||
          typeof ref_type !== 'string'
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "INSERT INTO hike_user_parking(hike_ID, user_ID, parking_ID, ref_type) VALUES(?,?,?,?)";
      this.db.run(
        sql, [hike_ID, user_ID, parking_ID, ref_type], function (err) {
          if (err) reject(err);
          else {
            resolve(true);
          }
        });
    });
  };

  /*HT-33 ADD REFERENCE POINT LINKED TO THE HIKE*/
  addHikeUserRef = (hike_ID, user_ID, ref_ID, ref_type) => {
    return new Promise((resolve, reject) => {
      try {
        if (
          typeof hike_ID !== 'number' ||
          typeof user_ID !== 'number' ||
          typeof ref_ID !== 'number' ||
          typeof ref_type !== 'string'
        ) {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      const sql = "INSERT INTO hike_user_ref(hike_ID, user_ID, ref_ID, ref_type) VALUES(?,?,?,?)";
      this.db.run(
        sql, [hike_ID, user_ID, ref_ID, ref_type], function (err) {
          if (err) reject(err);
          else {
            resolve(true);
          }
        });
    });
  };


  addGpx = (gpx1) => {
    return new Promise((resolve, reject) => {
      let gpx = new GpxParser();
      gpx.parse(gpx1);

      let length = parseInt((gpx.tracks[0].distance.total * 2) / 1000);
      console.log("LENGTH ", length);

      let max_el = gpx.tracks[0].elevation.max;
      let min_el = gpx.tracks[0].elevation.min;
      let ascent = parseInt(max_el - min_el);
      console.log("ASCENT ", ascent);

      let lat = gpx.tracks[0].points[0].lat;
      let lon = gpx.tracks[0].points[0].lon;

      let len = gpx.tracks[0].points.length - 1;
      let lat_end = gpx.tracks[0].points[len].lat;
      let lon_end = gpx.tracks[0].points[len].lon;

      console.log("LATITUDINE START", lat);
      console.log("LONGITUDINE START", lon);
      console.log("LATITUDINE END", lat_end);
      console.log("LONGITUDINE END", lon_end);
    });
  };

  setVerified = (user_ID) => {
    return new Promise((resolve, reject) => {
      try {
        if (typeof user_ID !== "number") {
          return reject(422); // 422 - UNPROCESSABLE
        }
      } catch (e) {
        return reject(503); // 503 - UNAVAILABLE
      }
      let query = "UPDATE user SET verified = 1 WHERE ID=?";

      this.db.run(query, [user_ID], function (err) {
        if (err) reject(err);
        else {
          if (this.changes > 0) resolve();
          else {
            reject(new Error("User not found!"));
          }
        }
      });
    });
  };

  login = (username, password) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM user WHERE mail = ?";
      this.db.get(sql, [username], (err, row) => {
        if (err) {
          resolve(false);
        } else if (row === undefined) {
          resolve(false);
        } else {
          const user = {
            ID: row.ID,
            username: row.mail,
            name: row.name,
            role: row.role,
            verified: row.verified,
          };

          crypto.scrypt(password, row.salt, 32, function (err, hashedPassword) {
            if (err) reject(err);
            if (
              !crypto.timingSafeEqual(
                Buffer.from(row.password, "hex"),
                hashedPassword
              )
            )
              resolve(false);
            else resolve(user);
          });
        }
      });
    });
  };

  getRegions = () => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM region";
      this.db.all(sql, [], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getProvinces = (region_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM province WHERE region_ID = ?";
      this.db.all(sql, [region_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getMunicipalities = (province_ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM municipality WHERE province_ID = ?";
      this.db.all(sql, [province_ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };

  getBorder = (ID) => {
    return new Promise((resolve, reject) => {
      const sql = "SELECT * FROM border WHERE ID = ?";
      this.db.get(sql, [ID], function (err, rows) {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  };
}

module.exports = Database;
