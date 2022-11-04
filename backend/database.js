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

    getHikeByDifficulty = (difficulty) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM hike WHERE difficulty = ?'
            this.db.get(sql, [difficulty], (err, row) => {
                if (err) return reject(500)
                if (row === undefined) return reject(404)
                return resolve(row)
            })
        })
    }

    getHikeByAscent = (ascent) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM hike WHERE ascent <= ?'
            this.db.get(sql, [ascent], (err, row) => {
                if (err) return reject(500)
                if (row === undefined) return reject(404)
                return resolve(row)
            })
        })
    }

    getHikeByLength = (length) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM hike WHERE length <= ?'
            this.db.get(sql, [length], (err, row) => {
                if (err) return reject(500)
                if (row === undefined) return reject(404)
                return resolve(row)
            })
        })
    }

    getHikeByTime = (time) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM hike WHERE time <= ?'
            this.db.get(sql, [time], (err, row) => {
                if (err) return reject(500)
                if (row === undefined) return reject(404)
                return resolve(row)
            })
        })
    }

    getHikeByArea = (area) => {
        return new Promise((resolve, reject) => {
            if (isNaN(id)) return reject('UNPROCESSABLE')
            const sql = 'SELECT * FROM hike WHERE start_point = ?'
            this.db.get(sql, [area], (err, row) => {
                if (err) return reject(500)
                if (row === undefined) return reject(404)
                return resolve(row)
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