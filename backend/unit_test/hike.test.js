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
                //difficulty: "T",
                //start_len : 5,
                //end_len : 15,
                //start_asc : 500,
                //end_asc : 2000,
                //start_time : "00:00",
                //end_time : "30:00"
            };

            await hikeController.deleteHikeByID(26);
            await hikeController.deleteLocationByHikeID(26);
            await hikeController.deleteLinkHikeUser(26, 111);
            const result = await hikeController.getHikeWithFilters(filters);
            assert.equal(result.length, 25);
        })
    })

    describe('addNewHike method test', () => {
        test('successful use of addNewHike', async () => {

            let reqbody = {

                "hike": {
                    "name": "Test3",
                    "length": 1,
                    "expected_time": "01:00",
                    "ascent": 111,
                    "difficulty": "T",
                    "start_point": "Testing start1",
                    "end_point": "Testing end1",
                    "description": "Description"
                },
                "startp": {
                    "location_name": "Testing start1",
                    "latitude": "45.52487",
                    "longitude": "46.53497",
                    "city": "City1",
                    "province": "Province1"
                },
                "endp": {
                    "location_name": "Testing end1",
                    "latitude": "47.54497",
                    "longitude": "48.55507",
                    "city": "City2",
                    "province": "Province2"
                },
                "gpx": "C://......"

            };

            const hike_id = await hikeController.addNewHike(reqbody.hike);

            console.log("hike ID", hike_id);
            
            const newStartpLocation = await hikeController.addNewLocation(reqbody.startp, hike_id);
            const newendpLocation = await hikeController.addNewLocation(reqbody.endp, hike_id);
            //const hikeGPX_id = await hikeController.addNewHikeGPX(reqbody.gpx,hike_id);
            const newLinkHikeUser = await hikeController.linkHikeUser(hike_id, 111);

            const result1 = await hikeController.getHikeById(hike_id);

            assert.equal(result1.name, reqbody.hike.name);
            assert.equal(result1.length, reqbody.hike.length);
            assert.equal(result1.expected_time, reqbody.hike.expected_time);
            assert.equal(result1.ascent, reqbody.hike.ascent);
            assert.equal(result1.difficulty, reqbody.hike.difficulty);
            assert.equal(result1.start_point, reqbody.hike.start_point);
            assert.equal(result1.end_point, reqbody.hike.end_point);
            assert.equal(result1.description, reqbody.hike.description);

            const result2 = await hikeController.getLocationByHikeId(hike_id);

            assert.equal(result2.length, 2);

            assert.equal(result2[0].location_name, reqbody.startp.location_name);
            assert.equal(result2[0].latitude, reqbody.startp.latitude);
            assert.equal(result2[0].longitude, reqbody.startp.longitude);
            assert.equal(result2[0].city, reqbody.startp.city);
            assert.equal(result2[0].province, reqbody.startp.province);
            assert.equal(result2[1].location_name, reqbody.endp.location_name);
            assert.equal(result2[1].latitude, reqbody.endp.latitude);
            assert.equal(result2[1].longitude, reqbody.endp.longitude);
            assert.equal(result2[1].city, reqbody.endp.city);
            assert.equal(result2[1].province, reqbody.endp.province);


            const result3 = await hikeController.getLinkUser(hike_id, 111);
            assert.equal(result3.length, 1);

        })

        test('try to insert new hike with wrong params', async () => {

            let reqbody = {

                "hike": {
                    "name": 3,
                    "length": "1",
                    "expected_time": "01:00",
                    "ascent": 111,
                    "difficulty": "T",
                    "start_point": "Testing start1",
                    "end_point": "Testing end",
                    "description": "Description"
                },
                "startp": {
                    "location_name": "Testing start1",
                    "latitude": "45.52487",
                    "longitude": "46.53497",
                    "city": "City1",
                    "province": "Province1"
                },
                "endp": {
                    "location_name": "Testing end1",
                    "latitude": "47.54497",
                    "longitude": "48.55507",
                    "city": "City2",
                    "province": "Province2"
                },
                "gpx": "C://......"

            };

            const hike_id = await hikeController.addNewHike(reqbody.hike).catch(() => { });
            const result = await hikeController.getHikeById(hike_id);

            expect(result).to.be.undefined;

        })

        test('try to insert a location with wrong params', async () => {
            let reqbody = {
                "startp": {
                    "location_name": 2,
                    "latitude": 4,
                    "longitude": 6,
                    "city": "City1",
                    "province": "Province1"
                }
            };

            const result = await hikeController.addNewLocation(reqbody, "hike").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to insert a location with empty params', async () => {

            let reqbody = {
                "startp": {
                }
            };

            const result = await hikeController.addNewLocation(reqbody, 100).catch(() => { });
            expect(result).to.be.undefined;

        })

        test('try to link user and hike with wrong params', async () => {

            let hike_id = "hikeID";
            let user_id = "userID"

            const result = await hikeController.linkHikeUser(hike_id, user_id).catch(() => {});
            expect(result).to.be.undefined;

        })

        test('try to link user and hike with empty params', async () => {

            const result = await hikeController.addNewLocation().catch(() => { });
            expect(result).to.be.undefined;

        })
    })


})
