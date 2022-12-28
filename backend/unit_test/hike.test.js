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
                "gpx": "<?xml version='1.0' encoding='UTF-8' standalone='no'?><gpx xmlns='http://www.topografix.com/GPX/1/1' creator='BYT 1.0' version='1.1' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd'>\t<metadata>\t\t<bounds minlat='45.297039' maxlat='45.307403' minlon='7.143238' maxlon='7.164867'/>\t</metadata>\t<wpt lat='45.302683' lon='7.155104'>\t\t<ele>2181.000000</ele>\t\t<name>Bivio 222-223</name>\t</wpt>\t<wpt lat='45.306326' lon='7.164873'>\t\t<name>Parcheggio Rif. Ciri�</name>\t</wpt>\t<wpt lat='45.297693' lon='7.143376'>\t\t<ele>2667.914315</ele>\t\t<name>Rifugio Gastaldi</name>\t</wpt>\t<trk>\t\t<name>ACTIVE LOG</name>\t\t<trkseg>\t\t\t<trkpt lat='45.306330' lon='7.164867'>\t\t\t\t<ele>1768.967703</ele>\t\t\t\t<time>2000-01-01T00:00:00+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.164674'>\t\t\t\t<ele>1771.832823</ele>\t\t\t\t<time>2000-01-01T00:00:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.164459'>\t\t\t\t<ele>1775.216103</ele>\t\t\t\t<time>2000-01-01T00:00:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.164330'>\t\t\t\t<ele>1775.703783</ele>\t\t\t\t<time>2000-01-01T00:00:42+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.164309'>\t\t\t\t<ele>1776.160983</ele>\t\t\t\t<time>2000-01-01T00:00:46+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306351' lon='7.164030'>\t\t\t\t<ele>1778.081223</ele>\t\t\t\t<time>2000-01-01T00:01:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306244' lon='7.163773'>\t\t\t\t<ele>1780.031943</ele>\t\t\t\t<time>2000-01-01T00:01:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306180' lon='7.163494'>\t\t\t\t<ele>1781.952183</ele>\t\t\t\t<time>2000-01-01T00:01:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306201' lon='7.163301'>\t\t\t\t<ele>1785.304983</ele>\t\t\t\t<time>2000-01-01T00:02:19+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306244' lon='7.163022'>\t\t\t\t<ele>1788.200583</ele>\t\t\t\t<time>2000-01-01T00:02:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306287' lon='7.162635'>\t\t\t\t<ele>1791.065703</ele>\t\t\t\t<time>2000-01-01T00:03:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306287' lon='7.162292'>\t\t\t\t<ele>1792.041063</ele>\t\t\t\t<time>2000-01-01T00:03:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306265' lon='7.161970'>\t\t\t\t<ele>1795.393863</ele>\t\t\t\t<time>2000-01-01T00:03:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306287' lon='7.161713'>\t\t\t\t<ele>1797.801782</ele>\t\t\t\t<time>2000-01-01T00:04:13+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306201' lon='7.161434'>\t\t\t\t<ele>1799.234342</ele>\t\t\t\t<time>2000-01-01T00:04:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306115' lon='7.161133'>\t\t\t\t<ele>1802.617622</ele>\t\t\t\t<time>2000-01-01T00:04:58+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306222' lon='7.160919'>\t\t\t\t<ele>1804.050182</ele>\t\t\t\t<time>2000-01-01T00:05:16+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306330' lon='7.160833'>\t\t\t\t<ele>1805.970422</ele>\t\t\t\t<time>2000-01-01T00:05:29+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306265' lon='7.160511'>\t\t\t\t<ele>1807.402982</ele>\t\t\t\t<time>2000-01-01T00:05:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306201' lon='7.160232'>\t\t\t\t<ele>1807.890662</ele>\t\t\t\t<time>2000-01-01T00:06:13+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306351' lon='7.160082'>\t\t\t\t<ele>1810.786262</ele>\t\t\t\t<time>2000-01-01T00:06:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306458' lon='7.159889'>\t\t\t\t<ele>1813.194182</ele>\t\t\t\t<time>2000-01-01T00:06:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306394' lon='7.159674'>\t\t\t\t<ele>1816.546982</ele>\t\t\t\t<time>2000-01-01T00:07:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.159503'>\t\t\t\t<ele>1818.467222</ele>\t\t\t\t<time>2000-01-01T00:07:19+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306523' lon='7.159395'>\t\t\t\t<ele>1819.899782</ele>\t\t\t\t<time>2000-01-01T00:07:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306587' lon='7.159352'>\t\t\t\t<ele>1823.283062</ele>\t\t\t\t<time>2000-01-01T00:08:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306652' lon='7.159266'>\t\t\t\t<ele>1826.148182</ele>\t\t\t\t<time>2000-01-01T00:08:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306737' lon='7.159181'>\t\t\t\t<ele>1829.531461</ele>\t\t\t\t<time>2000-01-01T00:08:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306780' lon='7.159052'>\t\t\t\t<ele>1831.939381</ele>\t\t\t\t<time>2000-01-01T00:09:19+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306823' lon='7.158880'>\t\t\t\t<ele>1833.371941</ele>\t\t\t\t<time>2000-01-01T00:09:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306845' lon='7.158816'>\t\t\t\t<ele>1834.804501</ele>\t\t\t\t<time>2000-01-01T00:09:45+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306866' lon='7.158666'>\t\t\t\t<ele>1835.292181</ele>\t\t\t\t<time>2000-01-01T00:09:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306888' lon='7.158558'>\t\t\t\t<ele>1836.267541</ele>\t\t\t\t<time>2000-01-01T00:10:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306845' lon='7.158515'>\t\t\t\t<ele>1839.620341</ele>\t\t\t\t<time>2000-01-01T00:10:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306845' lon='7.158408'>\t\t\t\t<ele>1842.515941</ele>\t\t\t\t<time>2000-01-01T00:11:00+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306866' lon='7.158301'>\t\t\t\t<ele>1845.868741</ele>\t\t\t\t<time>2000-01-01T00:11:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306909' lon='7.158258'>\t\t\t\t<ele>1845.868741</ele>\t\t\t\t<time>2000-01-01T00:11:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307016' lon='7.158151'>\t\t\t\t<ele>1848.764341</ele>\t\t\t\t<time>2000-01-01T00:11:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307081' lon='7.158043'>\t\t\t\t<ele>1850.684581</ele>\t\t\t\t<time>2000-01-01T00:11:59+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307167' lon='7.157915'>\t\t\t\t<ele>1852.117141</ele>\t\t\t\t<time>2000-01-01T00:12:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307252' lon='7.157807'>\t\t\t\t<ele>1855.012741</ele>\t\t\t\t<time>2000-01-01T00:12:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307295' lon='7.157700'>\t\t\t\t<ele>1857.390181</ele>\t\t\t\t<time>2000-01-01T00:12:59+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307317' lon='7.157700'>\t\t\t\t<ele>1855.469941</ele>\t\t\t\t<time>2000-01-01T00:13:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307403' lon='7.157829'>\t\t\t\t<ele>1856.445301</ele>\t\t\t\t<time>2000-01-01T00:13:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157786'>\t\t\t\t<ele>1856.445301</ele>\t\t\t\t<time>2000-01-01T00:13:31+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157764'>\t\t\t\t<ele>1859.798100</ele>\t\t\t\t<time>2000-01-01T00:14:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157764'>\t\t\t\t<ele>1863.181380</ele>\t\t\t\t<time>2000-01-01T00:14:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157764'>\t\t\t\t<ele>1863.181380</ele>\t\t\t\t<time>2000-01-01T00:14:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157764'>\t\t\t\t<ele>1867.509540</ele>\t\t\t\t<time>2000-01-01T00:15:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157764'>\t\t\t\t<ele>1867.021860</ele>\t\t\t\t<time>2000-01-01T00:15:14+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157743'>\t\t\t\t<ele>1874.702820</ele>\t\t\t\t<time>2000-01-01T00:16:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307338' lon='7.157743'>\t\t\t\t<ele>1874.215140</ele>\t\t\t\t<time>2000-01-01T00:16:26+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307317' lon='7.157743'>\t\t\t\t<ele>1877.598420</ele>\t\t\t\t<time>2000-01-01T00:16:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307295' lon='7.157700'>\t\t\t\t<ele>1879.030980</ele>\t\t\t\t<time>2000-01-01T00:17:09+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307231' lon='7.157679'>\t\t\t\t<ele>1882.383780</ele>\t\t\t\t<time>2000-01-01T00:17:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307317' lon='7.157571'>\t\t\t\t<ele>1885.279380</ele>\t\t\t\t<time>2000-01-01T00:18:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307295' lon='7.157528'>\t\t\t\t<ele>1887.199620</ele>\t\t\t\t<time>2000-01-01T00:18:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307252' lon='7.157507'>\t\t\t\t<ele>1888.632180</ele>\t\t\t\t<time>2000-01-01T00:18:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307274' lon='7.157421'>\t\t\t\t<ele>1890.582900</ele>\t\t\t\t<time>2000-01-01T00:18:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307252' lon='7.157378'>\t\t\t\t<ele>1893.935699</ele>\t\t\t\t<time>2000-01-01T00:19:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307188' lon='7.157335'>\t\t\t\t<ele>1897.288499</ele>\t\t\t\t<time>2000-01-01T00:19:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307124' lon='7.157357'>\t\t\t\t<ele>1900.184099</ele>\t\t\t\t<time>2000-01-01T00:20:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307059' lon='7.157314'>\t\t\t\t<ele>1902.104339</ele>\t\t\t\t<time>2000-01-01T00:20:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307059' lon='7.157207'>\t\t\t\t<ele>1904.999939</ele>\t\t\t\t<time>2000-01-01T00:21:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.307038' lon='7.157185'>\t\t\t\t<ele>1905.944819</ele>\t\t\t\t<time>2000-01-01T00:21:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306995' lon='7.157185'>\t\t\t\t<ele>1909.328099</ele>\t\t\t\t<time>2000-01-01T00:21:42+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306909' lon='7.157185'>\t\t\t\t<ele>1912.193219</ele>\t\t\t\t<time>2000-01-01T00:22:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306845' lon='7.157207'>\t\t\t\t<ele>1913.656259</ele>\t\t\t\t<time>2000-01-01T00:22:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306780' lon='7.157142'>\t\t\t\t<ele>1916.033699</ele>\t\t\t\t<time>2000-01-01T00:22:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306802' lon='7.157078'>\t\t\t\t<ele>1918.929299</ele>\t\t\t\t<time>2000-01-01T00:23:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306759' lon='7.157035'>\t\t\t\t<ele>1921.824899</ele>\t\t\t\t<time>2000-01-01T00:23:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306716' lon='7.157035'>\t\t\t\t<ele>1924.690018</ele>\t\t\t\t<time>2000-01-01T00:23:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306695' lon='7.156928'>\t\t\t\t<ele>1928.073298</ele>\t\t\t\t<time>2000-01-01T00:24:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306673' lon='7.156842'>\t\t\t\t<ele>1929.993538</ele>\t\t\t\t<time>2000-01-01T00:24:42+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306630' lon='7.156885'>\t\t\t\t<ele>1932.858658</ele>\t\t\t\t<time>2000-01-01T00:25:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306566' lon='7.156885'>\t\t\t\t<ele>1935.754258</ele>\t\t\t\t<time>2000-01-01T00:25:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306544' lon='7.156799'>\t\t\t\t<ele>1939.107058</ele>\t\t\t\t<time>2000-01-01T00:26:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306609' lon='7.156670'>\t\t\t\t<ele>1942.002658</ele>\t\t\t\t<time>2000-01-01T00:26:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306587' lon='7.156670'>\t\t\t\t<ele>1943.435218</ele>\t\t\t\t<time>2000-01-01T00:26:43+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306587' lon='7.156606'>\t\t\t\t<ele>1944.898258</ele>\t\t\t\t<time>2000-01-01T00:26:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306652' lon='7.156520'>\t\t\t\t<ele>1945.843138</ele>\t\t\t\t<time>2000-01-01T00:27:05+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306695' lon='7.156477'>\t\t\t\t<ele>1946.818498</ele>\t\t\t\t<time>2000-01-01T00:27:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306737' lon='7.156456'>\t\t\t\t<ele>1949.195938</ele>\t\t\t\t<time>2000-01-01T00:27:31+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306780' lon='7.156348'>\t\t\t\t<ele>1951.603858</ele>\t\t\t\t<time>2000-01-01T00:27:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306802' lon='7.156305'>\t\t\t\t<ele>1954.987137</ele>\t\t\t\t<time>2000-01-01T00:28:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306759' lon='7.156305'>\t\t\t\t<ele>1956.907377</ele>\t\t\t\t<time>2000-01-01T00:28:41+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306802' lon='7.156241'>\t\t\t\t<ele>1958.827617</ele>\t\t\t\t<time>2000-01-01T00:28:58+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306845' lon='7.156112'>\t\t\t\t<ele>1960.747857</ele>\t\t\t\t<time>2000-01-01T00:29:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306845' lon='7.156048'>\t\t\t\t<ele>1963.643457</ele>\t\t\t\t<time>2000-01-01T00:29:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306823' lon='7.156026'>\t\t\t\t<ele>1966.996257</ele>\t\t\t\t<time>2000-01-01T00:30:05+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306737' lon='7.156091'>\t\t\t\t<ele>1968.428817</ele>\t\t\t\t<time>2000-01-01T00:30:14+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306737' lon='7.156091'>\t\t\t\t<ele>1969.891857</ele>\t\t\t\t<time>2000-01-01T00:30:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306673' lon='7.156091'>\t\t\t\t<ele>1971.812097</ele>\t\t\t\t<time>2000-01-01T00:30:45+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306673' lon='7.156026'>\t\t\t\t<ele>1975.164897</ele>\t\t\t\t<time>2000-01-01T00:31:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306587' lon='7.156048'>\t\t\t\t<ele>1977.572817</ele>\t\t\t\t<time>2000-01-01T00:31:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306523' lon='7.156069'>\t\t\t\t<ele>1979.005377</ele>\t\t\t\t<time>2000-01-01T00:31:43+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306458' lon='7.156091'>\t\t\t\t<ele>1980.925617</ele>\t\t\t\t<time>2000-01-01T00:32:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.156112'>\t\t\t\t<ele>1982.388657</ele>\t\t\t\t<time>2000-01-01T00:32:14+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306351' lon='7.156091'>\t\t\t\t<ele>1985.253776</ele>\t\t\t\t<time>2000-01-01T00:32:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306416' lon='7.155962'>\t\t\t\t<ele>1988.149376</ele>\t\t\t\t<time>2000-01-01T00:33:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306480' lon='7.155876'>\t\t\t\t<ele>1991.502176</ele>\t\t\t\t<time>2000-01-01T00:33:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306523' lon='7.155790'>\t\t\t\t<ele>1993.422416</ele>\t\t\t\t<time>2000-01-01T00:33:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306544' lon='7.155683'>\t\t\t\t<ele>1994.397776</ele>\t\t\t\t<time>2000-01-01T00:34:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306544' lon='7.155619'>\t\t\t\t<ele>1997.750576</ele>\t\t\t\t<time>2000-01-01T00:34:31+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306523' lon='7.155619'>\t\t\t\t<ele>1998.725936</ele>\t\t\t\t<time>2000-01-01T00:34:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306458' lon='7.155640'>\t\t\t\t<ele>2000.646176</ele>\t\t\t\t<time>2000-01-01T00:34:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.155640'>\t\t\t\t<ele>2002.566416</ele>\t\t\t\t<time>2000-01-01T00:35:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.155511'>\t\t\t\t<ele>2004.486656</ele>\t\t\t\t<time>2000-01-01T00:35:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306437' lon='7.155490'>\t\t\t\t<ele>2005.919216</ele>\t\t\t\t<time>2000-01-01T00:35:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306458' lon='7.155426'>\t\t\t\t<ele>2005.462016</ele>\t\t\t\t<time>2000-01-01T00:35:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306480' lon='7.155297'>\t\t\t\t<ele>2008.814816</ele>\t\t\t\t<time>2000-01-01T00:36:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306458' lon='7.155232'>\t\t\t\t<ele>2009.759696</ele>\t\t\t\t<time>2000-01-01T00:36:16+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306394' lon='7.155318'>\t\t\t\t<ele>2011.710416</ele>\t\t\t\t<time>2000-01-01T00:36:25+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306351' lon='7.155383'>\t\t\t\t<ele>2015.063216</ele>\t\t\t\t<time>2000-01-01T00:36:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306330' lon='7.155340'>\t\t\t\t<ele>2018.416015</ele>\t\t\t\t<time>2000-01-01T00:37:25+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306308' lon='7.155318'>\t\t\t\t<ele>2018.416015</ele>\t\t\t\t<time>2000-01-01T00:37:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306308' lon='7.155232'>\t\t\t\t<ele>2019.391375</ele>\t\t\t\t<time>2000-01-01T00:37:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306308' lon='7.155232'>\t\t\t\t<ele>2020.823935</ele>\t\t\t\t<time>2000-01-01T00:37:47+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306244' lon='7.155254'>\t\t\t\t<ele>2022.744175</ele>\t\t\t\t<time>2000-01-01T00:38:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306201' lon='7.155340'>\t\t\t\t<ele>2025.639775</ele>\t\t\t\t<time>2000-01-01T00:38:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306222' lon='7.155361'>\t\t\t\t<ele>2028.992575</ele>\t\t\t\t<time>2000-01-01T00:39:00+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306244' lon='7.155447'>\t\t\t\t<ele>2030.455615</ele>\t\t\t\t<time>2000-01-01T00:39:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306244' lon='7.155533'>\t\t\t\t<ele>2031.888175</ele>\t\t\t\t<time>2000-01-01T00:39:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306201' lon='7.155597'>\t\t\t\t<ele>2035.240975</ele>\t\t\t\t<time>2000-01-01T00:39:50+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306180' lon='7.155704'>\t\t\t\t<ele>2038.136575</ele>\t\t\t\t<time>2000-01-01T00:40:16+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306137' lon='7.155812'>\t\t\t\t<ele>2039.569135</ele>\t\t\t\t<time>2000-01-01T00:40:25+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306094' lon='7.155919'>\t\t\t\t<ele>2042.464735</ele>\t\t\t\t<time>2000-01-01T00:40:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306094' lon='7.155919'>\t\t\t\t<ele>2042.952415</ele>\t\t\t\t<time>2000-01-01T00:40:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306051' lon='7.155983'>\t\t\t\t<ele>2043.897295</ele>\t\t\t\t<time>2000-01-01T00:41:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.306029' lon='7.156069'>\t\t\t\t<ele>2047.250094</ele>\t\t\t\t<time>2000-01-01T00:41:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305986' lon='7.156177'>\t\t\t\t<ele>2049.200814</ele>\t\t\t\t<time>2000-01-01T00:41:41+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305965' lon='7.156262'>\t\t\t\t<ele>2052.553614</ele>\t\t\t\t<time>2000-01-01T00:42:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305901' lon='7.156370'>\t\t\t\t<ele>2055.449214</ele>\t\t\t\t<time>2000-01-01T00:42:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305858' lon='7.156413'>\t\t\t\t<ele>2057.369454</ele>\t\t\t\t<time>2000-01-01T00:42:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305815' lon='7.156477'>\t\t\t\t<ele>2057.826654</ele>\t\t\t\t<time>2000-01-01T00:43:00+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305729' lon='7.156670'>\t\t\t\t<ele>2055.906414</ele>\t\t\t\t<time>2000-01-01T00:43:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305707' lon='7.156692'>\t\t\t\t<ele>2054.473854</ele>\t\t\t\t<time>2000-01-01T00:43:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305707' lon='7.156713'>\t\t\t\t<ele>2054.473854</ele>\t\t\t\t<time>2000-01-01T00:43:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305643' lon='7.156777'>\t\t\t\t<ele>2052.553614</ele>\t\t\t\t<time>2000-01-01T00:43:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305514' lon='7.156992'>\t\t\t\t<ele>2053.041294</ele>\t\t\t\t<time>2000-01-01T00:43:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305429' lon='7.157013'>\t\t\t\t<ele>2054.961534</ele>\t\t\t\t<time>2000-01-01T00:44:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305407' lon='7.157013'>\t\t\t\t<ele>2055.906414</ele>\t\t\t\t<time>2000-01-01T00:44:13+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305343' lon='7.157035'>\t\t\t\t<ele>2057.826654</ele>\t\t\t\t<time>2000-01-01T00:44:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305300' lon='7.157099'>\t\t\t\t<ele>2060.234574</ele>\t\t\t\t<time>2000-01-01T00:44:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305235' lon='7.157207'>\t\t\t\t<ele>2063.130174</ele>\t\t\t\t<time>2000-01-01T00:45:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305171' lon='7.157292'>\t\t\t\t<ele>2065.050414</ele>\t\t\t\t<time>2000-01-01T00:45:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305150' lon='7.157207'>\t\t\t\t<ele>2066.970654</ele>\t\t\t\t<time>2000-01-01T00:45:44+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305128' lon='7.157099'>\t\t\t\t<ele>2069.866254</ele>\t\t\t\t<time>2000-01-01T00:46:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305107' lon='7.157078'>\t\t\t\t<ele>2071.786494</ele>\t\t\t\t<time>2000-01-01T00:46:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305064' lon='7.157142'>\t\t\t\t<ele>2074.194414</ele>\t\t\t\t<time>2000-01-01T00:46:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.305021' lon='7.157164'>\t\t\t\t<ele>2075.626974</ele>\t\t\t\t<time>2000-01-01T00:47:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304999' lon='7.157078'>\t\t\t\t<ele>2078.034894</ele>\t\t\t\t<time>2000-01-01T00:47:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304956' lon='7.157142'>\t\t\t\t<ele>2080.900013</ele>\t\t\t\t<time>2000-01-01T00:47:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304914' lon='7.157121'>\t\t\t\t<ele>2082.363053</ele>\t\t\t\t<time>2000-01-01T00:48:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304892' lon='7.157078'>\t\t\t\t<ele>2085.228173</ele>\t\t\t\t<time>2000-01-01T00:48:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304849' lon='7.157185'>\t\t\t\t<ele>2087.636093</ele>\t\t\t\t<time>2000-01-01T00:48:50+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304785' lon='7.157314'>\t\t\t\t<ele>2089.556333</ele>\t\t\t\t<time>2000-01-01T00:49:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304763' lon='7.157207'>\t\t\t\t<ele>2091.964253</ele>\t\t\t\t<time>2000-01-01T00:49:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304720' lon='7.157207'>\t\t\t\t<ele>2094.859853</ele>\t\t\t\t<time>2000-01-01T00:49:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304656' lon='7.157207'>\t\t\t\t<ele>2097.267773</ele>\t\t\t\t<time>2000-01-01T00:50:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304613' lon='7.157271'>\t\t\t\t<ele>2100.620573</ele>\t\t\t\t<time>2000-01-01T00:50:41+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304549' lon='7.157249'>\t\t\t\t<ele>2103.973373</ele>\t\t\t\t<time>2000-01-01T00:51:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304506' lon='7.157185'>\t\t\t\t<ele>2105.893613</ele>\t\t\t\t<time>2000-01-01T00:51:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304506' lon='7.157142'>\t\t\t\t<ele>2108.301533</ele>\t\t\t\t<time>2000-01-01T00:51:50+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304463' lon='7.157099'>\t\t\t\t<ele>2110.221772</ele>\t\t\t\t<time>2000-01-01T00:52:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304463' lon='7.157056'>\t\t\t\t<ele>2113.117372</ele>\t\t\t\t<time>2000-01-01T00:52:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304399' lon='7.157078'>\t\t\t\t<ele>2115.037612</ele>\t\t\t\t<time>2000-01-01T00:52:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304399' lon='7.157099'>\t\t\t\t<ele>2116.470172</ele>\t\t\t\t<time>2000-01-01T00:53:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304356' lon='7.157207'>\t\t\t\t<ele>2116.012972</ele>\t\t\t\t<time>2000-01-01T00:53:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304227' lon='7.157228'>\t\t\t\t<ele>2117.933212</ele>\t\t\t\t<time>2000-01-01T00:53:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304205' lon='7.157185'>\t\t\t\t<ele>2118.878092</ele>\t\t\t\t<time>2000-01-01T00:53:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304077' lon='7.157056'>\t\t\t\t<ele>2121.773692</ele>\t\t\t\t<time>2000-01-01T00:53:47+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304077' lon='7.157056'>\t\t\t\t<ele>2122.261372</ele>\t\t\t\t<time>2000-01-01T00:53:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.304055' lon='7.156863'>\t\t\t\t<ele>2124.181612</ele>\t\t\t\t<time>2000-01-01T00:54:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303991' lon='7.156756'>\t\t\t\t<ele>2126.559052</ele>\t\t\t\t<time>2000-01-01T00:54:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303926' lon='7.156692'>\t\t\t\t<ele>2129.942332</ele>\t\t\t\t<time>2000-01-01T00:54:58+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303884' lon='7.156563'>\t\t\t\t<ele>2131.862572</ele>\t\t\t\t<time>2000-01-01T00:55:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303841' lon='7.156477'>\t\t\t\t<ele>2134.758172</ele>\t\t\t\t<time>2000-01-01T00:55:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303798' lon='7.156434'>\t\t\t\t<ele>2136.678412</ele>\t\t\t\t<time>2000-01-01T00:55:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303733' lon='7.156348'>\t\t\t\t<ele>2138.598652</ele>\t\t\t\t<time>2000-01-01T00:56:00+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303669' lon='7.156284'>\t\t\t\t<ele>2141.951451</ele>\t\t\t\t<time>2000-01-01T00:56:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303605' lon='7.156198'>\t\t\t\t<ele>2143.871691</ele>\t\t\t\t<time>2000-01-01T00:56:39+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303519' lon='7.156091'>\t\t\t\t<ele>2145.304251</ele>\t\t\t\t<time>2000-01-01T00:56:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303411' lon='7.156026'>\t\t\t\t<ele>2148.687531</ele>\t\t\t\t<time>2000-01-01T00:57:21+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303326' lon='7.155962'>\t\t\t\t<ele>2150.607771</ele>\t\t\t\t<time>2000-01-01T00:57:31+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303261' lon='7.155833'>\t\t\t\t<ele>2153.960571</ele>\t\t\t\t<time>2000-01-01T00:58:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303197' lon='7.155747'>\t\t\t\t<ele>2156.856171</ele>\t\t\t\t<time>2000-01-01T00:58:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303154' lon='7.155662'>\t\t\t\t<ele>2157.831531</ele>\t\t\t\t<time>2000-01-01T00:58:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303090' lon='7.155619'>\t\t\t\t<ele>2161.184331</ele>\t\t\t\t<time>2000-01-01T00:59:05+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303068' lon='7.155619'>\t\t\t\t<ele>2161.672011</ele>\t\t\t\t<time>2000-01-01T00:59:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303090' lon='7.155597'>\t\t\t\t<ele>2161.672011</ele>\t\t\t\t<time>2000-01-01T00:59:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303068' lon='7.155576'>\t\t\t\t<ele>2162.616891</ele>\t\t\t\t<time>2000-01-01T00:59:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303090' lon='7.155576'>\t\t\t\t<ele>2162.129211</ele>\t\t\t\t<time>2000-01-01T00:59:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303090' lon='7.155554'>\t\t\t\t<ele>2164.079931</ele>\t\t\t\t<time>2000-01-01T00:59:38+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303111' lon='7.155511'>\t\t\t\t<ele>2161.184331</ele>\t\t\t\t<time>2000-01-01T00:59:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303090' lon='7.155554'>\t\t\t\t<ele>2162.616891</ele>\t\t\t\t<time>2000-01-01T01:00:09+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303111' lon='7.155576'>\t\t\t\t<ele>2163.104571</ele>\t\t\t\t<time>2000-01-01T01:00:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303090' lon='7.155554'>\t\t\t\t<ele>2162.129211</ele>\t\t\t\t<time>2000-01-01T01:00:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303068' lon='7.155511'>\t\t\t\t<ele>2164.079931</ele>\t\t\t\t<time>2000-01-01T01:00:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.303025' lon='7.155447'>\t\t\t\t<ele>2166.000171</ele>\t\t\t\t<time>2000-01-01T01:00:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302982' lon='7.155383'>\t\t\t\t<ele>2169.352971</ele>\t\t\t\t<time>2000-01-01T01:01:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302982' lon='7.155361'>\t\t\t\t<ele>2170.785531</ele>\t\t\t\t<time>2000-01-01T01:01:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302918' lon='7.155254'>\t\t\t\t<ele>2172.705770</ele>\t\t\t\t<time>2000-01-01T01:01:46+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302875' lon='7.155275'>\t\t\t\t<ele>2176.089050</ele>\t\t\t\t<time>2000-01-01T01:02:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302811' lon='7.155254'>\t\t\t\t<ele>2178.009290</ele>\t\t\t\t<time>2000-01-01T01:02:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302768' lon='7.155147'>\t\t\t\t<ele>2180.874410</ele>\t\t\t\t<time>2000-01-01T01:03:00+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302682' lon='7.155104'>\t\t\t\t<ele>2183.282330</ele>\t\t\t\t<time>2000-01-01T01:03:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302639' lon='7.155039'>\t\t\t\t<ele>2197.242170</ele>\t\t\t\t<time>2000-01-01T01:04:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302532' lon='7.154996'>\t\t\t\t<ele>2201.082650</ele>\t\t\t\t<time>2000-01-01T01:04:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302510' lon='7.154996'>\t\t\t\t<ele>2202.027530</ele>\t\t\t\t<time>2000-01-01T01:05:05+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302446' lon='7.154975'>\t\t\t\t<ele>2204.435449</ele>\t\t\t\t<time>2000-01-01T01:05:26+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302382' lon='7.154825'>\t\t\t\t<ele>2206.843369</ele>\t\t\t\t<time>2000-01-01T01:05:39+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302360' lon='7.154760'>\t\t\t\t<ele>2209.251289</ele>\t\t\t\t<time>2000-01-01T01:06:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302360' lon='7.154696'>\t\t\t\t<ele>2210.683849</ele>\t\t\t\t<time>2000-01-01T01:06:13+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302382' lon='7.154653'>\t\t\t\t<ele>2210.196169</ele>\t\t\t\t<time>2000-01-01T01:06:16+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302339' lon='7.154589'>\t\t\t\t<ele>2212.116409</ele>\t\t\t\t<time>2000-01-01T01:06:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302296' lon='7.154546'>\t\t\t\t<ele>2215.987369</ele>\t\t\t\t<time>2000-01-01T01:07:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302210' lon='7.154481'>\t\t\t\t<ele>2218.364809</ele>\t\t\t\t<time>2000-01-01T01:07:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302210' lon='7.154417'>\t\t\t\t<ele>2218.852489</ele>\t\t\t\t<time>2000-01-01T01:07:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302124' lon='7.154353'>\t\t\t\t<ele>2221.260409</ele>\t\t\t\t<time>2000-01-01T01:07:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302103' lon='7.154331'>\t\t\t\t<ele>2221.748089</ele>\t\t\t\t<time>2000-01-01T01:07:59+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.302060' lon='7.154353'>\t\t\t\t<ele>2222.692969</ele>\t\t\t\t<time>2000-01-01T01:08:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301995' lon='7.154331'>\t\t\t\t<ele>2223.668329</ele>\t\t\t\t<time>2000-01-01T01:08:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301952' lon='7.154331'>\t\t\t\t<ele>2224.613209</ele>\t\t\t\t<time>2000-01-01T01:08:14+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301931' lon='7.154331'>\t\t\t\t<ele>2225.588569</ele>\t\t\t\t<time>2000-01-01T01:08:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301867' lon='7.154353'>\t\t\t\t<ele>2226.563929</ele>\t\t\t\t<time>2000-01-01T01:08:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301802' lon='7.154374'>\t\t\t\t<ele>2227.021129</ele>\t\t\t\t<time>2000-01-01T01:08:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301781' lon='7.154353'>\t\t\t\t<ele>2227.996489</ele>\t\t\t\t<time>2000-01-01T01:08:45+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301759' lon='7.154310'>\t\t\t\t<ele>2231.349289</ele>\t\t\t\t<time>2000-01-01T01:09:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301759' lon='7.154288'>\t\t\t\t<ele>2231.349289</ele>\t\t\t\t<time>2000-01-01T01:09:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301695' lon='7.154245'>\t\t\t\t<ele>2235.677448</ele>\t\t\t\t<time>2000-01-01T01:09:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301652' lon='7.154202'>\t\t\t\t<ele>2238.085368</ele>\t\t\t\t<time>2000-01-01T01:10:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301652' lon='7.154224'>\t\t\t\t<ele>2238.573048</ele>\t\t\t\t<time>2000-01-01T01:10:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301588' lon='7.154202'>\t\t\t\t<ele>2238.573048</ele>\t\t\t\t<time>2000-01-01T01:10:29+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301545' lon='7.154181'>\t\t\t\t<ele>2240.005608</ele>\t\t\t\t<time>2000-01-01T01:10:41+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301437' lon='7.154202'>\t\t\t\t<ele>2242.901208</ele>\t\t\t\t<time>2000-01-01T01:11:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301416' lon='7.154202'>\t\t\t\t<ele>2243.388888</ele>\t\t\t\t<time>2000-01-01T01:11:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301309' lon='7.154202'>\t\t\t\t<ele>2244.333768</ele>\t\t\t\t<time>2000-01-01T01:11:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301266' lon='7.154202'>\t\t\t\t<ele>2244.821448</ele>\t\t\t\t<time>2000-01-01T01:11:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301180' lon='7.154202'>\t\t\t\t<ele>2249.149608</ele>\t\t\t\t<time>2000-01-01T01:12:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.301137' lon='7.154202'>\t\t\t\t<ele>2249.637288</ele>\t\t\t\t<time>2000-01-01T01:12:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300922' lon='7.154202'>\t\t\t\t<ele>2251.069848</ele>\t\t\t\t<time>2000-01-01T01:12:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300922' lon='7.154202'>\t\t\t\t<ele>2251.557528</ele>\t\t\t\t<time>2000-01-01T01:12:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300815' lon='7.154245'>\t\t\t\t<ele>2254.910328</ele>\t\t\t\t<time>2000-01-01T01:13:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300772' lon='7.154245'>\t\t\t\t<ele>2255.885688</ele>\t\t\t\t<time>2000-01-01T01:13:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300751' lon='7.154245'>\t\t\t\t<ele>2257.318248</ele>\t\t\t\t<time>2000-01-01T01:13:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300708' lon='7.154267'>\t\t\t\t<ele>2257.318248</ele>\t\t\t\t<time>2000-01-01T01:13:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300536' lon='7.154288'>\t\t\t\t<ele>2260.183368</ele>\t\t\t\t<time>2000-01-01T01:13:46+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300407' lon='7.154310'>\t\t\t\t<ele>2264.054328</ele>\t\t\t\t<time>2000-01-01T01:14:21+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300386' lon='7.154310'>\t\t\t\t<ele>2263.566648</ele>\t\t\t\t<time>2000-01-01T01:14:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300257' lon='7.154138'>\t\t\t\t<ele>2264.999208</ele>\t\t\t\t<time>2000-01-01T01:14:41+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300107' lon='7.153966'>\t\t\t\t<ele>2268.382487</ele>\t\t\t\t<time>2000-01-01T01:15:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300043' lon='7.153924'>\t\t\t\t<ele>2269.815047</ele>\t\t\t\t<time>2000-01-01T01:15:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.300021' lon='7.153945'>\t\t\t\t<ele>2270.759927</ele>\t\t\t\t<time>2000-01-01T01:15:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299978' lon='7.153966'>\t\t\t\t<ele>2271.735287</ele>\t\t\t\t<time>2000-01-01T01:15:21+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299914' lon='7.154138'>\t\t\t\t<ele>2268.839687</ele>\t\t\t\t<time>2000-01-01T01:15:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299871' lon='7.154245'>\t\t\t\t<ele>2270.759927</ele>\t\t\t\t<time>2000-01-01T01:15:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299807' lon='7.154417'>\t\t\t\t<ele>2273.167847</ele>\t\t\t\t<time>2000-01-01T01:15:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299764' lon='7.154417'>\t\t\t\t<ele>2273.655527</ele>\t\t\t\t<time>2000-01-01T01:15:59+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299656' lon='7.154417'>\t\t\t\t<ele>2275.088087</ele>\t\t\t\t<time>2000-01-01T01:16:09+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299635' lon='7.154460'>\t\t\t\t<ele>2274.630887</ele>\t\t\t\t<time>2000-01-01T01:16:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299420' lon='7.154653'>\t\t\t\t<ele>2276.063447</ele>\t\t\t\t<time>2000-01-01T01:16:38+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299313' lon='7.154696'>\t\t\t\t<ele>2279.416247</ele>\t\t\t\t<time>2000-01-01T01:17:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299292' lon='7.154653'>\t\t\t\t<ele>2283.256727</ele>\t\t\t\t<time>2000-01-01T01:17:42+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299270' lon='7.154632'>\t\t\t\t<ele>2284.719767</ele>\t\t\t\t<time>2000-01-01T01:17:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299249' lon='7.154610'>\t\t\t\t<ele>2286.152327</ele>\t\t\t\t<time>2000-01-01T01:18:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299206' lon='7.154632'>\t\t\t\t<ele>2288.072567</ele>\t\t\t\t<time>2000-01-01T01:18:26+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299163' lon='7.154610'>\t\t\t\t<ele>2289.505127</ele>\t\t\t\t<time>2000-01-01T01:18:39+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299141' lon='7.154610'>\t\t\t\t<ele>2290.968167</ele>\t\t\t\t<time>2000-01-01T01:18:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299120' lon='7.154589'>\t\t\t\t<ele>2290.968167</ele>\t\t\t\t<time>2000-01-01T01:18:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299077' lon='7.154589'>\t\t\t\t<ele>2292.888407</ele>\t\t\t\t<time>2000-01-01T01:19:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.299013' lon='7.154610'>\t\t\t\t<ele>2293.833287</ele>\t\t\t\t<time>2000-01-01T01:19:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298884' lon='7.154675'>\t\t\t\t<ele>2296.241207</ele>\t\t\t\t<time>2000-01-01T01:19:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298862' lon='7.154696'>\t\t\t\t<ele>2297.673766</ele>\t\t\t\t<time>2000-01-01T01:19:45+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298820' lon='7.154717'>\t\t\t\t<ele>2299.624486</ele>\t\t\t\t<time>2000-01-01T01:20:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298798' lon='7.154717'>\t\t\t\t<ele>2302.001926</ele>\t\t\t\t<time>2000-01-01T01:20:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298755' lon='7.154760'>\t\t\t\t<ele>2301.544726</ele>\t\t\t\t<time>2000-01-01T01:20:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298648' lon='7.154803'>\t\t\t\t<ele>2305.385206</ele>\t\t\t\t<time>2000-01-01T01:21:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298562' lon='7.154846'>\t\t\t\t<ele>2306.817766</ele>\t\t\t\t<time>2000-01-01T01:21:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298498' lon='7.154868'>\t\t\t\t<ele>2307.793126</ele>\t\t\t\t<time>2000-01-01T01:21:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298455' lon='7.154846'>\t\t\t\t<ele>2308.250326</ele>\t\t\t\t<time>2000-01-01T01:21:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298283' lon='7.154975'>\t\t\t\t<ele>2310.658246</ele>\t\t\t\t<time>2000-01-01T01:21:42+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298219' lon='7.154996'>\t\t\t\t<ele>2311.633606</ele>\t\t\t\t<time>2000-01-01T01:21:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298133' lon='7.154975'>\t\t\t\t<ele>2314.498726</ele>\t\t\t\t<time>2000-01-01T01:22:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298111' lon='7.154911'>\t\t\t\t<ele>2315.474086</ele>\t\t\t\t<time>2000-01-01T01:22:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298133' lon='7.154846'>\t\t\t\t<ele>2316.906646</ele>\t\t\t\t<time>2000-01-01T01:22:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298197' lon='7.154717'>\t\t\t\t<ele>2319.802246</ele>\t\t\t\t<time>2000-01-01T01:22:59+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298219' lon='7.154675'>\t\t\t\t<ele>2320.289926</ele>\t\t\t\t<time>2000-01-01T01:23:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298240' lon='7.154610'>\t\t\t\t<ele>2320.747126</ele>\t\t\t\t<time>2000-01-01T01:23:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298305' lon='7.154438'>\t\t\t\t<ele>2322.667366</ele>\t\t\t\t<time>2000-01-01T01:23:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298369' lon='7.154396'>\t\t\t\t<ele>2325.562966</ele>\t\t\t\t<time>2000-01-01T01:23:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298433' lon='7.154310'>\t\t\t\t<ele>2328.458565</ele>\t\t\t\t<time>2000-01-01T01:24:14+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298562' lon='7.154117'>\t\t\t\t<ele>2330.866485</ele>\t\t\t\t<time>2000-01-01T01:24:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298605' lon='7.154052'>\t\t\t\t<ele>2332.299045</ele>\t\t\t\t<time>2000-01-01T01:24:45+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298648' lon='7.153988'>\t\t\t\t<ele>2333.731605</ele>\t\t\t\t<time>2000-01-01T01:24:58+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298669' lon='7.153945'>\t\t\t\t<ele>2334.219285</ele>\t\t\t\t<time>2000-01-01T01:25:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298691' lon='7.153945'>\t\t\t\t<ele>2335.651845</ele>\t\t\t\t<time>2000-01-01T01:25:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298777' lon='7.153924'>\t\t\t\t<ele>2337.114885</ele>\t\t\t\t<time>2000-01-01T01:25:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298841' lon='7.153795'>\t\t\t\t<ele>2339.492325</ele>\t\t\t\t<time>2000-01-01T01:25:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298841' lon='7.153795'>\t\t\t\t<ele>2339.980005</ele>\t\t\t\t<time>2000-01-01T01:25:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298626' lon='7.153730'>\t\t\t\t<ele>2342.875605</ele>\t\t\t\t<time>2000-01-01T01:26:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298605' lon='7.153730'>\t\t\t\t<ele>2342.875605</ele>\t\t\t\t<time>2000-01-01T01:26:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298541' lon='7.153730'>\t\t\t\t<ele>2345.283525</ele>\t\t\t\t<time>2000-01-01T01:26:25+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298498' lon='7.153709'>\t\t\t\t<ele>2346.716085</ele>\t\t\t\t<time>2000-01-01T01:26:38+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298476' lon='7.153730'>\t\t\t\t<ele>2346.228405</ele>\t\t\t\t<time>2000-01-01T01:26:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298390' lon='7.153752'>\t\t\t\t<ele>2348.636325</ele>\t\t\t\t<time>2000-01-01T01:27:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298240' lon='7.153773'>\t\t\t\t<ele>2352.476805</ele>\t\t\t\t<time>2000-01-01T01:27:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298133' lon='7.153816'>\t\t\t\t<ele>2354.884725</ele>\t\t\t\t<time>2000-01-01T01:27:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298090' lon='7.153795'>\t\t\t\t<ele>2355.860085</ele>\t\t\t\t<time>2000-01-01T01:27:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298090' lon='7.153730'>\t\t\t\t<ele>2356.317285</ele>\t\t\t\t<time>2000-01-01T01:27:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298111' lon='7.153687'>\t\t\t\t<ele>2357.780325</ele>\t\t\t\t<time>2000-01-01T01:28:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298154' lon='7.153623'>\t\t\t\t<ele>2360.188244</ele>\t\t\t\t<time>2000-01-01T01:28:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298240' lon='7.153494'>\t\t\t\t<ele>2363.541044</ele>\t\t\t\t<time>2000-01-01T01:29:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298369' lon='7.153323'>\t\t\t\t<ele>2367.381524</ele>\t\t\t\t<time>2000-01-01T01:29:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298369' lon='7.153301'>\t\t\t\t<ele>2367.869204</ele>\t\t\t\t<time>2000-01-01T01:29:25+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298197' lon='7.153344'>\t\t\t\t<ele>2369.789444</ele>\t\t\t\t<time>2000-01-01T01:29:42+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298154' lon='7.153366'>\t\t\t\t<ele>2371.222004</ele>\t\t\t\t<time>2000-01-01T01:29:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298133' lon='7.153344'>\t\t\t\t<ele>2372.685044</ele>\t\t\t\t<time>2000-01-01T01:30:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298090' lon='7.153387'>\t\t\t\t<ele>2372.685044</ele>\t\t\t\t<time>2000-01-01T01:30:13+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298069' lon='7.153366'>\t\t\t\t<ele>2373.629924</ele>\t\t\t\t<time>2000-01-01T01:30:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297940' lon='7.153387'>\t\t\t\t<ele>2375.062484</ele>\t\t\t\t<time>2000-01-01T01:30:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297897' lon='7.153409'>\t\t\t\t<ele>2376.037844</ele>\t\t\t\t<time>2000-01-01T01:30:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297747' lon='7.153451'>\t\t\t\t<ele>2378.445764</ele>\t\t\t\t<time>2000-01-01T01:30:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297704' lon='7.153430'>\t\t\t\t<ele>2380.366004</ele>\t\t\t\t<time>2000-01-01T01:31:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297747' lon='7.153366'>\t\t\t\t<ele>2382.286244</ele>\t\t\t\t<time>2000-01-01T01:31:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.153323'>\t\t\t\t<ele>2382.773924</ele>\t\t\t\t<time>2000-01-01T01:31:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.153301'>\t\t\t\t<ele>2383.231124</ele>\t\t\t\t<time>2000-01-01T01:31:39+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297832' lon='7.153237'>\t\t\t\t<ele>2384.694164</ele>\t\t\t\t<time>2000-01-01T01:31:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297875' lon='7.153194'>\t\t\t\t<ele>2384.694164</ele>\t\t\t\t<time>2000-01-01T01:31:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297961' lon='7.153087'>\t\t\t\t<ele>2387.559284</ele>\t\t\t\t<time>2000-01-01T01:32:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297983' lon='7.153044'>\t\t\t\t<ele>2388.534644</ele>\t\t\t\t<time>2000-01-01T01:32:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298047' lon='7.152915'>\t\t\t\t<ele>2390.454884</ele>\t\t\t\t<time>2000-01-01T01:32:43+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298111' lon='7.152851'>\t\t\t\t<ele>2390.454884</ele>\t\t\t\t<time>2000-01-01T01:32:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298111' lon='7.152808'>\t\t\t\t<ele>2391.887443</ele>\t\t\t\t<time>2000-01-01T01:33:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298133' lon='7.152829'>\t\t\t\t<ele>2392.375123</ele>\t\t\t\t<time>2000-01-01T01:33:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.298090' lon='7.152829'>\t\t\t\t<ele>2392.862803</ele>\t\t\t\t<time>2000-01-01T01:33:11+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297983' lon='7.152851'>\t\t\t\t<ele>2395.727923</ele>\t\t\t\t<time>2000-01-01T01:33:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297961' lon='7.152851'>\t\t\t\t<ele>2396.703283</ele>\t\t\t\t<time>2000-01-01T01:33:46+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297940' lon='7.152872'>\t\t\t\t<ele>2397.678643</ele>\t\t\t\t<time>2000-01-01T01:33:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297832' lon='7.152894'>\t\t\t\t<ele>2400.056083</ele>\t\t\t\t<time>2000-01-01T01:34:05+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297725' lon='7.152894'>\t\t\t\t<ele>2401.519123</ele>\t\t\t\t<time>2000-01-01T01:34:16+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297682' lon='7.152894'>\t\t\t\t<ele>2403.927043</ele>\t\t\t\t<time>2000-01-01T01:34:38+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297682' lon='7.152894'>\t\t\t\t<ele>2404.871923</ele>\t\t\t\t<time>2000-01-01T01:34:46+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.152872'>\t\t\t\t<ele>2405.847283</ele>\t\t\t\t<time>2000-01-01T01:34:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.152829'>\t\t\t\t<ele>2407.279843</ele>\t\t\t\t<time>2000-01-01T01:35:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297725' lon='7.152786'>\t\t\t\t<ele>2407.279843</ele>\t\t\t\t<time>2000-01-01T01:35:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297725' lon='7.152722'>\t\t\t\t<ele>2407.767523</ele>\t\t\t\t<time>2000-01-01T01:35:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297747' lon='7.152679'>\t\t\t\t<ele>2409.200083</ele>\t\t\t\t<time>2000-01-01T01:35:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297832' lon='7.152572'>\t\t\t\t<ele>2411.120323</ele>\t\t\t\t<time>2000-01-01T01:35:44+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297875' lon='7.152529'>\t\t\t\t<ele>2412.095683</ele>\t\t\t\t<time>2000-01-01T01:35:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297875' lon='7.152507'>\t\t\t\t<ele>2413.528243</ele>\t\t\t\t<time>2000-01-01T01:36:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297747' lon='7.152507'>\t\t\t\t<ele>2415.448483</ele>\t\t\t\t<time>2000-01-01T01:36:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297725' lon='7.152529'>\t\t\t\t<ele>2416.881043</ele>\t\t\t\t<time>2000-01-01T01:36:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297682' lon='7.152529'>\t\t\t\t<ele>2418.801283</ele>\t\t\t\t<time>2000-01-01T01:36:45+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.152550'>\t\t\t\t<ele>2419.288963</ele>\t\t\t\t<time>2000-01-01T01:36:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.152529'>\t\t\t\t<ele>2420.264323</ele>\t\t\t\t<time>2000-01-01T01:36:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297682' lon='7.152443'>\t\t\t\t<ele>2421.696883</ele>\t\t\t\t<time>2000-01-01T01:37:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297725' lon='7.152379'>\t\t\t\t<ele>2421.696883</ele>\t\t\t\t<time>2000-01-01T01:37:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297768' lon='7.152314'>\t\t\t\t<ele>2424.104802</ele>\t\t\t\t<time>2000-01-01T01:37:31+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297811' lon='7.152250'>\t\t\t\t<ele>2425.537362</ele>\t\t\t\t<time>2000-01-01T01:37:44+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297854' lon='7.152185'>\t\t\t\t<ele>2427.457602</ele>\t\t\t\t<time>2000-01-01T01:38:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.152185'>\t\t\t\t<ele>2430.353202</ele>\t\t\t\t<time>2000-01-01T01:38:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297768' lon='7.152185'>\t\t\t\t<ele>2430.840882</ele>\t\t\t\t<time>2000-01-01T01:38:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297704' lon='7.152185'>\t\t\t\t<ele>2430.840882</ele>\t\t\t\t<time>2000-01-01T01:38:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.152207'>\t\t\t\t<ele>2432.761122</ele>\t\t\t\t<time>2000-01-01T01:38:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297554' lon='7.152228'>\t\t\t\t<ele>2435.626242</ele>\t\t\t\t<time>2000-01-01T01:39:19+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297489' lon='7.152250'>\t\t\t\t<ele>2439.497202</ele>\t\t\t\t<time>2000-01-01T01:39:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297468' lon='7.152250'>\t\t\t\t<ele>2439.497202</ele>\t\t\t\t<time>2000-01-01T01:39:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297489' lon='7.152143'>\t\t\t\t<ele>2442.362322</ele>\t\t\t\t<time>2000-01-01T01:40:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297532' lon='7.152078'>\t\t\t\t<ele>2444.770242</ele>\t\t\t\t<time>2000-01-01T01:40:44+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297554' lon='7.152035'>\t\t\t\t<ele>2443.794882</ele>\t\t\t\t<time>2000-01-01T01:40:50+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297618' lon='7.151906'>\t\t\t\t<ele>2447.178162</ele>\t\t\t\t<time>2000-01-01T01:41:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.151799'>\t\t\t\t<ele>2451.018642</ele>\t\t\t\t<time>2000-01-01T01:41:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.151756'>\t\t\t\t<ele>2451.506322</ele>\t\t\t\t<time>2000-01-01T01:41:58+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297639' lon='7.151692'>\t\t\t\t<ele>2454.371441</ele>\t\t\t\t<time>2000-01-01T01:42:24+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297639' lon='7.151670'>\t\t\t\t<ele>2455.346801</ele>\t\t\t\t<time>2000-01-01T01:42:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297618' lon='7.151670'>\t\t\t\t<ele>2455.346801</ele>\t\t\t\t<time>2000-01-01T01:42:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297575' lon='7.151692'>\t\t\t\t<ele>2456.779361</ele>\t\t\t\t<time>2000-01-01T01:42:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297554' lon='7.151713'>\t\t\t\t<ele>2457.754721</ele>\t\t\t\t<time>2000-01-01T01:42:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297489' lon='7.151713'>\t\t\t\t<ele>2461.595201</ele>\t\t\t\t<time>2000-01-01T01:43:31+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297425' lon='7.151713'>\t\t\t\t<ele>2463.515441</ele>\t\t\t\t<time>2000-01-01T01:43:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297403' lon='7.151692'>\t\t\t\t<ele>2465.435681</ele>\t\t\t\t<time>2000-01-01T01:44:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297403' lon='7.151692'>\t\t\t\t<ele>2465.435681</ele>\t\t\t\t<time>2000-01-01T01:44:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297296' lon='7.151735'>\t\t\t\t<ele>2468.331281</ele>\t\t\t\t<time>2000-01-01T01:44:32+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297232' lon='7.151713'>\t\t\t\t<ele>2470.739201</ele>\t\t\t\t<time>2000-01-01T01:44:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297210' lon='7.151713'>\t\t\t\t<ele>2470.739201</ele>\t\t\t\t<time>2000-01-01T01:44:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297253' lon='7.151628'>\t\t\t\t<ele>2473.116641</ele>\t\t\t\t<time>2000-01-01T01:45:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297253' lon='7.151628'>\t\t\t\t<ele>2474.092001</ele>\t\t\t\t<time>2000-01-01T01:45:26+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297210' lon='7.151606'>\t\t\t\t<ele>2476.987601</ele>\t\t\t\t<time>2000-01-01T01:45:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297189' lon='7.151606'>\t\t\t\t<ele>2477.444801</ele>\t\t\t\t<time>2000-01-01T01:45:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297167' lon='7.151606'>\t\t\t\t<ele>2478.907841</ele>\t\t\t\t<time>2000-01-01T01:46:07+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297124' lon='7.151628'>\t\t\t\t<ele>2479.852721</ele>\t\t\t\t<time>2000-01-01T01:46:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.151628'>\t\t\t\t<ele>2480.828081</ele>\t\t\t\t<time>2000-01-01T01:46:16+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.151585'>\t\t\t\t<ele>2481.285281</ele>\t\t\t\t<time>2000-01-01T01:46:19+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297103' lon='7.151563'>\t\t\t\t<ele>2483.236001</ele>\t\t\t\t<time>2000-01-01T01:46:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297124' lon='7.151499'>\t\t\t\t<ele>2484.668560</ele>\t\t\t\t<time>2000-01-01T01:46:50+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297124' lon='7.151477'>\t\t\t\t<ele>2484.668560</ele>\t\t\t\t<time>2000-01-01T01:46:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297189' lon='7.151392'>\t\t\t\t<ele>2488.021360</ele>\t\t\t\t<time>2000-01-01T01:47:21+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297253' lon='7.151263'>\t\t\t\t<ele>2490.429280</ele>\t\t\t\t<time>2000-01-01T01:47:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297253' lon='7.151263'>\t\t\t\t<ele>2490.916960</ele>\t\t\t\t<time>2000-01-01T01:47:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297296' lon='7.151113'>\t\t\t\t<ele>2493.782080</ele>\t\t\t\t<time>2000-01-01T01:48:03+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297318' lon='7.151091'>\t\t\t\t<ele>2494.757440</ele>\t\t\t\t<time>2000-01-01T01:48:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297446' lon='7.150941'>\t\t\t\t<ele>2497.165360</ele>\t\t\t\t<time>2000-01-01T01:48:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297468' lon='7.150877'>\t\t\t\t<ele>2499.085600</ele>\t\t\t\t<time>2000-01-01T01:48:46+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297468' lon='7.150855'>\t\t\t\t<ele>2500.060960</ele>\t\t\t\t<time>2000-01-01T01:48:54+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297489' lon='7.150769'>\t\t\t\t<ele>2503.901440</ele>\t\t\t\t<time>2000-01-01T01:49:29+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297446' lon='7.150705'>\t\t\t\t<ele>2506.278880</ele>\t\t\t\t<time>2000-01-01T01:49:50+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297446' lon='7.150705'>\t\t\t\t<ele>2505.334000</ele>\t\t\t\t<time>2000-01-01T01:49:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297403' lon='7.150705'>\t\t\t\t<ele>2509.174480</ele>\t\t\t\t<time>2000-01-01T01:50:31+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297318' lon='7.150726'>\t\t\t\t<ele>2512.557760</ele>\t\t\t\t<time>2000-01-01T01:51:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297318' lon='7.150640'>\t\t\t\t<ele>2515.422880</ele>\t\t\t\t<time>2000-01-01T01:51:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.150619'>\t\t\t\t<ele>2515.422880</ele>\t\t\t\t<time>2000-01-01T01:51:30+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297382' lon='7.150576'>\t\t\t\t<ele>2518.318479</ele>\t\t\t\t<time>2000-01-01T01:51:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297403' lon='7.150533'>\t\t\t\t<ele>2519.263359</ele>\t\t\t\t<time>2000-01-01T01:52:05+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297446' lon='7.150533'>\t\t\t\t<ele>2518.806159</ele>\t\t\t\t<time>2000-01-01T01:52:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297489' lon='7.150490'>\t\t\t\t<ele>2518.806159</ele>\t\t\t\t<time>2000-01-01T01:52:13+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297511' lon='7.150490'>\t\t\t\t<ele>2520.238719</ele>\t\t\t\t<time>2000-01-01T01:52:26+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297575' lon='7.150512'>\t\t\t\t<ele>2522.646639</ele>\t\t\t\t<time>2000-01-01T01:52:47+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297618' lon='7.150490'>\t\t\t\t<ele>2522.158959</ele>\t\t\t\t<time>2000-01-01T01:52:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297639' lon='7.150340'>\t\t\t\t<ele>2523.103839</ele>\t\t\t\t<time>2000-01-01T01:53:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297639' lon='7.150340'>\t\t\t\t<ele>2524.566879</ele>\t\t\t\t<time>2000-01-01T01:53:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297639' lon='7.150319'>\t\t\t\t<ele>2524.566879</ele>\t\t\t\t<time>2000-01-01T01:53:16+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297639' lon='7.150254'>\t\t\t\t<ele>2527.919679</ele>\t\t\t\t<time>2000-01-01T01:53:46+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297661' lon='7.150233'>\t\t\t\t<ele>2528.895039</ele>\t\t\t\t<time>2000-01-01T01:53:55+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297704' lon='7.150147'>\t\t\t\t<ele>2530.815279</ele>\t\t\t\t<time>2000-01-01T01:54:13+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297704' lon='7.150061'>\t\t\t\t<ele>2534.168079</ele>\t\t\t\t<time>2000-01-01T01:54:43+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297725' lon='7.150061'>\t\t\t\t<ele>2535.143439</ele>\t\t\t\t<time>2000-01-01T01:54:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.149975'>\t\t\t\t<ele>2538.496239</ele>\t\t\t\t<time>2000-01-01T01:55:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297811' lon='7.149868'>\t\t\t\t<ele>2540.416479</ele>\t\t\t\t<time>2000-01-01T01:55:39+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.149804'>\t\t\t\t<ele>2541.849039</ele>\t\t\t\t<time>2000-01-01T01:55:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297747' lon='7.149804'>\t\t\t\t<ele>2543.312079</ele>\t\t\t\t<time>2000-01-01T01:56:05+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297704' lon='7.149804'>\t\t\t\t<ele>2544.744639</ele>\t\t\t\t<time>2000-01-01T01:56:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297639' lon='7.149847'>\t\t\t\t<ele>2547.152558</ele>\t\t\t\t<time>2000-01-01T01:56:40+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297618' lon='7.149739'>\t\t\t\t<ele>2549.072798</ele>\t\t\t\t<time>2000-01-01T01:56:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297596' lon='7.149675'>\t\t\t\t<ele>2550.993038</ele>\t\t\t\t<time>2000-01-01T01:57:14+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297554' lon='7.149782'>\t\t\t\t<ele>2553.400958</ele>\t\t\t\t<time>2000-01-01T01:57:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297532' lon='7.149825'>\t\t\t\t<ele>2554.833518</ele>\t\t\t\t<time>2000-01-01T01:57:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297425' lon='7.149975'>\t\t\t\t<ele>2558.216798</ele>\t\t\t\t<time>2000-01-01T01:58:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297425' lon='7.149975'>\t\t\t\t<ele>2558.216798</ele>\t\t\t\t<time>2000-01-01T01:58:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297446' lon='7.149825'>\t\t\t\t<ele>2560.137038</ele>\t\t\t\t<time>2000-01-01T01:58:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297446' lon='7.149675'>\t\t\t\t<ele>2562.057278</ele>\t\t\t\t<time>2000-01-01T01:58:26+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297446' lon='7.149611'>\t\t\t\t<ele>2564.465198</ele>\t\t\t\t<time>2000-01-01T01:58:47+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297403' lon='7.149546'>\t\t\t\t<ele>2567.817998</ele>\t\t\t\t<time>2000-01-01T01:59:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297403' lon='7.149525'>\t\t\t\t<ele>2568.793358</ele>\t\t\t\t<time>2000-01-01T01:59:26+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297382' lon='7.149525'>\t\t\t\t<ele>2571.658478</ele>\t\t\t\t<time>2000-01-01T01:59:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.149611'>\t\t\t\t<ele>2574.554078</ele>\t\t\t\t<time>2000-01-01T02:00:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297275' lon='7.149675'>\t\t\t\t<ele>2576.474318</ele>\t\t\t\t<time>2000-01-01T02:00:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297253' lon='7.149696'>\t\t\t\t<ele>2577.419198</ele>\t\t\t\t<time>2000-01-01T02:00:44+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297232' lon='7.149739'>\t\t\t\t<ele>2578.882237</ele>\t\t\t\t<time>2000-01-01T02:00:57+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297189' lon='7.149804'>\t\t\t\t<ele>2582.235037</ele>\t\t\t\t<time>2000-01-01T02:01:27+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297167' lon='7.149782'>\t\t\t\t<ele>2583.210397</ele>\t\t\t\t<time>2000-01-01T02:01:36+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.149825'>\t\t\t\t<ele>2586.075517</ele>\t\t\t\t<time>2000-01-01T02:02:02+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.149611'>\t\t\t\t<ele>2588.483437</ele>\t\t\t\t<time>2000-01-01T02:02:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.149482'>\t\t\t\t<ele>2590.891357</ele>\t\t\t\t<time>2000-01-01T02:02:39+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.149439'>\t\t\t\t<ele>2592.323917</ele>\t\t\t\t<time>2000-01-01T02:02:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.149417'>\t\t\t\t<ele>2592.811597</ele>\t\t\t\t<time>2000-01-01T02:02:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.149374'>\t\t\t\t<ele>2594.244157</ele>\t\t\t\t<time>2000-01-01T02:03:09+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.149353'>\t\t\t\t<ele>2595.707197</ele>\t\t\t\t<time>2000-01-01T02:03:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.149310'>\t\t\t\t<ele>2596.164397</ele>\t\t\t\t<time>2000-01-01T02:03:25+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.149160'>\t\t\t\t<ele>2599.547677</ele>\t\t\t\t<time>2000-01-01T02:03:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297103' lon='7.149074'>\t\t\t\t<ele>2601.955597</ele>\t\t\t\t<time>2000-01-01T02:04:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297124' lon='7.148988'>\t\t\t\t<ele>2603.875837</ele>\t\t\t\t<time>2000-01-01T02:04:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297124' lon='7.148967'>\t\t\t\t<ele>2605.308397</ele>\t\t\t\t<time>2000-01-01T02:04:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297146' lon='7.148945'>\t\t\t\t<ele>2605.308397</ele>\t\t\t\t<time>2000-01-01T02:04:50+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297146' lon='7.148924'>\t\t\t\t<ele>2605.308397</ele>\t\t\t\t<time>2000-01-01T02:04:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297146' lon='7.148881'>\t\t\t\t<ele>2608.203997</ele>\t\t\t\t<time>2000-01-01T02:05:18+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297124' lon='7.148881'>\t\t\t\t<ele>2607.716317</ele>\t\t\t\t<time>2000-01-01T02:05:20+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297103' lon='7.148902'>\t\t\t\t<ele>2608.203997</ele>\t\t\t\t<time>2000-01-01T02:05:22+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.148902'>\t\t\t\t<ele>2609.636556</ele>\t\t\t\t<time>2000-01-01T02:05:35+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297039' lon='7.148817'>\t\t\t\t<ele>2613.477036</ele>\t\t\t\t<time>2000-01-01T02:06:10+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297039' lon='7.148774'>\t\t\t\t<ele>2614.909596</ele>\t\t\t\t<time>2000-01-01T02:06:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297039' lon='7.148645'>\t\t\t\t<ele>2618.292876</ele>\t\t\t\t<time>2000-01-01T02:06:53+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.148516'>\t\t\t\t<ele>2621.157996</ele>\t\t\t\t<time>2000-01-01T02:07:19+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.148516'>\t\t\t\t<ele>2621.645676</ele>\t\t\t\t<time>2000-01-01T02:07:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297039' lon='7.148151'>\t\t\t\t<ele>2625.486156</ele>\t\t\t\t<time>2000-01-01T02:07:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.148130'>\t\t\t\t<ele>2625.486156</ele>\t\t\t\t<time>2000-01-01T02:07:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297060' lon='7.147937'>\t\t\t\t<ele>2628.381756</ele>\t\t\t\t<time>2000-01-01T02:08:06+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.147937'>\t\t\t\t<ele>2628.381756</ele>\t\t\t\t<time>2000-01-01T02:08:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.147808'>\t\t\t\t<ele>2631.734556</ele>\t\t\t\t<time>2000-01-01T02:08:38+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297081' lon='7.147765'>\t\t\t\t<ele>2636.062716</ele>\t\t\t\t<time>2000-01-01T02:09:17+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297146' lon='7.147486'>\t\t\t\t<ele>2636.550396</ele>\t\t\t\t<time>2000-01-01T02:09:38+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297167' lon='7.147422'>\t\t\t\t<ele>2637.982956</ele>\t\t\t\t<time>2000-01-01T02:09:51+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297232' lon='7.147315'>\t\t\t\t<ele>2637.982956</ele>\t\t\t\t<time>2000-01-01T02:10:01+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297275' lon='7.147057'>\t\t\t\t<ele>2638.470636</ele>\t\t\t\t<time>2000-01-01T02:10:19+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.146735'>\t\t\t\t<ele>2638.958316</ele>\t\t\t\t<time>2000-01-01T02:10:43+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.146606'>\t\t\t\t<ele>2640.878555</ele>\t\t\t\t<time>2000-01-01T02:10:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297360' lon='7.146521'>\t\t\t\t<ele>2641.366235</ele>\t\t\t\t<time>2000-01-01T02:10:59+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297382' lon='7.146478'>\t\t\t\t<ele>2642.798795</ele>\t\t\t\t<time>2000-01-01T02:11:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297360' lon='7.146456'>\t\t\t\t<ele>2642.311115</ele>\t\t\t\t<time>2000-01-01T02:11:14+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297318' lon='7.146435'>\t\t\t\t<ele>2645.694395</ele>\t\t\t\t<time>2000-01-01T02:11:44+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.146370'>\t\t\t\t<ele>2645.694395</ele>\t\t\t\t<time>2000-01-01T02:11:49+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.146349'>\t\t\t\t<ele>2645.206715</ele>\t\t\t\t<time>2000-01-01T02:11:52+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297296' lon='7.146070'>\t\t\t\t<ele>2645.206715</ele>\t\t\t\t<time>2000-01-01T02:12:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297275' lon='7.145727'>\t\t\t\t<ele>2647.614635</ele>\t\t\t\t<time>2000-01-01T02:12:37+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297360' lon='7.145426'>\t\t\t\t<ele>2649.534875</ele>\t\t\t\t<time>2000-01-01T02:13:00+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.145319'>\t\t\t\t<ele>2650.022555</ele>\t\t\t\t<time>2000-01-01T02:13:08+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.145298'>\t\t\t\t<ele>2650.479755</ele>\t\t\t\t<time>2000-01-01T02:13:12+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.145233'>\t\t\t\t<ele>2652.399995</ele>\t\t\t\t<time>2000-01-01T02:13:29+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297318' lon='7.145169'>\t\t\t\t<ele>2652.887675</ele>\t\t\t\t<time>2000-01-01T02:13:34+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297339' lon='7.145126'>\t\t\t\t<ele>2655.295595</ele>\t\t\t\t<time>2000-01-01T02:13:56+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297318' lon='7.145061'>\t\t\t\t<ele>2654.807915</ele>\t\t\t\t<time>2000-01-01T02:13:59+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297403' lon='7.144675'>\t\t\t\t<ele>2656.270955</ele>\t\t\t\t<time>2000-01-01T02:14:28+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297532' lon='7.144461'>\t\t\t\t<ele>2659.623755</ele>\t\t\t\t<time>2000-01-01T02:14:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297682' lon='7.144139'>\t\t\t\t<ele>2659.623755</ele>\t\t\t\t<time>2000-01-01T02:15:15+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297725' lon='7.143795'>\t\t\t\t<ele>2659.136075</ele>\t\t\t\t<time>2000-01-01T02:15:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297704' lon='7.143645'>\t\t\t\t<ele>2662.519355</ele>\t\t\t\t<time>2000-01-01T02:16:04+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297768' lon='7.143388'>\t\t\t\t<ele>2664.439595</ele>\t\t\t\t<time>2000-01-01T02:16:23+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297768' lon='7.143302'>\t\t\t\t<ele>2664.896795</ele>\t\t\t\t<time>2000-01-01T02:16:29+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.143259'>\t\t\t\t<ele>2664.896795</ele>\t\t\t\t<time>2000-01-01T02:16:33+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.143259'>\t\t\t\t<ele>2662.976555</ele>\t\t\t\t<time>2000-01-01T02:16:45+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.143259'>\t\t\t\t<ele>2662.519355</ele>\t\t\t\t<time>2000-01-01T02:16:48+01:00</time>\t\t\t</trkpt>\t\t\t<trkpt lat='45.297790' lon='7.143238'>\t\t\t\t<ele>2663.951915</ele>\t\t\t\t<time>2000-01-01T02:17:01+01:00</time>\t\t\t</trkpt>\t\t</trkseg>\t</trk></gpx>"

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
            const gpx_test = "<gpx xmlns='http://www.topografix.com/GPX/1/1' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd' version='1.1' creator='togpx'><metadata/><wpt lat='44.69919224313921' lon='7.156573534011842'><name></name><desc>label=Via Roma, Comune di Crissolo,Italia</desc></wpt><wpt lat='44.68691664176722' lon='7.160940170288087'><name></name><desc>label=Tivoli, Comune di Crissolo,Italia</desc></wpt><trk><name></name><desc>ascent=410.9 descent=3.1</desc><trkseg><trkpt lat='44.699197' lon='7.156556'><ele>1343</ele></trkpt><trkpt lat='44.699165' lon='7.156541'><ele>1343</ele></trkpt><trkpt lat='44.69908' lon='7.156461'><ele>1343</ele></trkpt><trkpt lat='44.699061' lon='7.156445'><ele>1343</ele></trkpt><trkpt lat='44.699052' lon='7.156468'><ele>1343</ele></trkpt><trkpt lat='44.698914' lon='7.156813'><ele>1343</ele></trkpt><trkpt lat='44.698729' lon='7.157245'><ele>1343</ele></trkpt><trkpt lat='44.698653' lon='7.157484'><ele>1343</ele></trkpt><trkpt lat='44.698604' lon='7.157664'><ele>1343</ele></trkpt><trkpt lat='44.698582' lon='7.157722'><ele>1343</ele></trkpt><trkpt lat='44.698567' lon='7.157762'><ele>1343</ele></trkpt><trkpt lat='44.698524' lon='7.157868'><ele>1343</ele></trkpt><trkpt lat='44.698499' lon='7.157921'><ele>1343</ele></trkpt><trkpt lat='44.698467' lon='7.157966'><ele>1343</ele></trkpt><trkpt lat='44.69836' lon='7.157976'><ele>1343</ele></trkpt><trkpt lat='44.698281' lon='7.158037'><ele>1343</ele></trkpt><trkpt lat='44.698174' lon='7.158085'><ele>1343</ele></trkpt><trkpt lat='44.698063' lon='7.158073'><ele>1343</ele></trkpt><trkpt lat='44.697912' lon='7.158095'><ele>1343</ele></trkpt><trkpt lat='44.697832' lon='7.158128'><ele>1343</ele></trkpt><trkpt lat='44.697755' lon='7.158186'><ele>1344</ele></trkpt><trkpt lat='44.697655' lon='7.158328'><ele>1344.6</ele></trkpt><trkpt lat='44.697563' lon='7.158412'><ele>1345.1</ele></trkpt><trkpt lat='44.697493' lon='7.158467'><ele>1345.8</ele></trkpt><trkpt lat='44.69746' lon='7.158495'><ele>1346.4</ele></trkpt><trkpt lat='44.697369' lon='7.158494'><ele>1347.1</ele></trkpt><trkpt lat='44.697322' lon='7.158527'><ele>1347.7</ele></trkpt><trkpt lat='44.697258' lon='7.158611'><ele>1348.4</ele></trkpt><trkpt lat='44.697142' lon='7.158888'><ele>1349.7</ele></trkpt><trkpt lat='44.697042' lon='7.15932'><ele>1351.6</ele></trkpt><trkpt lat='44.696808' lon='7.159738'><ele>1354.2</ele></trkpt><trkpt lat='44.696785' lon='7.159785'><ele>1354.9</ele></trkpt><trkpt lat='44.696708' lon='7.159852'><ele>1355.5</ele></trkpt><trkpt lat='44.696509' lon='7.160047'><ele>1355.9</ele></trkpt><trkpt lat='44.696447' lon='7.16012'><ele>1355.9</ele></trkpt><trkpt lat='44.696415' lon='7.160183'><ele>1356.3</ele></trkpt><trkpt lat='44.696341' lon='7.160331'><ele>1356.6</ele></trkpt><trkpt lat='44.696245' lon='7.160425'><ele>1357.1</ele></trkpt><trkpt lat='44.696178' lon='7.16024'><ele>1357.8</ele></trkpt><trkpt lat='44.696094' lon='7.160089'><ele>1358.6</ele></trkpt><trkpt lat='44.69597' lon='7.159997'><ele>1359.4</ele></trkpt><trkpt lat='44.695574' lon='7.159946'><ele>1363.3</ele></trkpt><trkpt lat='44.695341' lon='7.159876'><ele>1368.2</ele></trkpt><trkpt lat='44.695177' lon='7.159955'><ele>1371.2</ele></trkpt><trkpt lat='44.695172' lon='7.160447'><ele>1377.5</ele></trkpt><trkpt lat='44.695194' lon='7.160747'><ele>1380.8</ele></trkpt><trkpt lat='44.695129' lon='7.160961'><ele>1382.5</ele></trkpt><trkpt lat='44.695001' lon='7.161069'><ele>1384.2</ele></trkpt><trkpt lat='44.69485' lon='7.161133'><ele>1385.5</ele></trkpt><trkpt lat='44.694722' lon='7.161112'><ele>1386.9</ele></trkpt><trkpt lat='44.694614' lon='7.16124'><ele>1388.1</ele></trkpt><trkpt lat='44.694571' lon='7.161434'><ele>1389.1</ele></trkpt><trkpt lat='44.694314' lon='7.16167'><ele>1391.5</ele></trkpt><trkpt lat='44.694207' lon='7.16182'><ele>1392.2</ele></trkpt><trkpt lat='44.694014' lon='7.161949'><ele>1393.5</ele></trkpt><trkpt lat='44.693906' lon='7.162099'><ele>1393.1</ele></trkpt><trkpt lat='44.69382' lon='7.161927'><ele>1391.8</ele></trkpt><trkpt lat='44.693713' lon='7.162056'><ele>1390.4</ele></trkpt><trkpt lat='44.693658' lon='7.161831'><ele>1393.9</ele></trkpt><trkpt lat='44.693626' lon='7.161824'><ele>1398.1</ele></trkpt><trkpt lat='44.693471' lon='7.161994'><ele>1408</ele></trkpt><trkpt lat='44.69349' lon='7.16175'><ele>1413</ele></trkpt><trkpt lat='44.693412' lon='7.16177'><ele>1418</ele></trkpt><trkpt lat='44.693358' lon='7.161406'><ele>1428</ele></trkpt><trkpt lat='44.693205' lon='7.161594'><ele>1438</ele></trkpt><trkpt lat='44.693168' lon='7.161505'><ele>1442.9</ele></trkpt><trkpt lat='44.693141' lon='7.161623'><ele>1447.9</ele></trkpt><trkpt lat='44.693038' lon='7.16158'><ele>1452.8</ele></trkpt><trkpt lat='44.692991' lon='7.161803'><ele>1457.8</ele></trkpt><trkpt lat='44.692854' lon='7.161688'><ele>1462.8</ele></trkpt><trkpt lat='44.692564' lon='7.161778'><ele>1478.2</ele></trkpt><trkpt lat='44.692369' lon='7.162118'><ele>1489.9</ele></trkpt><trkpt lat='44.692257' lon='7.162172'><ele>1491.2</ele></trkpt><trkpt lat='44.692205' lon='7.162104'><ele>1492.3</ele></trkpt><trkpt lat='44.692165' lon='7.162176'><ele>1493.3</ele></trkpt><trkpt lat='44.691967' lon='7.162163'><ele>1496.2</ele></trkpt><trkpt lat='44.691765' lon='7.162338'><ele>1500.5</ele></trkpt><trkpt lat='44.691781' lon='7.161791'><ele>1509.7</ele></trkpt><trkpt lat='44.691676' lon='7.161821'><ele>1512.5</ele></trkpt><trkpt lat='44.691571' lon='7.161974'><ele>1515.6</ele></trkpt><trkpt lat='44.691399' lon='7.161892'><ele>1522.3</ele></trkpt><trkpt lat='44.691218' lon='7.161292'><ele>1538.3</ele></trkpt><trkpt lat='44.691102' lon='7.161229'><ele>1540.8</ele></trkpt><trkpt lat='44.690988' lon='7.161069'><ele>1543.8</ele></trkpt><trkpt lat='44.690838' lon='7.161172'><ele>1546.5</ele></trkpt><trkpt lat='44.690484' lon='7.161929'><ele>1559.8</ele></trkpt><trkpt lat='44.690372' lon='7.162059'><ele>1561.6</ele></trkpt><trkpt lat='44.690339' lon='7.162265'><ele>1563.1</ele></trkpt><trkpt lat='44.690046' lon='7.162819'><ele>1569.4</ele></trkpt><trkpt lat='44.689862' lon='7.163002'><ele>1573.1</ele></trkpt><trkpt lat='44.689753' lon='7.162984'><ele>1575.1</ele></trkpt><trkpt lat='44.689593' lon='7.163098'><ele>1577.1</ele></trkpt><trkpt lat='44.689264' lon='7.16385'><ele>1591.8</ele></trkpt><trkpt lat='44.688872' lon='7.164096'><ele>1603</ele></trkpt><trkpt lat='44.688263' lon='7.164156'><ele>1619.3</ele></trkpt><trkpt lat='44.687719' lon='7.165193'><ele>1640.1</ele></trkpt><trkpt lat='44.687424' lon='7.165604'><ele>1649.1</ele></trkpt><trkpt lat='44.686876' lon='7.166131'><ele>1666.6</ele></trkpt><trkpt lat='44.686529' lon='7.166283'><ele>1676.1</ele></trkpt><trkpt lat='44.686448' lon='7.166387'><ele>1678.2</ele></trkpt><trkpt lat='44.686333' lon='7.166369'><ele>1680.7</ele></trkpt><trkpt lat='44.686342' lon='7.166112'><ele>1685.9</ele></trkpt><trkpt lat='44.686493' lon='7.165557'><ele>1695.2</ele></trkpt><trkpt lat='44.686644' lon='7.16436'><ele>1710.9</ele></trkpt><trkpt lat='44.686657' lon='7.163818'><ele>1717.5</ele></trkpt><trkpt lat='44.686604' lon='7.163456'><ele>1720.7</ele></trkpt><trkpt lat='44.686604' lon='7.163107'><ele>1724</ele></trkpt><trkpt lat='44.686555' lon='7.16264'><ele>1729.4</ele></trkpt><trkpt lat='44.686737' lon='7.161861'><ele>1739.9</ele></trkpt><trkpt lat='44.686719' lon='7.161711'><ele>1741.6</ele></trkpt><trkpt lat='44.686768' lon='7.161574'><ele>1743.1</ele></trkpt><trkpt lat='44.68679' lon='7.161281'><ele>1746.2</ele></trkpt><trkpt lat='44.686894' lon='7.161146'><ele>1747.7</ele></trkpt><trkpt lat='44.686947' lon='7.161018'><ele>1749.3</ele></trkpt><trkpt lat='44.686945' lon='7.160939'><ele>1750.8</ele></trkpt></trkseg></trk></gpx>"
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
                start_time: "2022-01-01 22:00",
                duration: "on going",
                hike_ID: 2,
            };

            await hikeController.deleteScheduleByID(2);

            const user_ID = 5;

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
                ID: 2,
                end_time: "2022-01-02 23:00",
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
})
