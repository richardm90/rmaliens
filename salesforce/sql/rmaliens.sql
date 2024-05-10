-- Ensure the connection is using system naming
-- Set the library list (not needed for user RMALIENS), which
--   has the initial library list set by the job description.
CL: CHGLIBL LIBL(RMALIENS LIBHTTP YAJL QGPL QTEMP);
STOP ;

-- Set the host and post
CL: ADDENVVAR ENVVAR(RMALIENS_HOST) VALUE('localhost');
CL: ADDENVVAR ENVVAR(RMALIENS_PORT) VALUE('3103');
STOP;

-- Seed the Cloud DB with some Star Trek characters
--   - we are providing the first name and last name
--   - ignore the empty third parameter, this is the returned response
CALL CONTACT_CREATE_A('Beverly', 'Crusher', '');
CALL CONTACT_CREATE_A('Christopher', 'Pike', '');
CALL CONTACT_CREATE_A('Deanna', 'Troi', '');
CALL CONTACT_CREATE_A('Geordi', 'La Forge', '');
CALL CONTACT_CREATE_A('Hikaru', 'Sulu', '');
CALL CONTACT_CREATE_A('James T.', 'Kirk', '');
CALL CONTACT_CREATE_A('Jean-Luc', 'Picard', '');
CALL CONTACT_CREATE_A('Khan Noonien', 'Singh', '');
CALL CONTACT_CREATE_A('Leonard', 'McCoy', '');
CALL CONTACT_CREATE_A('Montgomery', 'Scott', '');
CALL CONTACT_CREATE_A('Mr', 'Data', '');
CALL CONTACT_CREATE_A('Mr', 'Spock', '');
CALL CONTACT_CREATE_A('Nyota', 'Uhura', '');
CALL CONTACT_CREATE_A('Pavel', 'Chekov', '');
CALL CONTACT_CREATE_A('Wesley', 'Crusher', '');
CALL CONTACT_CREATE_A('William', 'Riker', '');
CALL CONTACT_CREATE_A('Worf', 'TBC', '');
STOP ;

-- First time through? Set the Salesforce credentials ...
--   - this should be stored externally, do not put your credentials in this source!
CL: ADDENVVAR ENVVAR(SF_BASE_URL)       VALUE('<SF_BASE_URL>');
CL: ADDENVVAR ENVVAR(SF_CLIENT_ID)      VALUE('<SF_CLIENT_ID>');
CL: ADDENVVAR ENVVAR(SF_CLIENT_SECRET)  VALUE('<SF_CLIENT_SECRET>');
CL: ADDENVVAR ENVVAR(SF_USERNAME)       VALUE('<SF_USERNAME>');
CL: ADDENVVAR ENVVAR(SF_PASSWORD)       VALUE('<SF_PASSWORD>');
CL: ADDENVVAR ENVVAR(SF_SECURITY_TOKEN) VALUE('<SF_SECURITY_TOKEN>');
STOP ;

-- Seed the Cloud DB with some Star Trek characters
--   - we are providing the first name and last name
--   - ignore the empty third parameter, this is the returned response
CALL CONTACT_CREATE_B('Beverly', 'Crusher', '');
CALL CONTACT_CREATE_B('Christopher', 'Pike', '');
CALL CONTACT_CREATE_B('Deanna', 'Troi', '');
CALL CONTACT_CREATE_B('Geordi', 'La Forge', '');
CALL CONTACT_CREATE_B('Hikaru', 'Sulu', '');
CALL CONTACT_CREATE_B('James T.', 'Kirk', '');
CALL CONTACT_CREATE_B('Jean-Luc', 'Picard', '');
CALL CONTACT_CREATE_B('Khan Noonien', 'Singh', '');
CALL CONTACT_CREATE_B('Leonard', 'McCoy', '');
CALL CONTACT_CREATE_B('Montgomery', 'Scott', '');
CALL CONTACT_CREATE_B('Mr', 'Data', '');
CALL CONTACT_CREATE_B('Mr', 'Spock', '');
CALL CONTACT_CREATE_B('Nyota', 'Uhura', '');
CALL CONTACT_CREATE_B('Pavel', 'Chekov', '');
CALL CONTACT_CREATE_B('Wesley', 'Crusher', '');
CALL CONTACT_CREATE_B('William', 'Riker', '');
CALL CONTACT_CREATE_B('Worf', 'TBC', '');
STOP ;

-- You can also get and delete a specific person based on their Id
CALL CONTACT_CREATE_B('Mr', 'Blobby', '');
CALL CONTACT_GET_B('003WU0000034Y6EYAU', '');
CALL CONTACT_DELETE_B('003WU0000034Y6EYAU', '');
STOP;

------------------------------


