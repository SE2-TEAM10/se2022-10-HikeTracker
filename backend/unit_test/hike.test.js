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
            const gpx_test = "<gpx xmlns=\'http://www.topografix.com/GPX/1/1\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xsi:schemaLocation=\'http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\' version=\'1.1\' creator=\'togpx\'><metadata/><wpt lat=\'44.69919224313921\' lon=\'7.156573534011842\'><name></name><desc>label=Via Roma, Comune di Crissolo,Italia</desc></wpt><wpt lat=\'44.68691664176722\' lon=\'7.160940170288087\'><name></name><desc>label=Tivoli, Comune di Crissolo,Italia</desc></wpt><trk><name></name><desc>ascent=410.9· descent=3.1</desc><trkseg><trkpt lat=\'44.699197\' lon=\'7.156556\'><ele>1343</ele></trkpt><trkpt lat=\'44.699165\' lon=\'7.156541\'><ele>1343</ele></trkpt><trkpt lat=\'44.69908\' lon=\'7.156461\'><ele>1343</ele></trkpt><trkpt lat=\'44.699061\' lon=\'7.156445\'><ele>1343</ele></trkpt><trkpt lat=\'44.699052\' lon=\'7.156468\'><ele>1343</ele></trkpt><trkpt lat=\'44.698914\' lon=\'7.156813\'><ele>1343</ele></trkpt><trkpt lat=\'44.698729\' lon=\'7.157245\'><ele>1343</ele></trkpt><trkpt lat=\'44.698653\' lon=\'7.157484\'><ele>1343</ele></trkpt><trkpt lat=\'44.698604\' lon=\'7.157664\'><ele>1343</ele></trkpt><trkpt lat=\'44.698582\' lon=\'7.157722\'><ele>1343</ele></trkpt><trkpt lat=\'44.698567\' lon=\'7.157762\'><ele>1343</ele></trkpt><trkpt lat=\'44.698524\' lon=\'7.157868\'><ele>1343</ele></trkpt><trkpt lat=\'44.698499\' lon=\'7.157921\'><ele>1343</ele></trkpt><trkpt lat=\'44.698467\' lon=\'7.157966\'><ele>1343</ele></trkpt><trkpt lat=\'44.69836\' lon=\'7.157976\'><ele>1343</ele></trkpt><trkpt lat=\'44.698281\' lon=\'7.158037\'><ele>1343</ele></trkpt><trkpt lat=\'44.698174\' lon=\'7.158085\'><ele>1343</ele></trkpt><trkpt lat=\'44.698063\' lon=\'7.158073\'><ele>1343</ele></trkpt><trkpt lat=\'44.697912\' lon=\'7.158095\'><ele>1343</ele></trkpt><trkpt lat=\'44.697832\' lon=\'7.158128\'><ele>1343</ele></trkpt><trkpt lat=\'44.697755\' lon=\'7.158186\'><ele>1344</ele></trkpt><trkpt lat=\'44.697655\' lon=\'7.158328\'><ele>1344.6</ele></trkpt><trkpt lat=\'44.697563\' lon=\'7.158412\'><ele>1345.1</ele></trkpt><trkpt lat=\'44.697493\' lon=\'7.158467\'><ele>1345.8</ele></trkpt><trkpt lat=\'44.69746\' lon=\'7.158495\'><ele>1346.4</ele></trkpt><trkpt lat=\'44.697369\' lon=\'7.158494\'><ele>1347.1</ele></trkpt><trkpt lat=\'44.697322\' lon=\'7.158527\'><ele>1347.7</ele></trkpt><trkpt lat=\'44.697258\' lon=\'7.158611\'><ele>1348.4</ele></trkpt><trkpt lat=\'44.697142\' lon=\'7.158888\'><ele>1349.7</ele></trkpt><trkpt lat=\'44.697042\' lon=\'7.15932\'><ele>1351.6</ele></trkpt><trkpt lat=\'44.696808\' lon=\'7.159738\'><ele>1354.2</ele></trkpt><trkpt lat=\'44.696785\' lon=\'7.159785\'><ele>1354.9</ele></trkpt><trkpt lat=\'44.696708\' lon=\'7.159852\'><ele>1355.5</ele></trkpt><trkpt lat=\'44.696509\' lon=\'7.160047\'><ele>1355.9</ele></trkpt><trkpt lat=\'44.696447\' lon=\'7.16012\'><ele>1355.9</ele></trkpt><trkpt lat=\'44.696415\' lon=\'7.160183\'><ele>1356.3</ele></trkpt><trkpt lat=\'44.696341\' lon=\'7.160331\'><ele>1356.6</ele></trkpt><trkpt lat=\'44.696245\' lon=\'7.160425\'><ele>1357.1</ele></trkpt><trkpt lat=\'44.696178\' lon=\'7.16024\'><ele>1357.8</ele></trkpt><trkpt lat=\'44.696094\' lon=\'7.160089\'><ele>1358.6</ele></trkpt><trkpt lat=\'44.69597\' lon=\'7.159997\'><ele>1359.4</ele></trkpt><trkpt lat=\'44.695574\' lon=\'7.159946\'><ele>1363.3</ele></trkpt><trkpt lat=\'44.695341\' lon=\'7.159876\'><ele>1368.2</ele></trkpt><trkpt lat=\'44.695177\' lon=\'7.159955\'><ele>1371.2</ele></trkpt><trkpt lat=\'44.695172\' lon=\'7.160447\'><ele>1377.5</ele></trkpt><trkpt lat=\'44.695194\' lon=\'7.160747\'><ele>1380.8</ele></trkpt><trkpt lat=\'44.695129\' lon=\'7.160961\'><ele>1382.5</ele></trkpt><trkpt lat=\'44.695001\' lon=\'7.161069\'><ele>1384.2</ele></trkpt><trkpt lat=\'44.69485\' lon=\'7.161133\'><ele>1385.5</ele></trkpt><trkpt lat=\'44.694722\' lon=\'7.161112\'><ele>1386.9</ele></trkpt><trkpt lat=\'44.694614\' lon=\'7.16124\'><ele>1388.1</ele></trkpt><trkpt lat=\'44.694571\' lon=\'7.161434\'><ele>1389.1</ele></trkpt><trkpt lat=\'44.694314\' lon=\'7.16167\'><ele>1391.5</ele></trkpt><trkpt lat=\'44.694207\' lon=\'7.16182\'><ele>1392.2</ele></trkpt><trkpt lat=\'44.694014\' lon=\'7.161949\'><ele>1393.5</ele></trkpt><trkpt lat=\'44.693906\' lon=\'7.162099\'><ele>1393.1</ele></trkpt><trkpt lat=\'44.69382\' lon=\'7.161927\'><ele>1391.8</ele></trkpt><trkpt lat=\'44.693713\' lon=\'7.162056\'><ele>1390.4</ele></trkpt><trkpt lat=\'44.693658\' lon=\'7.161831\'><ele>1393.9</ele></trkpt><trkpt lat=\'44.693626\' lon=\'7.161824\'><ele>1398.1</ele></trkpt><trkpt lat=\'44.693471\' lon=\'7.161994\'><ele>1408</ele></trkpt><trkpt lat=\'44.69349\' lon=\'7.16175\'><ele>1413</ele></trkpt><trkpt lat=\'44.693412\' lon=\'7.16177\'><ele>1418</ele></trkpt><trkpt lat=\'44.693358\' lon=\'7.161406\'><ele>1428</ele></trkpt><trkpt lat=\'44.693205\' lon=\'7.161594\'><ele>1438</ele></trkpt><trkpt lat=\'44.693168\' lon=\'7.161505\'><ele>1442.9</ele></trkpt><trkpt lat=\'44.693141\' lon=\'7.161623\'><ele>1447.9</ele></trkpt><trkpt lat=\'44.693038\' lon=\'7.16158\'><ele>1452.8</ele></trkpt><trkpt lat=\'44.692991\' lon=\'7.161803\'><ele>1457.8</ele></trkpt><trkpt lat=\'44.692854\' lon=\'7.161688\'><ele>1462.8</ele></trkpt><trkpt lat=\'44.692564\' lon=\'7.161778\'><ele>1478.2</ele></trkpt><trkpt lat=\'44.692369\' lon=\'7.162118\'><ele>1489.9</ele></trkpt><trkpt lat=\'44.692257\' lon=\'7.162172\'><ele>1491.2</ele></trkpt><trkpt lat=\'44.692205\' lon=\'7.162104\'><ele>1492.3</ele></trkpt><trkpt lat=\'44.692165\' lon=\'7.162176\'><ele>1493.3</ele></trkpt><trkpt lat=\'44.691967\' lon=\'7.162163\'><ele>1496.2</ele></trkpt><trkpt lat=\'44.691765\' lon=\'7.162338\'><ele>1500.5</ele></trkpt><trkpt lat=\'44.691781\' lon=\'7.161791\'><ele>1509.7</ele></trkpt><trkpt lat=\'44.691676\' lon=\'7.161821\'><ele>1512.5</ele></trkpt><trkpt lat=\'44.691571\' lon=\'7.161974\'><ele>1515.6</ele></trkpt><trkpt lat=\'44.691399\' lon=\'7.161892\'><ele>1522.3</ele></trkpt><trkpt lat=\'44.691218\' lon=\'7.161292\'><ele>1538.3</ele></trkpt><trkpt lat=\'44.691102\' lon=\'7.161229\'><ele>1540.8</ele></trkpt><trkpt lat=\'44.690988\' lon=\'7.161069\'><ele>1543.8</ele></trkpt><trkpt lat=\'44.690838\' lon=\'7.161172\'><ele>1546.5</ele></trkpt><trkpt lat=\'44.690484\' lon=\'7.161929\'><ele>1559.8</ele></trkpt><trkpt lat=\'44.690372\' lon=\'7.162059\'><ele>1561.6</ele></trkpt><trkpt lat=\'44.690339\' lon=\'7.162265\'><ele>1563.1</ele></trkpt><trkpt lat=\'44.690046\' lon=\'7.162819\'><ele>1569.4</ele></trkpt><trkpt lat=\'44.689862\' lon=\'7.163002\'><ele>1573.1</ele></trkpt><trkpt lat=\'44.689753\' lon=\'7.162984\'><ele>1575.1</ele></trkpt><trkpt lat=\'44.689593\' lon=\'7.163098\'><ele>1577.1</ele></trkpt><trkpt lat=\'44.689264\' lon=\'7.16385\'><ele>1591.8</ele></trkpt><trkpt lat=\'44.688872\' lon=\'7.164096\'><ele>1603</ele></trkpt><trkpt lat=\'44.688263\' lon=\'7.164156\'><ele>1619.3</ele></trkpt><trkpt lat=\'44.687719\' lon=\'7.165193\'><ele>1640.1</ele></trkpt><trkpt lat=\'44.687424\' lon=\'7.165604\'><ele>1649.1</ele></trkpt><trkpt lat=\'44.686876\' lon=\'7.166131\'><ele>1666.6</ele></trkpt><trkpt lat=\'44.686529\' lon=\'7.166283\'><ele>1676.1</ele></trkpt><trkpt lat=\'44.686448\' lon=\'7.166387\'><ele>1678.2</ele></trkpt><trkpt lat=\'44.686333\' lon=\'7.166369\'><ele>1680.7</ele></trkpt><trkpt lat=\'44.686342\' lon=\'7.166112\'><ele>1685.9</ele></trkpt><trkpt lat=\'44.686493\' lon=\'7.165557\'><ele>1695.2</ele></trkpt><trkpt lat=\'44.686644\' lon=\'7.16436\'><ele>1710.9</ele></trkpt><trkpt lat=\'44.686657\' lon=\'7.163818\'><ele>1717.5</ele></trkpt><trkpt lat=\'44.686604\' lon=\'7.163456\'><ele>1720.7</ele></trkpt><trkpt lat=\'44.686604\' lon=\'7.163107\'><ele>1724</ele></trkpt><trkpt lat=\'44.686555\' lon=\'7.16264\'><ele>1729.4</ele></trkpt><trkpt lat=\'44.686737\' lon=\'7.161861\'><ele>1739.9</ele></trkpt><trkpt lat=\'44.686719\' lon=\'7.161711\'><ele>1741.6</ele></trkpt><trkpt lat=\'44.686768\' lon=\'7.161574\'><ele>1743.1</ele></trkpt><trkpt lat=\'44.68679\' lon=\'7.161281\'><ele>1746.2</ele></trkpt><trkpt lat=\'44.686894\' lon=\'7.161146\'><ele>1747.7</ele></trkpt><trkpt lat=\'44.686947\' lon=\'7.161018\'><ele>1749.3</ele></trkpt><trkpt lat=\'44.686945\' lon=\'7.160939\'><ele>1750.8</ele></trkpt></trkseg></trk></gpx>"
            assert.equal(result[0].gpx, gpx_test);


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
