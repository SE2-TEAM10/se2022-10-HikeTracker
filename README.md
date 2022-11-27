# SE2022-10-HikeTracker

##### This is the official repository for the Hike Tracker Project, developed by _Team 10_ from the Software Engineering II Course at Politecnico di Torino.

## Analysis

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-orange.svg)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker) 

[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=ncloc)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)  [![Technical Debt](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=sqale_index)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Duplicated Lines (%)](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Bugs](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=bugs)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)   [![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=SE2-TEAM10_se2022-10-HikeTracker&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=SE2-TEAM10_se2022-10-HikeTracker)

## Technology Stack

### Frontend

<img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/>

- [Flutter](https://flutter.dev/)

- [Dart](https://dart.dev/)


### Backend

<img src="https://upload.vectorlogo.zone/logos/javascript/images/239ec8a4-163e-4792-83b6-3f6d96911757.svg" alt="flutter" width="40" height="40"/> <img src="https://www.vectorlogo.zone/logos/nodejs/nodejs-ar21.svg" alt="dart" width="80" height="40"/>

- [Javascript](https://www.javascript.com/)
- [Node.js](https://nodejs.org/)


## Docker instructions

### Build the backend docker image

Open the terminal from the backend folder and run the following command:
```
sudo docker image build -t se2team10/se2hiketracker:be .
```
This will build a Docker image with the name _se2team10/se2hiketracker_ and tagname _be_.

### Push the image on docker hub

Run the following command:
```
docker push se2team10/se2hiketracker:be
```

### Run the backend image container

Run the following command: 
```
docker run -p 8080:5000 se2team10/se2hiketracker:be
```

This command binds the port 5000 configured in the container to the TCP port 8080, accessible from the browser.

---

### Build the frontend docker image

Open the terminal from the frontend folder and run the following command:
```
sudo docker image build -t se2team10/se2hiketracker:fe .
```
This will build a Docker image with the name _se2team10/se2hiketracker_ and tagname _fe_.

### Push the image on docker hub

Run the following command:
```
docker push se2team10/se2hiketracker:fe
```


### Run the frontend image container

Run the following command:
```
docker run -p 8080:5000 se2team10/se2hiketracker:fe
```

This command binds the port 5000 configured in the container to the TCP port 8080, accessible from the browser.




## API Server

* GET


* POST


* PUT


* DELETE




## Database tables

Table `hike` contains all the hikes details

| ID | name      | length (km) | expected_time (h) | ascent (m) | difficulty   | start_point | end_point | description |    
|-----------|--------------|----------|-----------|--------------|----------|-----------|--------------|----------|      
| 1   | Monte Tivoli | 5  | 02:00 | 410 | T | Crissolo | Monte Tivoli | Really easy and frequented hike, with really low possibility of errors |


Table `location` contains all the information of one specific point

| location_name | latitude | longitude | city | province | hike_ID  |  
|-----------|--------------|----------|-----------|--------------|----------|      
| Crissolo   | 44.415886 | 7.09184  | Crissolo | Cuneo | 1 |

Table `user` contains all user details

| ID | name | surname | mail | password | salt | role | verified |
|-----------|--------------|----------|-----------|--------------|----------|--------------|----------|      
| 2   | Jennifer | Lopez  | jennifer.lopez@hike.it | 8b6050d373a65ad78349c9baa7c9b93b60c4ce7c4de47b9ac6f0e57afebd36c8 | 44f4316added2354 |Local guide | 1


Table `reference_point` contains all the reference point for each hike

| ID | name | type | latitude | longitude |
|-----------|--------------|----------|-----------|--------------|    
| 1   | Rifugio Ca Asti | hut  | 45.1912471993807 | 7.07466855582291 | 


Table `hike_user` contains relation between table _hike_ and table _user_

| hike_ID | user_ID |
|-----------|-----|    
| 1   | 1 |  


Table `hike_gpx` contains relation between table _hike_ and table _hike_gpx_

| ID | gpx | hike_ID |
|-------|--------|----------|     
| 1   | _string xml_ | 1  | 

Table `hike_rf` contains relation between table _hike_ and table _reference_point_

| hike_ID | ref_ID |
|-----------|-----|    
| 1   | 1 |  


## Users credentials

```
Email: john.doe@hike.it
Password: localguide1
```

```
Email: jennifer.lopez@hike.it
Password: localguide2
```

```
Email: massimiliano.allegri@hike.it
Password: localguide3
```



## Team members

| Matricola | Surname      | Name     |      
|-----------|--------------|----------|      
| s301270   | Gangemi      | Lorenzo  |
| s305535   | Santo        | Lorenzo  |
| s299724   | Zhu          | Fayou    |
| s306136   | Di Benedetto | Giovanna |
| s303280   | Mlaiji       | Manar    |
| s295413   | Giangreco    | Samuele  |




