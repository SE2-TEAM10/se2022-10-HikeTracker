# TODO:

## FIX ERRORS
> - FE - Put password verification (at least 8 characters, etc)
> - BE & FE - Put more explicit errors
> - BE - change *reference_point* table: 
> > - remove parking and huts, to add them into specific tables
> > - update coordinates of the points: they have to be taken from the GPX file

----

## HT-5 - Hut Description (ESTIMATION: 2 PTS)
> ### *As a local guide I want to insert a hut description*
### FROM THE FAQ:
> - *About story HT-5 and HT-15, can a hut worker “access” huts that were inserted by a local guide in HT-5? In other words, can a hut worker insert extra info for a hut by clicking a modify button on a hut that was inserted by a local guide?*
> > - *Yes, after a hut worker has been validate as actually working at a given hut she can add/modify information about that hut*
>
### BACK-END - to check
> **NEW TABLE** and **NEW POST**
> - NEW TABLE: *hut* (ID, name, opening_time, closing_time, bed_num, latitude, longitude, altitude, city, province)
> - dataset to be taken from: https://www.dati.piemonte.it/#/catalogodetail/regpie_ckan_ckan2_yucca_sdp_smartdatanet.it_RifugiOpenDa_2296
> - POST on hut
> - NEW TABLE: hut_user (hut_ID, user_ID) - this table links the hut to the user that has added it
> - unit tests
>
### FRONT-END
>- hut adding form

------

## HT-6 - Describe parking (ESTIMATION: 2 PTS)
> ### *As a local guide I want to add a parking lot*
### FROM THE FAQ:
> -
### BACK-END
> **NEW POST**
> - NEW TABLE parking_lot (ID, name, latitude, longitude)
> - POST on hike_ref?
> - unit tests
>
### FRONT-END
> - adding reference point form

------

## HT-7 - Search hut (ESTIMATION: 5 PTS)
> ### *As a hiker I want to search for hut description*
### FROM THE FAQ:
> -
### BACK-END
> - GET with parameters: geographical area, altitude and other things
> -
### FRONT-END
>
> -

-----

## HT-8 - Link start/arrival (ESTIMATION: 3 PTS)
> ### *As a local guide I want to add parking lots and huts as start/arrivals points for hikes*
### FROM THE FAQ:
> - *For stories 8/9/33 can the localguide work with all the hikes or only with those entered by her?*
> > - *a guide can change only her own hikes*
> - *When I add the hike, the gpx data give me simple coordinates as start and end points. And we save them in the db as simple coordinates, as you told us in the past answers. The work we need to do in story 8 is to display the parking lots/huts ALREADY PRESENT IN THE SYSTEM near the coordinates of the starting point/end point and give the local guide the ability to consider these parking lots/huts and their coordinates as starting/ending points? If yes, could you quantify "near"? Would 1 km from the location indicated by the gpx as starting/ending point be ok?*
> > - *yes, insted of near I would say nearest, that is in a radius of max 5 km*
### BACK-END
> - GET user_ID from user that is logged in
> - GET hike_ID of the hike that they want to link to the reference point
> - GET startp and endp from location (with the hike_ID)
> - analyze each parameter: start_lat, start_lon, end_lat, end_lon
> - do the radius analysis, through the formula of distance between two points: the points in question are lat (x1) and lon (y1) of the location and lat (x2) and lon (y2) of the reference point
> - save the data (name, type, lat, lon) of the point and the current distance as min_dist
> - if there is a point for which the distance is less, overwrite the data
### FRONT-END
>
> -

-----

## HT-9 - Link hut (ESTIMATION: 3 PTS)
> ### *As a local guide I want to link a hut to a hike So that hikers can better plan their hike*
### FROM THE FAQ:
> - *Can you confirm to me that the work that needs to be done in story 9 is to enter as an hike reference point a hut that is in the vicinity of the hike? Again, if yes, could you quantify "in the vicinity"? Is 1km okay?*
> > - *a hut liked to a hike is not necessarily a reference point, it could be just close to the hike but not on the hike. There is no distance threshold but typically is max 5 km from any point in the hike*

