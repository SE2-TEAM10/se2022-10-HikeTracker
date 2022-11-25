# TODO:

## HT-2
### BACK-END
> **fix POST** on hikes:
> - Add two POSTs for location (done as a POST with a body made with 3-4 JSONs)
> - Add a POST on *hike_user*, by adding the *hike_ID* and retreiving the *user_ID* through the login
> -  Add a POST on *hike_gpx*, by adding the path of the gpx file (as a string)
> -  unit tests

> **fix TABLE**:
> - NEW TABLE: *reference_points* (ID, name, type, latitude, longitude) - to add parking lots, addresses
> - FIX TABLE *hike_ref* - to insert only *hike_ID* and *ref_ID*

### FRONT-END
> **NEW FORM**
> - Add creation of a new hike form
> - Add locations form
> - Import GPX file

> **fix ERRORS**
> - Add "Clear" button on filters
> - Fix UI with less details for each hike **[ISSUE 1]**

----

## HT-3 - Registration
### BACK-END
> **fix TABLE**
> - *user* table - add "mail_verification" attribute
> 
> **Implementation of registration**:
> - POST on *user* table (with boolean value for verification of email, initially set to false)
> - PUT on *user* table (boolean value for verification of email set to true)
> - unit tests
### FRONT-END
> **NEW FORM**
> - Registration form
> - Verification of email

----

## HT-4 - Hikes Details
### BACK-END
> **NEW GET**:
> - GET on *hike*, *location* and *hike_gpx*
> - unit tests
>
### FRONT-END - to check
> **NEW TABLE**
> - cards with route once you click on it
> - More details on the route
> - GPX download button 

----

## HT-5 - Hut Description
### BACK-END - to check
> **NEW TABLE** and **NEW POST**
> - NEW TABLE: *hut* (ID, name, opening_time, closing_time, bed_num, latitude, longitude)
> - POST on hut
> - unit tests
>
### FRONT-END
>- hut adding form

------

## HT-6 - Describe parking
### BACK-END
> **NEW POST**
> - POST on reference_points
> - POST on hike_ref
> - unit tests
>
### FRONT-END
> - adding reference point form

------

## HT-7 - Search hut
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-8 - Link start/arrival
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-9 - Link hut
### BACK-END
> 
> - NEW TABLE: *hike_hut* (hike_ID, hut_ID)
### FRONT-END
>
> -

-----

## HT-33 - Define reference points
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-10 - Set profile
### BACK-END
> NEW TABLE: hiker_data(hiker_ID, max_ascent, max_length, min_time, ...)
> *ASK FOR CLARIFICATION: ask which are the parameters in detail*
> -
### FRONT-END
>
> -

-----

## HT-11 - Filter hikes
### BACK-END
> get from hiker_data
> -
### FRONT-END
>
> -

-----

## HT-31 - Register local guide 
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-32 - Validate local guide 
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-12 - Hut worker sign-up
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-13 - Verify hut worker
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-14 - Update hike condition
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-30 - Modify hike description
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-15 - Hut info
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-16 - Hut pictures
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-17 - Start hike
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-18 - Terminate hike
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-19 - Record point
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-20 - Broadcasting URL
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-21 - Monitor hike
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-22 - Unfinished hike
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-23 - Plan hike
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-24 - Add group
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-25 - Confirm group
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-26 - Confirm buddy end
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-27 - New weather alert
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-28 - Notify buddy late
### BACK-END
> 
> -
### FRONT-END
>
> -

-----

## HT-29 - Weather alert notification
### BACK-END
> 
> -
### FRONT-END
>
> -

-----