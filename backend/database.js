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

    getHikeWithFilters = (filters) => {
        console.log(filters)
        console.log(Object.keys(filters).length)
        
        return new Promise((resolve, reject) => {

            let query = 'SELECT * FROM hike INNER JOIN location ON hike.ID = location.hike_ID'
            let query2 = ""
            if(!(Object.entries(filters) == 0)){
                query2 = query.concat(' WHERE ')
                for(let entry of Object.entries(filters)) {
                    let key = entry[0]
                    let value = entry[1]
                    if(key == "start_asc" ||  key == "end_asc"){
                        value=parseInt(value)
                    }
                    if(key == "start_len" || key == "end_len"){
                        value=parseInt(value)
                    }
                    if ((typeof value === "string" || value instanceof String)) {
                        if (key.length !== 0) {
                            if(key == "start_time"){
                                query2 = query2.concat("expected_time", " > ", "'" + value +"'")
                            }else if(key == "end_time") {
                                query2 = query2.concat("expected_time", "<", "'" + value +"'")
                            }else {
                                query2 = query2.concat(key, "=", "'" + value +"'")

                            }
                        }
                    }
                    else if(typeof value === 'number' || value instanceof Number){
                            if (key == "start_asc" ) {
                                query2 = query2.concat("ascent", " > ", value)
                            } else if (key == "end_asc") {
                                query2 = query2.concat("ascent", " < ", value)
                            } else if(key == "start_len") {
                                query2 = query2.concat("length", " > ", value)
                            } else if(key == "end_len"){
                                query2 = query2.concat("length", " < ", value)
                            }
                    }
                    query2 = query2.concat(" AND ")
                }
                query2 = query2.slice(0,query2.length - 4)
                console.log(query2)
            }else{
                query2 = query2.concat(query);
                console.log(query2)
            }

            this.db.all(query2 ,[], (err, rows) => {
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