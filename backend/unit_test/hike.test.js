"use strict"

/* UNIT TEST FILE FOR HIKE APIS */
const { expect, assert } = require('chai');
//const dbManager = require('../databaseManager');
const Database = require('../database');

const hikeController = new Database('./hiketracker.db');

/* beforeEach(async () => {
    await dbManager.deleteAllData()
});

afterEach(async () => {
    await dbManager.deleteAllData()
}); */

describe.only('hikeController Tests', () => {

    describe('getAllHikes method test', () => {
        test('successful use of getAllHikes', async () => {

            /* to test the real DB, you need to add filters and to make sure that the number of result is the same on the assert equal */
            let filters = {
                difficulty: "T",
                //start_len : 5,
                //end_len : 15,
                //start_asc : 500,
                //end_asc : 2000,
                //start_time : "00:00",
                //end_time : "30:00"
            };

            const result = await hikeController.getHikeWithFilters(filters);
            assert.equal(result.length, 6);
        })
    })

    describe('addNewHike method test', () => {
        test('successful use of addNewHike', async () => {

            let reqbody = {
                
                "hike": {
                    "name": "Test1",
                    "length": 1,
                    "expected_time": "01:00",
                    "ascent": 111,
                    "difficulty": "T",
                    "start_point": "Testing start1",
                    "end_point": "Testing end",
                    "description": "Description"
                },
                "startp": {
                    "location_name": "Testing start1",
                    "latitude": "45°52'48.7",
                    "longitude": "46°53'49.7",
                    "city": "City1",
                    "province": "Province1"
                },
                "endp": {
                    "location_name": "Testing end1",
                    "latitude": "47°54'49.7",
                    "longitude": "48°55'50.7",
                    "city": "City2",
                    "province": "Province2"
                },
               "gpx": "C://......"
            
        };

            const hike_id = await hikeController.addNewHike(reqbody.hike);
            const newStartpLocation = await hikeController.addNewLocation(reqbody.startp,hike_id);
            const newendpLocation = await hikeController.addNewLocation(reqbody.endp,hike_id);
            //const hikeGPX_id = await hikeController.addNewHikeGPX(reqbody.gpx,hike_id);
            const newLinkHikeUser = await hikeController.linkHikeUser(hike_id,111);

            const result1 = await hikeController.getHikeById(hike_id);

            expect(result1[0].name).toStrictEqual(reqbody.hike.name);
            expect(result1[0].length).toStrictEqual(reqbody.hike.length);
            expect(result1[0].expected_time).toStrictEqual(reqbody.hike.expected_time);
            expect(result1[0].ascent).toStrictEqual(reqbody.hike.ascent);
            expect(result1[0].difficulty).toStrictEqual(reqbody.hike.difficulty);
            expect(result1[0].start_point).toStrictEqual(reqbody.hike.start_point);
            expect(result1[0].end_point).toStrictEqual(reqbody.hike.end_point);
            expect(result1[0].description).toStrictEqual(reqbody.hike.description);

            const result2 = await hikeController.getHikeById(hike_id);
            assert.equal(result2.length,2);
            expect(result2[0].location_name).toStrictEqual(reqbody.startp.location_name);
            expect(result2[0].latitude).toStrictEqual(reqbody.startp.latitude);
            expect(result2[0].longitude).toStrictEqual(reqbody.startp.longitude);
            expect(result2[0].city).toStrictEqual(reqbody.startp.city);
            expect(result2[0].province).toStrictEqual(reqbody.startp.province);
            expect(result2[1].location_name).toStrictEqual(reqbody.endp.location_name);
            expect(result2[1].latitude).toStrictEqual(reqbody.endp.latitude);
            expect(result2[1].latitude).toStrictEqual(reqbody.endp.latitude);
            expect(result2[1].city).toStrictEqual(reqbody.endp.city);
            expect(result2[1].province).toStrictEqual(reqbody.endp.province);

            const result3= await hikeController.getLinkUser(hike_id,111);
            assert.equal(result3.length,1);

        })
    })




    /* describe('getHike method test', () => {
        let errorValue;
        test('successful use of getHike', async () => {
            const sqlInstruction = `INSERT INTO hike (ID, name, length, expected_time, ascent, difficulty, start_point, end_point, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);`;

            await dbManager.genericSqlRun(sqlInstruction, 55, "name1", 10,"05:00", 500, "H", "stPoint", "endPoint", "aDesc")
                .catch(() => { throw error });
            await dbManager.genericSqlRun(sqlInstruction, 100, 50, 10.99, "notes", "first sku", 50)
                .catch(() => { throw error });

            await hikeController.createHike(
                {
                    ID: 65,
                    name: "name65",
                    length: 10,
                    expected_time: "02:00",
                    ascent: 500,
                    difficulty: "T",
                    start_point: "stPoint65",
                    end_point: "endPoint65",
                    description: "Desc65",
                }
            )
            await hikeController.createHike(
                {
                    ID: 66,
                    name: "name66",
                    length: 10,
                    expected_time: "02:00",
                    ascent: 500,
                    difficulty: "T",
                    start_point: "stPoint66",
                    end_point: "endPoint66",
                    description: "Desc66",
                }
            )

            const result = await hikeController.getHike(2);
            assert.equal(result.id, 2)
        })

        test('attempt of getItem with undefined id', async () => {
            await itemController.getItem(undefined, 5).catch(err => errorValue = err);
            assert.equal(errorValue.code, 422)
        })

        test('attempt of getItem with invalid id', async () => {
            await itemController.getItem("hello", 5).catch(err => errorValue = err);
            assert.equal(errorValue.code, 422)
        })

        test('attempt of getItem with non-existant item', async () => {
            await itemController.getItem(1, 5).catch(err => errorValue = err);
            assert.equal(errorValue.code, 404)
        })



    }) */

})