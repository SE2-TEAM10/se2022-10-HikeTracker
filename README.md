# SE2022-10-HikeTracker

##### This is the official repository for the Hike Tracker Project, developed by _Team 10_ from the Software Engineering II Course at Politecnico di Torino.



## Technology Stack

### Frontend

<img src="https://www.vectorlogo.zone/logos/flutterio/flutterio-icon.svg" alt="flutter" width="40" height="40"/> <img src="https://www.vectorlogo.zone/logos/dartlang/dartlang-icon.svg" alt="dart" width="40" height="40"/>

- [Flutter](https://flutter.dev/)

- [Dart](https://dart.dev/)


### Backend

<img src="https://upload.vectorlogo.zone/logos/javascript/images/239ec8a4-163e-4792-83b6-3f6d96911757.svg" alt="flutter" width="40" height="40"/> <img src="https://www.vectorlogo.zone/logos/nodejs/nodejs-ar21.svg" alt="dart" width="80" height="40"/>

- [Javascript](https://www.javascript.com/)
- [Node.js](https://nodejs.org/)



## API Server

* GET


* POST


* PUT


* DELETE




## Database tables

Table `hike` contains all the hikes details

Table `location` contains 

Table `user` contains all user details

Table `reference_point` contains all the reference point of each hike

Table `hike_user` contains relation between table _hike_ and table _user_

Table `hike_gpx` contains relation between table _hike_ and table _hike_gpx_

Table `hike_rf` contains relation between table _hike_ and table _reference_point_



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