> - *What does "link a hut to a hike" mean? Should the hike be a new reference point?*
> > - *a hut is linked to a hike if it is close or somehow related to the hike, it may or may not be also a reference point.*
> 
> - *About story 9, can a local guide link huts that were not added by him?*
> > - *No, every guide operates on information that he entered*
> 
> - *Does this mean that hikes, huts, and parking lots can only be modified by the local guide that created them? Or just the hikes?*
> > - *Guides can change what they created.*
### BACK-END
> 
> - NEW TABLE: *hike_hut* (hike_ID, hut_ID)
### FRONT-END
>
> -

-----

## HT-33 - Define reference points (ESTIMATION: 5 PTS)
> ### *As a local guide I want to define reference points for a hike I added So that hikers can be tracked*
### FROM THE FAQ:
> - *Story 33 should allow me (as a local guide) to go to the map, pick a generic point in the surroundings of the hike (again, can you quantify "in the surroundings" ?) and enter it as a reference point? Should we create a new reference point for all the possible types of points or is it okay if we consider all types of reference points listed in the project submission document, except hut and parking lot? Because we have already entered hut/parking into the system with stories 6/7.*
> > - *not any point near but any point that is part of the hike trace, you can consider all types excepts paking lots and hikes*
>
> - *What does "define reference points for a hike I added" mean? Simply editing the list of reference points? And what is the difference between this and HT-9, since huts are reference points?*
> > - *yes selecting points from the track and making them reference points*
>
> - *What are reference points, exactly? Are they the sequence of points on the track itself, or just references that are useful for orienteering, but not strictly points that hikers go through?*
> > - *A reference point is a point belonging to the trace of hike that is selected and becomes a reference point with a label (e.g. water fountain, half way, bridge, huge rock, etc.)*
>
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-10 - Set profile (ESTIMATION: 5 PTS)
> ### *As a hiker I want to record my performance parameters So that I can get personalised recommendations*
### FROM THE FAQ:
> -
> > - 
>
> -
> > -
### BACK-END
> - NEW TABLE: hiker_data(hiker_ID, min_ascent, max_ascent, min_length, max_length, min_time, max_time, pref_diff, user_ID)
> - *ASK FOR CLARIFICATION: ask which are the parameters in detail*
> - GET of hikes based on preferences given from the form
> -
### FRONT-END
> - Form for insertion of preferences
> -

-----

## HT-11 - Filter hikes (ESTIMATION: 3 PTS)
> ### *As a hiker I want to filter the list of hikes based on my profile So that I can see them based on certain characteristics*
### FROM THE FAQ:
> - *What does "filter the hikes based on my profile so that I can see them based on certain characteristics" mean? What are these characteristics, and how do they differ from the filter from HT-1?*
> > - *performance are preferences in terms of duration and ascent (see FAQ on HT-10)*
>
> -
> > -
### BACK-END
> - get from hiker_data, with restrictions of the ID (getHikerDataFromUserID)
> -
### FRONT-END
>
> -

-----

## HT-31 - Register local guide (ESTIMATION: 3-5-8 PTS)
> ### *As a local guide I want to register To be able to access reserved features*
### FROM THE FAQ:
> - *what's the difference with HT-3? Is not the registration equal?*
> > - *HT-3 was intended for hikers, but can be a similar procedure*
>
> -
> > -
### BACK-END
> - add table "local_guide" (ID, authorized, ..., user_ID)
> - add a "platform manager" user, that receives the requests from the new local guides
> > - he can approve or reject the requests from the local guides
> > - if he rejects, the entry has to be deleted from the database
> - add a new column on user table: "authorized" (boolean) - it has to be set to 0 for the local guides, while it is 1 for everyone else
> > - *CHECK IF WE NEED TO DO IT*
> -
### FRONT-END
>
> -

-----

