'use strict';

const sqlite = require('sqlite3');

/* MOCK UP DATABASE FOR TESTS */

class DBManager {
    #db;
    constructor() {
        this.#db = new sqlite.Database('./hiketracker.db', (err) => {
            if (err) {
                console.log("Database start error: " + err);
                throw err;
            }
        });

        //console.log("DBManager started");

    }

    /** execute an update/insert/delete given an istruction and params 
     * @throws 500
    */
    async genericSqlRun(query, ...params) {
        //console.log(params);
        return new Promise((resolve, reject) => {
            this.#db.run(query, params, (err) => {
                if (err) {
                    console.log("Database run error: err", err);
                    reject(new Exceptions(500));
                }
                else resolve(true);
            })
        })
    }

    /** execute a select given an istruction and params 
         * @throws 500
        */
    async genericSqlGet(query, ...params) {
        return new Promise((resolve, reject) => {
            this.#db.all(query, params, (err, rows) => {
                if (err) {
                    console.log("Database get error: err", err);
                    reject(new Exceptions(500));
                } else {
                    resolve(rows)
                }
            })
        })
    }

    async deleteP1(queries) {
        return new Promise((resolve, reject) => {
            queries.forEach((query) => {
                this.#db.run(query, (err, rows) => {
                    //console.log(query)
                    if (err) {
                        console.log("Database get error: err", err);
                        reject(new Exceptions(500));
                    } else {
                        resolve(rows)
                    }
                });
            });
        })
    }

    async addP1(query) {
        return new Promise((resolve, reject) => {
            this.#db.run(query, (err, rows) => {
                //console.log(query)
                if (err) {
                    console.log("Database get error: err", err);
                    reject(new Exceptions(500));
                } else {
                    resolve(rows)
                }
            });
        })
    }

    //TESTING PURPOSE

    async deleteAllData() {
        const queries = [
            "DELETE FROM hike WHERE 1=1",
            //"DELETE FROM SQLITE_SEQUENCE WHERE name='hike'"
        ];

        const query2 = 'INSERT INTO hike (ID, name, length, expected_time, ascent, difficulty, start_point, end_point, description) \
       VALUES  (55,"name1", 10,"05:00", 500, "H", "stPoint", "endPoint", "aDesc")'
        await this.deleteP1(queries);
        await this.addP1(query2)

    }


    /* async insertRestockAndReturnOrderTestData() {
        const insertItems = [`INSERT INTO Item ("id", "description", "price", "SKUId", "supplierId")
                              VALUES (1, "item1", 10, 1, 5),
                                     (2, "item2", 20, 2, 5)`];


        const insertRestockOrder = [` INSERT INTO RestockOrder ("issueDate", "state", "transportNote", "supplierId") 
                                     VALUES ("2021/01/01 01:01", "ISSUED", "", 5), 
                                            ("2022/01/02 10:10", "COMPLETEDRETURN", "", 4),
                                            ("2022/03/02 10:10", "TESTED", "", 4),
                                            ("2022/04/02 10:10", "COMPLETED", "", 3);
                                    `];

        const insertReturnOrder = [`INSERT INTO ReturnOrder (returnDate, restockOrderID)
                                    VALUES ("2022/02/02", 1);
        `];

        const insertSKUItemsPerReturnOrder = [`INSERT INTO SKUItemsPerReturnOrder (id, SKUId, itemId, description, price,  RFID) 
                                               VALUES (1, 1, 1, "skuPerReturnOrder", 30, "12345678901234567890123456789016");`];

        const insertSKUItemsPerRestockOrder = [`INSERT INTO SKUItemsPerRestockOrder (id, SKUID, itemId, RFID)
                                                VALUES (1, 1, 1, "12345678901234567890123456789016")`];

        const insertSKU = [`INSERT INTO SKU ( weight, volume, price, notes, description, availableQuantity)
                            VALUES ( 10, 20, 30, "note", "description", 40),
                                   ( 40, 50, 60, "note2", "description2", 70);`];

        const insertSKUItems = [`INSERT INTO SKUItem (RFID, SKUId, Available, DateOfStock) 
                                 VALUES ("12345678901234567890123456789016",1,10,"2022/02/02"),
                                        ("78901234567890161234567890123456",2,20, "2022/03/03");`];

        const insertQueries = [insertItems, insertRestockOrder, insertReturnOrder, insertSKU, insertSKUItemsPerReturnOrder, insertSKUItems];

        return new Promise((resolve, reject) => {
            insertQueries.forEach((querySet) => {
                querySet.forEach((query) => {
                    this.#db.run(query, (err, rows) => {
                        if (err) {
                            console.log("Database get error: err", err);
                            reject(new Exceptions(500));
                        } else {
                            resolve(rows)
                        }
                    });
                });
            });
        })

    }

    async insertTestDescriptorTestData() {
        const insertSKU = [`INSERT INTO SKU (id, weight, volume, price, notes, description, availableQuantity)
        VALUES (1, 10, 20, 30, "note", "description", 40);`];
        const insertSKU2 = [`INSERT INTO SKU (id, weight, volume, price, notes, description, availableQuantity)
        VALUES (2, 10, 20, 30, "note", "description", 40);`];

        const insertTestDescriptor = [' INSERT INTO TestDescriptor ("id","name", "procedureDescription", "idSKU") \
                                     VALUES (1,"test descriptor 1", "description", 1) \
                                    '];

        const insertSKUItems = [`INSERT INTO SKUItem (RFID, SKUId, Available, DateOfStock) VALUES ("12345678901234567890123456789016",1,10,"2022/02/02");`];

        const insertQueries = [insertSKU, insertTestDescriptor, insertSKUItems, insertSKU2];

        return new Promise((resolve, reject) => {
            insertQueries.forEach((querySet) => {
                querySet.forEach((query) => {
                    this.#db.run(query, (err, rows) => {
                        if (err) {
                            console.log("Database get error: err", err);
                            reject(new Exceptions(500));
                        } else {
                            resolve(rows)
                        }
                    });
                });
            });
        })

    } */

    async insertHikeTestData() {
        const insertHike = [`INSERT INTO hike (ID, name, length, expected_time, ascent, difficulty, start_point, end_point, description) VALUES (55,"name1", 10,"05:00", 500, "H", "stPoint", "endPoint", "aDesc");`];
        /* const insertHike2 = [`INSERT INTO hike (ID, name, length, expected_time, ascent, difficulty, start_point, end_point, description) VALUES (56,"name2", 10, "05:00", 500, "H", "stPoint2", "endPoint2", "aDesc2"`]; */

        const insertQueries = [insertHike];

        return new Promise((resolve, reject) => {
            insertQueries.forEach((querySet) => {
                querySet.forEach((query) => {
                    this.#db.run(query, (err, rows) => {
                        if (err) {
                            console.log("Database get error: err", err);
                            reject(new Exceptions(500));
                        } else {
                            resolve(rows)
                        }
                    });
                });
            });
        })

    }

    /* async deleteAndAddUserData() {
        const queries = [
            'DELETE FROM USERS WHERE 1=1',
            'INSERT INTO Users (email, name, surname, password, type) \
             VALUES  ("user1@ezwh.com","name1","surname1","e16b2ab8d12314bf4efbd6203906ea6c","customer"), \
                    ("qualityEmployee1@ezwh.com", "name2","surname2","e16b2ab8d12314bf4efbd6203906ea6c","qualityEmployee"), \
                    ("clerk1@ezwh.com","name3","surname3","e16b2ab8d12314bf4efbd6203906ea6c","clerk"),  \
                    ("deliveryEmployee1@ezwh.com","name4","surname4","e16b2ab8d12314bf4efbd6203906ea6c","deliveryEmployee"), \
                    ("supplier1@ezwh.com","name5","surname5","e16b2ab8d12314bf4efbd6203906ea6c","supplier"), \
                    ("manager1@ezwh.com","name6","surname6","e16b2ab8d12314bf4efbd6203906ea6c","manager")'
        ]
            ;
        try {
            await this.genericSqlRun(queries[0])
        } catch (error) {

        }
        try {
            await this.genericSqlRun(queries[1])
        } catch (error) {

        }
    }

    async insertUserTestData() {
        const queries = [
            'INSERT INTO Users (email, name, surname, password, type) \
             VALUES  ("user1@ezwh.com","name1","surname1","e16b2ab8d12314bf4efbd6203906ea6c","customer"), \
                    ("qualityEmployee1@ezwh.com", "name2","surname2","e16b2ab8d12314bf4efbd6203906ea6c","qualityEmployee"), \
                    ("clerk1@ezwh.com","name3","surname3","e16b2ab8d12314bf4efbd6203906ea6c","clerk"),  \
                    ("deliveryEmployee1@ezwh.com","name4","surname4","e16b2ab8d12314bf4efbd6203906ea6c","deliveryEmployee"), \
                    ("supplier1@ezwh.com","name5","surname5","e16b2ab8d12314bf4efbd6203906ea6c","supplier"), \
                    ("manager1@ezwh.com","name6","surname6","e16b2ab8d12314bf4efbd6203906ea6c","manager")'
        ];



        return new Promise((resolve, reject) => {
            queries.forEach((query) => {
                this.#db.run(query, (err, rows) => {
                    if (err) {
                        console.log("Database get error: err", err);
                        reject(new Exceptions(500));
                    } else {
                        resolve(rows)
                    }
                });
            });
        })


    }
    async insertSkuTestData() {
        const insertSKU = [`INSERT INTO SKU (id, weight, volume, price, notes, description, availableQuantity)
        VALUES (1, 30, 30, 30, "note", "description", 1);`];



        const insertPosition = ['INSERT INTO Position("positionID", "aisleID", "row", "col", "maxWeight", "maxVolume", "occupiedWeight", "occupiedVolume") \
                                     VALUES ("000000000001","0001", "0001", "0001", 50, 50, 30, 30) \
                                    '];
        const insertPosition2 = ['INSERT INTO Position("positionID", "aisleID", "row", "col", "maxWeight", "maxVolume", "occupiedWeight", "occupiedVolume") \
                                    VALUES ("000000000002","0002", "0002", "0002", 50, 50, 0, 0) \
                                   '];
        const insertPosition3 = ['INSERT INTO Position("positionID", "aisleID", "row", "col", "maxWeight", "maxVolume", "occupiedWeight", "occupiedVolume") \
                                    VALUES ("000000000003","0003", "0003", "0003", 5, 5, 0, 0) \
                                   '];

        const insertSkuInPosition = [' INSERT INTO SKU_in_Position("SKUId", "positionID") \
                                    VALUES (1,"000000000001") \
                                   '];

        const insertQueries = [insertSKU, insertPosition, insertPosition2, insertPosition3, insertSkuInPosition];
        return new Promise((resolve, reject) => {
            insertQueries.forEach((querySet) => {
                querySet.forEach((query) => {
                    this.#db.run(query, (err, rows) => {
                        if (err) {
                            console.log("Database get error: err", err);
                            reject(new Exceptions(500));
                        } else {
                            resolve(rows)
                        }
                    });
                });
            });
        })

    }

    async insertInternalOrderTestData() {
        const insertInternalOrder = [`INSERT INTO InternalOrder(issueDate, state, customerId) VALUES ("2022/03/21", "ISSUED", 3)`];

        const insertSKUPerInternalOrder = [`INSERT INTO SKUPerInternalOrder(id, SKUId, description, price, qty) VALUES (1, 1, "skuPerInternalOrder", 50.00, 20)`];

        const insertQueries = [insertInternalOrder, insertSKUPerInternalOrder];

        return new Promise((resolve, reject) => {
            insertQueries.forEach((querySet) => {
                querySet.forEach((query) => {
                    this.#db.run(query, (err, rows) => {
                        if (err) {
                            console.log("Database get error: err", err);
                            reject(new Exceptions(500));
                        } else {
                            resolve(rows)
                        }
                    });
                });
            });
        });

    } */

}

module.exports = DBManager;