# SE2022-10-HikeTracker

##### This is the official repository for the Hike Tracker Project, developed by _Team 10_ from the Software Engineering II Course at Politecnico di Torino.

## Analysis

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-orange.svg)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker) 

[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=ncloc)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)  [![Technical Debt](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=sqale_index)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Duplicated Lines (%)](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Bugs](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=bugs)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)

# Table of contents
1. [Technology Stack](#technolystack)
    1. [Frontend](#frontend)
    2. [Backend](#backend)
2. [Docker Instructions](#docker)
    1. [Docker compose](#compose)
    2. [Backend docker image](#buildbe)
    3. [Frontend docker image](#buildfe)
3. [API Server](#api)
    1. [GET](#get)
    2. [POST](#post)
    3. [PUT](#put)
    4. [DELETE](#delete)
4. [Database tables](#database)
5. [User Credentials](#usercredentials)
6. [Team](#team)




## Technology Stack <a name="technolystack">

### Frontend <a name="frontend">

<img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/>

- [Flutter](https://flutter.dev/)

- [Dart](https://dart.dev/)


### Backend <a name="backend">

<img src="https://upload.vectorlogo.zone/logos/javascript/images/239ec8a4-163e-4792-83b6-3f6d96911757.svg" alt="flutter" width="40" height="40"/> <img src="https://www.vectorlogo.zone/logos/nodejs/nodejs-ar21.svg" alt="dart" width="80" height="40"/>

- [Javascript](https://www.javascript.com/)
- [Node.js](https://nodejs.org/)


## Docker Instructions <a name="docker">

### Docker compose <a name="compose">

From the project directory, start up the application by running ```docker compose up``` .

---
    
### Build the backend docker image <a name="buildbe">

Open the terminal from the backend folder and run the following command:
```
sudo docker image build -t se2team10/se2hiketracker:be .
```
This will build a Docker image with the name _se2team10/se2hiketracker_ and tagname _be_.

### Push the image on docker hub <a name="pushbe">

Run the following command:
```
docker push se2team10/se2hiketracker:be
```

### Run the backend image container <a name="runbe">

Run the following command: 
```
docker run -p 8080:5000 se2team10/se2hiketracker:be
```

This command binds the port 5000 configured in the container to the TCP port 8080, accessible from the browser.

---

### Build the frontend docker image <a name="buildfe">

Open the terminal from the frontend folder and run the following command:
```
sudo docker image build -t se2team10/se2hiketracker:fe .
```
This will build a Docker image with the name _se2team10/se2hiketracker_ and tagname _fe_.

### Push the image on docker hub <a name="pushfe">

Run the following command:
```
docker push se2team10/se2hiketracker:fe
```


### Run the frontend image container <a name="runfe">

Run the following command:
```
docker run -p 8080:5000 se2team10/se2hiketracker:fe
```

This command binds the port 5000 configured in the container to the TCP port 8080, accessible from the browser.



## API Server <a name="api">

 GET <a name="get">

- ```/api/sessions/current```

- ```/api/hike```

- ```/api/hikesdetails/:hike_ID```

- ```/api/sendEmail```

- ```/api/user/verify/:token```



POST <a name="post">

- ```/api/sessions```

- ```/api/hike```

- ```/api/gpx```

- ```/api/addUser```


PUT <a name="put">

- ```/api/id/:setVerified```


DELETE <a name="delete">

- ```/api/sessions/current```


## Database tables <a name="database">

Table `hike` contains all the hikes details

| ID | name      | length (km) | expected_time (h) | ascent (m) | difficulty   | start_point | end_point | description |    
|-----------|--------------|----------|-----------|--------------|----------|-----------|--------------|----------|      
| 1   | Monte Tivoli | 5  | 02:00 | 410 | T | Crissolo | Monte Tivoli | Really easy and frequented hike |


Table `location` contains all the information of one specific point

| location_name | latitude | longitude | city | province | hike_ID  |  start_end |
|-----------|--------------|----------|-----------|--------------|----------|----|      
| Crissolo   | 44.415886 | 7.09184  | Crissolo | Cuneo | 1 | start |

Table `user` contains all user details

| ID | name | surname | mail | password | salt | role | verified |
|-----------|--------------|----------|-----------|--------------|----------|--------------|----------|      
| 2   | Jennifer | Lopez  | jennifer.lopez@hike.it | 8b6050d373a65ad78349c9baa7c9b93b60c4ce7c4de47b9ac6f0e57afebd36c8 | 44f4316added2354 |Local guide | 1

Table `parking_lot` contains all the parking lot

| ID | name | capacity | latitude | longitude |city | province | user_ID |
|----|------|----------|----------|-----------|-----|----------|---------|    
| 1   | Parcheggio di Cortavetto | 100  | 45.10281 | 7.16555 | Cortavetto | Torino | 3 |

Table `reference_point` contains all the reference point for each hike

| ID | name | type | latitude | longitude |city | province | user_ID |
|----|------|------|----------|-----------|-----|----------|---------|    
| 1   | Villaggio Albaron | village  | 45.30241 | 7.224057 | Balme | Torino | 1 |

Table `hut` contains all the huts

| ID | name | description | opening_time | closing_time |bed_num | altitude | latitude | longitude |city | province |phone |mail | website |user_ID|
|----|------|-------------|--------------|--------------|--------|----------|----------|-----------|-----|----------|------|-----|---------|-------|   
| 1 | Rifugio Ca Asti | _string description_ | 08:00 | 22:00 | 60 | 2854 | 45.10281 | 7.16555 | Rocciamelone | Torino | _phone number_ | jennifer.lopez@hike.it | www.hikers.it | 1


Table `hike_user` contains relation between table _hike_ and table _user_

| hike_ID | user_ID |
|-----|---|    
| 1   | 1 |  


Table `hike_gpx` contains relation between table _hike_ and table _hike_gpx_

| ID | gpx | hike_ID |
|-------|--------|----------|     
| 1   | _string xml_ | 1  | 

Table `hike_user_ref` contains relation between table _hike_ , table _user_  and table _reference_point_

| hike_ID | user_ID | ref_ID | ref_type|
|-----------|-----|---|----|    
| 5   | 1 | 2 | point |  

Table `hike_user_parking` contains relation between table _hike_ , table _user_  and table _parking lot_

| hike_ID | user_ID | parking_ID | ref_type|
|-----------|-----|---|----| 
| 32   | 3 | 3 | point | 

Table `hike_user_hut` contains relation between table _hike_ , table _user_  and table _hut_

| ID | path | hut_ID | type|
|-----------|-----|----|----|  
| 3   | 1 | 1 | point | 

Table `hike_image` contains all the images

| hike_ID | user_ID | hike_ID | ref_type|
|-----------|-----|---|----|
| 1   | _path_ | 1 | cover | 

Table `border` contains the coordinates that delimit a municipality

| ID | coordinates |
|-----------|-----|    
| 1001   | _set of coordinates_ |  

Table `municipality` contains all the cities for each province

| ID | name | province_ID |
|-------|--------|--------|     
| 1272  | Torino | 1      | 

Table `province` contains all the provinces of Piedmont

| ID | name | province_ID |
|-------|--------|--------|     
| 1  | 1 | Torino     | 

Table `region` contains all Italian regions

| ID | name |
|-------|--------| 
| 1  | Piemonte     | 


## Users credentials <a name="usercredentials">

- Local guide

```
Email: john.doe@hike.it
Password: Localguide1!
```

```
Email: jennifer.lopez@hike.it
Password: Localguide1!
```

```
Email: massimiliano.allegri@hike.it
Password: Localguide1!
```

- Platform manager

```
Email: sandra.bullock@hike.it
Password: Manager4!
```

- Hiker

```
Email: orlando.bloom@hike.it
Password: Hikerhiker2!
```

```
Email: julia.roberts@hike.it
Password: Hikerhiker2!
```

```
Email: tom.cruise@hike.it
Password: Hikerhiker2!
```

- Hut worker

```
Email: lady.gaga@hike.it
Password: Hutworker3!
```

```
Email: ed.sheeran@hike.it
Password: Hutworker3!
```

```
Email: katy.perry@hike.it
Password: Hutworker3!
```



## Team members <a name="team">

| Matricola | Surname      | Name     |      
|-----------|--------------|----------|      
| s301270   | Gangemi      | Lorenzo  |
| s305535   | Santo        | Lorenzo  |
| s299724   | Zhu          | Fayou    |
| s306136   | Di Benedetto | Giovanna |
| s303280   | Mlaiji       | Manar    |
| s295413   | Giangreco    | Samuele  |