## HT-32 - Validate local guide (ESTIMATION: 2-3 PTS)
> ### *As a platform manager I want to validate a local guide registration So that they can access specific features*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> - retrieve the getAuthorized string
> > - if "accept", update "authorized" value on the user/local_guide table (with the ID) to 1
> > - if "decline", delete the entry on user/local_guide table
### FRONT-END
>
> -

-----

## HT-12 - Hut worker sign-up (ESTIMATION: PTS)
> ### *As a hut worker I want to request a user login So that I can operate on the platform*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> - copy and paste the code from HT-31, changing the role check value
### FRONT-END
>
> -

-----

## HT-13 - Verify hut worker (ESTIMATION: PTS)
> ### *As a platform manager I want to verify hut worker users So that they can operate on the platform*
### FROM THE FAQ:
> -
> > -
>
> -
> > - copy and paste the code from HT-32, changing the role check value
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-14 - Update hike condition (ESTIMATION: PTS)
> ### *As a hut worker I want to update the condition of a hike linked to the hut So that prospective hikers are informed*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-30 - Modify hike description (ESTIMATION: PTS)
> ### *As a local guide I want to modify and delete hikes I added*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-15 - Hut info (ESTIMATION: PTS)
> ### *As a hut worker I want to add information on the hut So that hikers can better plan their hike*
### FROM THE FAQ:
> - *About story HT-5 and HT-15, can a hut worker “access” huts that were inserted by a local guide in HT-5? In other words, can a hut worker insert extra info for a hut by clicking a modify button on a hut that was inserted by a local guide?*
> > - *Yes, after a hut worker has been validate as actually working at a given hut she can add/modify information about that hut*
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-16 - Hut pictures (ESTIMATION: PTS)
> ### *As a hut worker I want to add photos of the hut So that hikers can better plan their hike*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> NEW TABLE
> - table hut_img (hut_ID, img)
### FRONT-END
>
> -

-----

## HT-17 - Start hike (ESTIMATION: PTS)
> ### *As a hiker I want to start a registered hike So that I can record my position*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-18 - Terminate hike (ESTIMATION: PTS)
> ### *As a hiker I want to terminate a hike So that everybody is informed*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-19 - Record point (ESTIMATION: PTS)
> ### *As a hiker I want to record reaching a reference point of a registered hike So that I can track my hike*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-20 - Broadcasting URL (ESTIMATION: PTS)
> ### *As a hiker I want to get the broadcasting URL for my hike So that I can share it with my friends to let them follow me*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-21 - Monitor hike (ESTIMATION: PTS)
> ### *As a friend (of a hiker) I want to monitor the progress of my hiker friend*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-22 - Unfinished hike (ESTIMATION: PTS)
> ### *As a hiker I want to be notified about an unfinished hike So that I can terminate it*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-23 - Plan hike (ESTIMATION: PTS)
> ### *As a hiker I want to register a planned hike So that it can be later traced*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-24 - Add group (ESTIMATION: PTS)
> ### *As a hiker I want to add an hiker to a group for a planned hike So that we can hike together*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-25 - Confirm group (ESTIMATION: PTS)
> ### *As a hiker I want to be able to confirm group participation To be part of a group hike*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-26 - Confirm buddy end (ESTIMATION: PTS)
> ### *As a hiker I want to notify that someone of my group has completed their hike So that the group hike track is updated*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-27 - New weather alert (ESTIMATION: PTS)
> ### *As a platform manager I want to enter a weather alert for a given area So that hikers can be warned*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-28 - Notify buddy late (ESTIMATION: PTS)
> ### *As a hiker I want to be notified if someone of my group has not completed the hike yet So that I can verify her presence*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-29 - Weather alert notification (ESTIMATION: PTS)
> ### *As a hiker I want to receive a weather alert notification in my current hiking area So that I am warned*
### FROM THE FAQ:
> -
> > -
>
> -
> > -
### BACK-END
> 
> -
### FRONT-END
>
> -

-----