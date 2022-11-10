'use strict'

const axios = require('axios');

class HikeAPICalls {
    #baseURL;

    constructor() {
        this.#baseURL = "http://localhost:3001";
    }

    //GET
    async getHikesTest() {
        const url = this.#baseURL + "/api/hike";
        let response;

        await axios.get(url)
            .then(value => response = value)
            .catch(error => response = error.response);

        return response;
    }

    /* async getItemByIdTest(id, supplierId) {
        const url = this.#baseURL + "/api/items/" + id + "/" +supplierId;
        let response;

        await axios.get(url)
            .then(value => response = value)
            .catch(error => response = error.response);

        return response;
    }

    //POST
    async addHikeTest(id, description, price, SKUId, supplierId) {
        const url = this.#baseURL + "/api/item";
        const body = {
            id: id,
            description: description,
            price: price,
            SKUId: SKUId,
            supplierId: supplierId
        }
        const headers = { headers: { 'Content-Type': 'application/json' } };
        let response;

        await axios.post(url, body, headers)
            .then(value => response = value)
            .catch(error => response = error.response);

        return response;
    }

    //PUT
    async editItemTest(id, supplierId, newDescription, newPrice) {
        const url = this.#baseURL + "/api/item/" + id + "/" + supplierId;
        const body = {
            newDescription: newDescription,
            newPrice: newPrice
        };
        const headers = { headers: { 'Content-Type': 'application/json' } };
        let response;

        await axios.put(url, body, headers)
            .then(value => response = value)
            .catch(error => response = error.response);

        return response;
    }

    //DELETE
    async deleteItemTest(id, supplierId) {
        const url = this.#baseURL + "/api/items/" + id + "/" + supplierId;
        let response;

        await axios.delete(url)
            .then(value => response = value)
            .catch(error => response = error.response);

        return response;
    } */
}

module.exports = HikeAPICalls;