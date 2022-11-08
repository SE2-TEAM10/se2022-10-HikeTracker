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
        console.log(filters)
        console.log(Object.keys(filters).length)
        /*const maxLength = getMaxLength();
        const maxAsc = getMaxAsc();
        const maxTime = getMaxTime();*/
        const maxLength = 10000;
        const maxAsc = 10000;
        const maxTime = 300;
        
        return new Promise((resolve, reject) => {

            let query = 'SELECT * FROM hike INNER JOIN location ON hike.ID = location.hike_ID'
            let query2 = ""
            let params = []
            console.log(query)
            console.log("Filters2: ", filters)
            if(!(Object.keys(filters) === 0)){
                query2 = query.concat(' WHERE ')
                console.log("query1", query2)
                console.log("Chiavi oggetto:" , Object.entries(filters))
                for(let entry in Object.entries(filters)) {
                    console.log(entry[1])
                    console.log("test")
                    console.log(typeof entry.key)
                    if (typeof entry.key === "string" || entry.key instanceof String) {
                        if (entry.key.length !== 0) {
                            if(entry.key.equals("start_time")){
                                query2 = query2.concat(entry.key, " > ", entry.value)
                            }else if(entry.key.equals("end_time")) {
                                query2 = query2.concat(entry.key, "<", entry.value)
                            }else{
                                console.log("sonoentrato")
                                query2 = query2.concat(entry.key, "=", entry.value)
                                console.log(query2)
                            }
                        }
                    }
                    else if(typeof entry.key === 'number' || entry.key instanceof Number){
                        if (entry.key.equals("start_asc") || entry.key.equals("start_len")) {
                            query2 = query2.concat(entry.key, " > ", entry.value)
                        } else if (entry.key.equals("end_asc") || entry.key.equals("end_len")) {
                            query2 = query2.concat(entry.key, " < ", entry.value)
                        }
                    }
                    params.add(entry.value)
                }
            }
            this.db.all(query,params , (err, rows) => {
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