-- Let's start by deleting all rows from the Cloud Person DB
CALL PERSON_DELETEALL();
STOP ;

-- Now let's get all person rows from the Cloud DB
CALL PERSON_GETALL('');
STOP;

-- You can also get and delete a specific person based on their Id
CALL PERSON_CREATE('Mr', 'Blobby', '');
CALL PERSON_GET(18, '');
CALL PERSON_DELETE(18, '');
STOP;

-- Now let's download all person rows from the Cloud DB
--   to a local DB2 for i table
DELETE FROM PERSON;
CALL PERSON_DOWNLOAD();
SELECT * FROM PERSON ORDER BY FIRSTNAME, LASTNAME ;
STOP;

-- -----------------------------------------------------------------------------
-- Accessing the data via SQL

-- Will not work if sysval QCCSID = 65535
-- CL: chgjob ccsid(1146);

-- This first example is going to populate a global variable with our JSON data
CREATE OR REPLACE VARIABLE JSON_DATA CLOB(1M) CCSID 1208 ;
-- DROP VARIABLE JSON_DATA ;
-- SET JSON_DATA = '' ;

-- Populate the global SQL variable using a stored procedure
CALL PERSON_GETALL(JSON_DATA);

-- Read the JSON data using JSON_TABLE
-- - remember 'JSON_DATA' is a global variable
SELECT P.*
        FROM JSON_TABLE( JSON_DATA,
                         'lax $[*]'
                         COLUMNS ( id        INTEGER        PATH 'lax $.id',
                                   firstname VARCHAR(255)   PATH 'lax $.firstName',
                                   lastname  VARCHAR(255)   PATH 'lax $.lastName' ) ) AS  P
        ORDER BY FIRSTNAME, LASTNAME
;

-- An alternative method is to get the data directly from the API
SELECT P.*
        FROM JSON_TABLE( HTTP_GET('http://localhost:3101/persons'),
                         'lax $[*]'
                         COLUMNS ( id        INTEGER       PATH 'lax $.id',
                                   firstname VARCHAR(255)  PATH 'lax $.firstName',
                                   lastname  VARCHAR(255)  PATH 'lax $.lastName' ) ) AS  P
--         WHERE LASTNAME='Dunphy'
        ORDER BY FIRSTNAME, LASTNAME
;
STOP;


-- -----------------------------------------------------------------------------
-- Second time through? Now let's use the Google Sheet external data source ...
CL: CHGENVVAR ENVVAR(RMALIENS_HOST) VALUE('localhost');
-- CL: CHGENVVAR ENVVAR(RMALIENS_HOST) VALUE('iug1.rowton.it');
CL: CHGENVVAR ENVVAR(RMALIENS_PORT) VALUE('3102');
STOP;

-- Let's start with an empty spreadsheet!
CALL PERSON_DELETEALL();
STOP;

-- We'll seed the Google Sheet with some Stars Wars characters
--  - we are providing the first name and last name
--  - ignore the empty third parameter, this is the returned response
CALL PERSON_CREATE('Admiral', 'Ackbar', '');
CALL PERSON_CREATE('Anakin', 'Skywalker', '');
CALL PERSON_CREATE('Boba', 'Fett', '');
CALL PERSON_CREATE('C3-PO', '', '');
CALL PERSON_CREATE('Chewbacca', '', '');
CALL PERSON_CREATE('Darth', 'Sidious', '');
CALL PERSON_CREATE('Darth', 'Vadar', '');
CALL PERSON_CREATE('Grand Moff', 'Tarkin', '');
CALL PERSON_CREATE('Han', 'Solo', '');
CALL PERSON_CREATE('Lando', 'Calrissian', '');
CALL PERSON_CREATE('Leia', 'Organa', '');
CALL PERSON_CREATE('Luke', 'Skywalker', '');
CALL PERSON_CREATE('Mon', 'Mothma', '');
CALL PERSON_CREATE('Obi-Wan', 'Kenobi', '');
CALL PERSON_CREATE('Owen', 'Lars', '');
CALL PERSON_CREATE('R2-D2', '', '');
CALL PERSON_CREATE('Yoda', '', '');
STOP;

-- Now let's get all person rows from the spreadsheet
CALL PERSON_GETALL('');
STOP;

-- You can also get and delete a specific person based on their Id
CALL PERSON_GET(13, '');
CALL PERSON_DELETE(13, '');
STOP;

-- How about we upload (to the spreadsheet) all of the Star Wars characters 
--      we previously downloaded to our local DB2 for i PERSON table?
SELECT * FROM PERSON ORDER BY FIRSTNAME, LASTNAME ;
CALL PERSON_UPLOAD();
CALL PERSON_GETALL('');
STOP;
