"use strict"

/* UNIT TEST FILE FOR HIKE APIS */
const { expect, assert } = require('chai');
const Database = require('../database');

const hikeController = new Database('./hiketracker.db');

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

            await hikeController.deleteLocationByHikeID(51);
            await hikeController.deleteGpxByHikeID(51);
            await hikeController.deleteHikeByID(51);
            const result = await hikeController.getHikeWithFilters(filters);
            assert.equal(result.length, 50);
        })
    })

    describe('addNewHike method test', () => {
        test('successful use of addNewHike', async () => {

            let reqbody = {

                "hike": {
                    "name": "TestTest",
                    "expected_time": "01:00",
                    "difficulty": "T",
                    "description": "Description"
                },
                "startp": {
                    "location_name": "Testing start1",
                    "city": "City1",
                    "province": "Province1"
                },
                "endp": {
                    "location_name": "Testing end1",
                    "city": "City2",
                    "province": "Province2"
                },
                "gpx": "test_gpx_string"

            };

            let user_ID = 3;
            const hike_ID = await hikeController.addNewHike(reqbody.hike, reqbody.gpx, user_ID);

            const newStartpLocation = await hikeController.addNewLocation(reqbody.startp, "start", hike_ID, reqbody.gpx);

            const newEndpLocation = await hikeController.addNewLocation(reqbody.endp, "end", hike_ID, reqbody.gpx);

            const hikeGPX_ID = await hikeController.addNewHikeGPX(reqbody.gpx, hike_ID);

            const result1 = await hikeController.getHikeByID(hike_ID);

            assert.equal(result1.name, reqbody.hike.name);
            assert.equal(result1.expected_time, reqbody.hike.expected_time);
            assert.equal(result1.difficulty, reqbody.hike.difficulty);
            assert.equal(result1.description, reqbody.hike.description);
            assert.equal(result1.user_ID, 3);

            const result2 = await hikeController.getLocationByHikeID(hike_ID);

            assert.equal(result2.length, 2);

            assert.equal(result2[0].location_name, reqbody.startp.location_name);
            assert.equal(result2[0].city, reqbody.startp.city);
            assert.equal(result2[0].province, reqbody.startp.province);
            assert.equal(result2[1].location_name, reqbody.endp.location_name);
            assert.equal(result2[1].city, reqbody.endp.city);
            assert.equal(result2[1].province, reqbody.endp.province);

            const result4 = await hikeController.getGpxByHikeID(hike_ID);
            assert.equal(result4.length, 1);

        })

        test('try to insert a hike with wrong params', async () => {

            let reqbody = {

                "hike": {
                    "name": 3,
                    "length": "1",
                    "expected_time": "01:00",
                    "ascent": 111,
                    "difficulty": "T",
                    "description": "Description"
                },

                "gpx": "XML STRING"

            };

            const hike_ID = await hikeController.addNewHike(reqbody.hike, reqbody.gpx, "userID").catch(() => { });
            const result = await hikeController.getHikeByID(hike_ID).catch(() => { });

            expect(result).to.be.undefined;

        })

        test('try to insert a hike with empty params', async () => {

            const result = await hikeController.addNewHike().catch(() => { });
            expect(result).to.be.undefined;

        })

        test('try to insert a location with wrong params', async () => {
            let reqbody = {
                "startp": {
                    "location_name": 2,
                    "city": "City1",
                    "province": "Province1",
                    "position": "middle"
                }
            };

            const result = await hikeController.addNewLocation(reqbody, "hike").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to insert a location with empty params', async () => {

            const result = await hikeController.addNewLocation().catch(() => { });
            expect(result).to.be.undefined;

        })

        test('try to insert a gpx file with wrong params', async () => {
            let reqbody = {
                "gpx": 33
            };

            const result = await hikeController.addNewHikeGPX(reqbody, "hike").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to insert a gpx file with empty params', async () => {

            const result = await hikeController.addNewHikeGPX().catch(() => { });
            expect(result).to.be.undefined;

        })
    })

    describe('addUser method test', () => {
        test('successful use of addUser', async () => {

            let reqbody = {
                name: "testName",
                surname: "testSurname",
                mail: "test@hike.it",
                password: "Localguide1!",
                salt: "f4df7b66d7",
                role: "LocalGuide",
                verified: 0
            };

            await hikeController.deleteUserByID(11);
            await hikeController.addUser(reqbody);

            const result = await hikeController.getUserByID(11);

            /*password and salt cannot be tested, since they are crypted and they will never match the ones in the JSON */
            assert.equal(result.name, reqbody.name);
            assert.equal(result.surname, reqbody.surname);
            assert.equal(result.mail, reqbody.mail);
            assert.equal(result.role, reqbody.role);
            assert.equal(result.verified, reqbody.verified);

        })

        test('try to add user with wrong params', async () => {
            let user = {
                name: "testName2",
                surname: "testSurname2",
                mail: 23456,
                password: "password",
                salt: 23456,
            };

            const result = await hikeController.addUser(user).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add user with empty params', async () => {

            const result = await hikeController.addUser().catch(() => { });
            expect(result).to.be.undefined;

        })
    })

    describe('setVerified method test', () => {
        test('successful use of set verified from 0 to 1', async () => {

            await hikeController.setVerifiedBack(11);
            await hikeController.setVerified(11);
            const result = await hikeController.getUserByID(11);

            assert.equal(result.verified, 1);

        })

        test('try to set verified with wrong params', async () => {

            await hikeController.setVerifiedBack(11);

            const result = await await hikeController.setVerified("wrong parms").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to set verified with empty params', async () => {

            await hikeController.setVerifiedBack(11);

            const result = await await hikeController.setVerified().catch(() => { });
            expect(result).to.be.undefined;

        })
    })

    describe('getHikesDetailsByHikeID method test', () => {
        test('successful use of getting hikes details by hike ID', async () => {

            const result = await hikeController.getHikesDetailsByHikeID(1);

            assert.equal(result[0].name, "Monte Tivoli");
            assert.equal(result[0].length, 5);
            assert.equal(result[0].expected_time, "02:00");
            assert.equal(result[0].ascent, 410);
            assert.equal(result[0].difficulty, "T");
            assert.equal(result[0].description, "Really easy and frequented hike, with really low possibility of errors");
            assert.equal(result[0].location[0].name, "Crissolo");
            assert.equal(result[0].location[0].latitude, 44.699197);
            assert.equal(result[0].location[0].longitude, 7.156556);
            assert.equal(result[0].location[0].city, "Crissolo");
            assert.equal(result[0].location[0].province, "Cuneo");
            assert.equal(result[0].location[1].name, "Monte Tivoli");
            assert.equal(result[0].location[1].latitude, 44.686945);
            assert.equal(result[0].location[1].longitude, 7.160939);
            assert.equal(result[0].location[1].city, "Crissolo");
            assert.equal(result[0].location[1].province, "Cuneo");


        })

        test('try to get hikes details with wrong params', async () => {

            const result = await hikeController.getHikesDetailsByHikeID("wrong parms").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to get hikes details with empty params', async () => {

            const result = await hikeController.getHikesDetailsByHikeID().catch(() => { });
            expect(result).to.be.undefined;

        })
    })

    describe('addHut method test', () => {
        test('successful use of addHut', async () => {

            let reqbody = {
                name: "testHut",
                description: "aDesc",
                opening_time: "09:00",
                closing_time: "22:00",
                bed_num: 3,
                altitude: 1000,
                latitude: 45.029439,
                longitude: 7.79784,
                city: "Lecce",
                province: "Lecce",
                phone: "1111111111",
                mail: "testhut@hut.it",
                website: "testhut.it"
            };

            await hikeController.deleteHutByID(21);

            let user_ID = 3;

            const hut_ID = await hikeController.addHut(reqbody, user_ID);

            const result = await hikeController.getHutByID(hut_ID);

            assert.equal(result.name, reqbody.name);
            assert.equal(result.description, reqbody.description);
            assert.equal(result.opening_time, reqbody.opening_time);
            assert.equal(result.closing_time, reqbody.closing_time);
            assert.equal(result.bed_num, reqbody.bed_num);
            assert.equal(result.altitude, reqbody.altitude);
            assert.equal(result.latitude, reqbody.latitude);
            assert.equal(result.longitude, reqbody.longitude);
            assert.equal(result.city, reqbody.city);
            assert.equal(result.province, reqbody.province);
            assert.equal(result.phone, reqbody.phone);
            assert.equal(result.mail, reqbody.mail);
            assert.equal(result.website, reqbody.website);

        })

        test('try to add hut with wrong params', async () => {
            let hut = {
                name: 33,
                description: 33,
                opening_time: "dasda",
                closing_time: "dasd",
                bed_num: 3,
                altitude: 3,
                latitude: 45.029439,
                longitude: 7.79784,
                city: "Lecce",
                province: "Lecce",
                phone: "45454",
                mail: "43434",
                website: "3434343"
            };

            const result = await hikeController.addHut(hut, "user").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add hut with empty params', async () => {

            const result = await hikeController.addHut().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('addParking method test', () => {
        test('successful use of addParking', async () => {

            let reqbody = {
                name: "Parking_lot_1",
                capacity: 100,
                latitude: 45.111111,
                longitude: 7.22222,
                city: "Lecce",
                province: "Lecce"
            };

            await hikeController.deleteParkingLotByID(6);

            let user_ID = 3;
            const parking_lot_ID = await hikeController.addParking(reqbody, user_ID);

            const result = await hikeController.getParkingLotByID(parking_lot_ID);

            assert.equal(result.name, reqbody.name);
            assert.equal(result.capacity, reqbody.capacity);
            assert.equal(result.latitude, reqbody.latitude);
            assert.equal(result.longitude, reqbody.longitude);
            assert.equal(result.city, reqbody.city);
            assert.equal(result.province, reqbody.province);

        })

        test('try to add parking lot with wrong params', async () => {
            let reqbody2 = {
                name: "Parking lot testing",
                capacity: 100,
                latitude: 45.111111,
                longitude: 7.22222,
                city: 40,
                province: 41
            };

            const result = await hikeController.addParking(reqbody2, "user").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add parking with empty params', async () => {

            const result = await hikeController.addParking().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('getHutsWithFilters method test', () => {
        test('successful use of getHutsWithFilters', async () => {

            /* to test the real DB, you need to add filters and to make sure that the number of result is the same on the assert equal */
            let filters = {
                //min_opening_time: "06:00",
                //max_opening_time: "10:00",
                //min_closing_time: "19:00",
                //max_closing_time: "23:00",
                //min_bed_num: 3,
                //max_bed_num: 55,
                //min_altitude: 10,
                //max_altitude: 5000,
                //city: "Lecce",
                //province: "Lecce"
            };

            const result = await hikeController.getHutsWithFilters(filters);
            assert.equal(result.length, 21);
        })
    })

    describe('addHikeUserHut method test', () => {
        test('successful use of add a hut as start/arrival point for hike', async () => {

            let reqbody = {
                hike_ID: 1,
                hut_ID: 2,
                ref_type: "test_point_hut"
            };

            await hikeController.deleteHikeUserHut(1, 1, 2);

            const user_ID = 1;

            await hikeController.addHikeUserHut(reqbody.hike_ID, user_ID, reqbody.hut_ID, reqbody.ref_type);

            const result = await hikeController.getHikeUserHut(reqbody.hike_ID, user_ID, reqbody.hut_ID);

            assert.equal(result[0].hike_ID, reqbody.hike_ID);
            assert.equal(result[0].user_ID, user_ID);
            assert.equal(result[0].hut_ID, reqbody.hut_ID);
            assert.equal(result[0].ref_type, reqbody.ref_type);

        })

        test('try to add a hut as start/arrival point for a hike with wrong params', async () => {

            let reqbody = {
                hike_ID: "hike_ID",
                hut_ID: "hut_ID",
                ref_type: "test_point_hut"
            };

            const user_ID = 1;

            const result = await hikeController.addHikeUserHut(reqbody.hike_ID, user_ID, reqbody.hut_ID, reqbody.ref_type).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to a hut as start/arrival point for a hike with empty params', async () => {

            const result = await hikeController.addHikeUserHut().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('addHikeUserParking method test', () => {
        test('successful use of add a parking lot as start/arrival point for hike', async () => {

            let reqbody = {
                hike_ID: 1,
                parking_ID: 2,
                ref_type: "test_point_parking"
            };

            await hikeController.deleteHikeUserParking(1, 1, 2);

            const user_ID = 1;

            await hikeController.addHikeUserParking(reqbody.hike_ID, user_ID, reqbody.parking_ID, reqbody.ref_type);

            const result = await hikeController.getHikeUserParking(reqbody.hike_ID, user_ID, reqbody.parking_ID);

            assert.equal(result[0].hike_ID, reqbody.hike_ID);
            assert.equal(result[0].user_ID, user_ID);
            assert.equal(result[0].parking_ID, reqbody.parking_ID);
            assert.equal(result[0].ref_type, reqbody.ref_type);

        })

        test('try to add a parking lot as start/arrival point for a hike with wrong params', async () => {

            let reqbody = {
                hike_ID: "hike_ID",
                parking_ID: "parking_ID",
                ref_type: "test_point_parking"
            };

            const user_ID = 1;

            const result = await hikeController.addHikeUserParking(reqbody.hike_ID, user_ID, reqbody.parking_ID, reqbody.ref_type).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to a parking lot as start/arrival point for a hike with empty params', async () => {

            const result = await hikeController.addHikeUserParking().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('addSchedule method test', () => {
        test('successful use of addSchedule', async () => {

            let reqbody = {
                start_time: "2022-01-03 22:00",
                duration: "on going",
                hike_ID: 16,
            };

            await hikeController.deleteScheduleByID(5);

            const user_ID = 7;

            const schedule_ID = await hikeController.addSchedule(reqbody, user_ID);

            const result = await hikeController.getScheduleByID(schedule_ID);

            assert.equal(result.start_time, reqbody.start_time);
            assert.equal(result.end_time, "on going");
            assert.equal(result.status, "on going");
            assert.equal(result.duration, "on going");
            assert.equal(result.hike_ID, reqbody.hike_ID);
            assert.equal(result.user_ID, user_ID);

        })

        test('try to add a scheduled hike with wrong params', async () => {

            let reqbody = {
                start_time: 3,
                duration: 3,
                hike_ID: "hike_ID"
            };

            const user_ID = "user_ID";

            const result = await hikeController.addSchedule(reqbody, user_ID).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add a scheduled hike with empty params', async () => {

            const result = await hikeController.addSchedule().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('updateSchedule method test', () => {
        test('successful use of updateSchedule', async () => {

            let reqbody = {
                ID: 5,
                end_time: "2022-01-04 23:00",
            };

            const schedule = await hikeController.getScheduleByID(reqbody.ID);
            await hikeController.updateSchedule(reqbody.ID, reqbody.end_time, "1D 1h");
            
            const result = await hikeController.getScheduleByID(reqbody.ID);

            assert.equal(result.end_time, reqbody.end_time);
            assert.equal(result.status, "completed");
            assert.equal(result.duration, "1D 1h");

        })

        test('try to update a scheduled hike with wrong params', async () => {

            let reqbody = {
                ID: "ID",
                end_time: 2022,
            };

            const result = await hikeController.updateSchedule(reqbody.ID, reqbody.end_time, 33).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add a scheduled hike with empty params', async () => {

            const result = await hikeController.updateSchedule().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('getCompletedHikes method test', () => {
        test('successful use of getCompletedHikes', async () => {

            let user_ID = 5;

            const result = await hikeController.getCompletedHikesByUserID(user_ID);
            
            assert.equal(result.length, 2);

        })

        test('try to get the completed hikes with wrong params', async () => {

            let user_ID = "user_ID"

            const result = await hikeController.getCompletedHikesByUserID(user_ID).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to get the completed hikes with empty params', async () => {

            const result = await hikeController.getCompletedHikesByUserID().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('addHikeUserHut HT-9 method test', () => {
        test('successful use of add a hut as a point for hike', async () => {

            let reqbody = {
                hike_ID: 5,
                hut_ID: 5,
                ref_type: "generic point"
            };

            await hikeController.deleteHikeUserHut(5, 1, 5);

            const user_ID = 1;

            await hikeController.addHikeUserHut(reqbody.hike_ID, user_ID, reqbody.hut_ID, reqbody.ref_type);

            const result = await hikeController.getHikeUserHut(reqbody.hike_ID, user_ID, reqbody.hut_ID);

            assert.equal(result[0].hike_ID, reqbody.hike_ID);
            assert.equal(result[0].user_ID, user_ID);
            assert.equal(result[0].hut_ID, reqbody.hut_ID);
            assert.equal(result[0].ref_type, reqbody.ref_type);

        })

        test('try to add a hut as a point for a hike with wrong params', async () => {

            let reqbody = {
                hike_ID: "hike_ID",
                hut_ID: "hut_ID",
                ref_type: "generic point"
            };

            const user_ID = 1;

            const result = await hikeController.addHikeUserHut(reqbody.hike_ID, user_ID, reqbody.hut_ID, reqbody.ref_type).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add a hut as a point for a hike with empty params', async () => {

            const result = await hikeController.addHikeUserHut().catch(() => { });
            expect(result).to.be.undefined;

        })

    })


    describe('addReferencePoint HT-33 method test', () => {
        test('successful use of addReferencePoint', async () => {

            let reqbody = {
                name: "Testing Reference Point",
                type: "village",
                latitude: 45.111111,
                longitude: 7.22222,
                city: "Lecce",
                province: "Lecce"
            };

            await hikeController.deleteReferencePointByID(18);

            let user_ID = 3;
            const reference_point_ID = await hikeController.addReferencePoint(reqbody, user_ID);

            const result = await hikeController.getReferencePointByID(reference_point_ID);

            assert.equal(result.name, reqbody.name);
            assert.equal(result.type, reqbody.type);
            assert.equal(result.latitude, reqbody.latitude);
            assert.equal(result.longitude, reqbody.longitude);
            assert.equal(result.city, reqbody.city);
            assert.equal(result.province, reqbody.province);assert.equal(result.user_ID, user_ID);

        })

        test('try to add reference point with wrong params', async () => {
            let reqbody2 = {
                name: "Parking lot testing",
                type: 100,
                latitude: 45.111111,
                longitude: 7.22222,
                city: 40,
                province: 41
            };

            const result = await hikeController.addReferencePoint(reqbody2, "user").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add reference point with empty params', async () => {

            const result = await hikeController.addReferencePoint().catch(() => { });
            expect(result).to.be.undefined;

        })

    })
    

    describe('addHikeUserRef method test', () => {
        test('successful use of add a reference point for a hike', async () => {

            let reqbody = {
                hike_ID: 1,
                ref_ID: 2,
                ref_type: "point"
            };

            await hikeController.deleteHikeUserReferencePoint(1, 1, 2);

            const user_ID = 1;

            await hikeController.addHikeUserRef(reqbody.hike_ID, user_ID, reqbody.ref_ID, reqbody.ref_type);

            const result = await hikeController.getHikeUserRef(reqbody.hike_ID, user_ID, reqbody.ref_ID);

            assert.equal(result[0].hike_ID, reqbody.hike_ID);
            assert.equal(result[0].user_ID, user_ID);
            assert.equal(result[0].ref_ID, reqbody.ref_ID);
            assert.equal(result[0].ref_type, reqbody.ref_type);

        })

        test('try to add a reference point for a hike with wrong params', async () => {

            let reqbody = {
                hike_ID: "hike_ID",
                ref_ID: "ref_ID",
                ref_type: "point"
            };

            const user_ID = 1;

            const result = await hikeController.addHikeUserRef(reqbody.hike_ID, user_ID, reqbody.ref_ID, reqbody.ref_type).catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to a reference point for a hike with empty params', async () => {

            const result = await hikeController.addHikeUserRef().catch(() => { });
            expect(result).to.be.undefined;

        })

    })

    describe('addRefReached method test', () => {
        test('successful use of addRefReached', async () => {

            let reqbody = {
                hike_ID: 16,
                user_ID: 7,
                ref_ID: 5
            };

            await hikeController.deleteRefReached(reqbody.hike_ID, reqbody.user_ID, reqbody.ref_ID);
            await hikeController.addRefReached(reqbody.hike_ID, reqbody.user_ID, reqbody.ref_ID);
            
            const result = await hikeController.getRefReached(reqbody.hike_ID, reqbody.user_ID, reqbody.ref_ID);

            console.log("addRefReached result: ", result);
            
            assert.equal(result[0].hike_ID, reqbody.hike_ID);
            assert.equal(result[0].user_ID, reqbody.user_ID);
            assert.equal(result[0].ref_ID, reqbody.ref_ID);
            assert.equal(result[0].state, 0);

        })

        test('try to add reference reached with wrong params', async () => {

            const result = await hikeController.addRefReached("hike_ID", "user_ID", "ref_ID").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to add reference with empty params', async () => {

            const result = await hikeController.addRefReached().catch(() => { });
            expect(result).to.be.undefined;

        })
    })

    describe('updateRefReached method test', () => {
        test('successful use of updateRefReached', async () => {

            let reqbody = {
                hike_ID: 16,
                user_ID: 7,
                ref_ID: 5
            };

            await hikeController.updateRefReached(reqbody.hike_ID, reqbody.user_ID, reqbody.ref_ID);
            
            const result = await hikeController.getRefReached(reqbody.hike_ID, reqbody.user_ID, reqbody.ref_ID);

            console.log("\n\nupdateRefReached result: ", result);

            assert.equal(result[0].hike_ID, reqbody.hike_ID);
            assert.equal(result[0].user_ID, reqbody.user_ID);
            assert.equal(result[0].ref_ID, reqbody.ref_ID);
            assert.equal(result[0].state, 1);

        })

        test('try to update reference reached with wrong params', async () => {

            const result = await hikeController.updateRefReached("hike_ID", "user_ID", "ref_ID").catch(() => { });
            expect(result).to.be.undefined;
        })

        test('try to update reference with empty params', async () => {

            const result = await hikeController.updateRefReached().catch(() => { });
            expect(result).to.be.undefined;

        })
    })
})
