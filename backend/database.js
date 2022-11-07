'use strict'

const sqlite = require('sqlite3')
const crypto = require('crypto')
const dayjs = require('dayjs')


class Database {
    
    constructor(dbName) {
        this.db = new sqlite.Database(dbName, (err) => {
            if (err) throw err
        })
    }

    /* isEmpty = (thisstring) => {
        if(thisstring.length == 0)
            return true;
        return false;
    }

    getMaxLength = () => {
		const sql = 'SELECT MAX(length) FROM hike';
		this.db.get(sql, [], (err,row) => {
			if(err) console.log("Error");
			return row;
		})
	}
	
	getMaxAsc = () => {
		const sql = 'SELECT MAX(ascent) FROM hike';
		this.db.get(sql, [], (err,row) => {
			if(err) console.log("Error");
			return row;
		})
	}
	
	getMaxTime = () => {
		const sql = 'SELECT MAX(expected_time) FROM hike';
		this.db.get(sql, [], (err,row) => {
			if(err) console.log("Error");
			return row;
		})
	} */

    /* CHECKS MUST BE ADDED */
    getHikeWithFilters = (filters) => {
        return new Promise((resolve, reject) => {
            let difficulty = filters.difficulty;    //STRING - if empty: ""
			let start_asc = filters.start_asc;      //INTEGER - if empty: 0
            let end_asc = filters.end_asc;          //INTEGER - if empty: getMaxAsc()
			let start_len = filters.start_len;      //INTEGER - if empty: 0
			let end_len = filters.end_len;          //INTEGER - if empty: getMaxLength()
			let start_time = filters.start_time;    //STRING  - if empty: "00:00"
			let end_time = filters.end_time;        //STRING - if empty: getMaxTime()
			let city = filters.city;                //STRING - if empty: ""
			let province = filters.province;        //STRING - if empty: ""
			let latitude = filters.latitude;        //STRING - if empty: ""
			let longitude = filters.longitude;      //STRING - if empty: ""
            const sql = 'SELECT * FROM hike INNER JOIN location ON hike.ID = location.hike_ID WHERE difficulty = ? AND ascent > ? AND ascent < ? AND length < ? AND length > ? AND expected_time > ? AND expected_time < ? AND city = ? AND province = ? AND latitude = ? AND longitude = ?'
            this.db.all(sql, [difficulty, start_asc, end_asc, start_len, end_len, start_time, end_time, city, province, latitude, longitude], (err, rows) => {
                if (err) return reject(500)
                if (rows === undefined) return reject(404)
                return resolve(rows)
            })
        })
    }

    /* login = (username, password) => {
        return new Promise((resolve, reject) => {
            const sql = `SELECT * FROM manager WHERE mail = ?`
            this.db.get(sql, [username], (err, row) => {
                if (err) {
                    resolve(false)
                } else if (row === undefined) {
                    resolve(false)
                } else {
                    const user = { id: row.id, username: row.mail, name: row.name }

                    crypto.scrypt(password, row.salt, 32, function (err, hashedPassword) {
                        if (err) reject(err)
                        if (!crypto.timingSafeEqual(Buffer.from(row.password, 'hex'), hashedPassword))
                            resolve(false)
                        else resolve(user)
                    })
                }
            })
        })
    } */
}

module.exports = Database