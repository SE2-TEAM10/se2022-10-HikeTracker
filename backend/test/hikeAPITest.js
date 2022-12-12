"use strict"

/* INTEGRATION TEST FILE FOR HIKE APIS */

const chai = require('chai');
const assert = chai.assert;
const expect = chai.expect;
const DBManager = require('../databaseManager');
const HikeAPICalls = require('./hikeAPICalls');

const baseURL = "http://localhost:3001";

const dbmanager = new DBManager();
const hikeAPICalls = new HikeAPICalls();

describe('Hike test suite', async () => {

    describe('Standard Hike getters', async () => {
        it('get all hikes', async () => {
            let response = await hikeAPICalls.getHikesTest();
            assert.equal(response.status, 200);
        });
    });

});