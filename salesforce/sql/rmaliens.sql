-- Ensure the connection is using system naming
-- Set the library list (not needed for user RMALIENS), which
--   has the initial library list set by the job description.
CL: CHGLIBL LIBL(RMALIENS ILEVATOR NOXDB LIBHTTP YAJL QGPL QTEMP);
STOP;

-- First time through? Let's use the Cloud DB external data source ...
CL: ADDENVVAR ENVVAR(RMALIENS_HOST) VALUE('localhost');
CL: ADDENVVAR ENVVAR(RMALIENS_PORT) VALUE('3101');
STOP;

-- Let's start by deleting all rows from the Cloud Person DB
CALL PERSON_DELETEALL();
STOP;

-- Seed the Cloud DB with some Star Trek characters
--   - we are providing the first name and last name
--   - ignore the empty third parameter, this is the returned response
CALL PERSON_CREATE('Beverly', 'Crusher', '');
CALL PERSON_CREATE('Christopher', 'Pike', '');
CALL PERSON_CREATE('Deanna', 'Troi', '');
CALL PERSON_CREATE('Geordi', 'La Forge', '');
CALL PERSON_CREATE('Hikaru', 'Sulu', '');
CALL PERSON_CREATE('James T.', 'Kirk', '');
CALL PERSON_CREATE('Jean-Luc', 'Picard', '');
CALL PERSON_CREATE('Khan Noonien', 'Singh', '');
CALL PERSON_CREATE('Leonard', 'McCoy', '');
CALL PERSON_CREATE('Montgomery', 'Scott', '');
CALL PERSON_CREATE('Mr', 'Data', '');
CALL PERSON_CREATE('Mr', 'Spock', '');
CALL PERSON_CREATE('Nyota', 'Uhura', '');
CALL PERSON_CREATE('Pavel', 'Chekov', '');
CALL PERSON_CREATE('Wesley', 'Crusher', '');
CALL PERSON_CREATE('William', 'Riker', '');
CALL PERSON_CREATE('Worf', '', '');
STOP;

-- Now let's get all person rows from the Cloud DB
CALL PERSON_GETALL('');
STOP;

-- You can also get and delete a specific person based on their Id
CALL PERSON_CREATE('Mr', 'Blobby', '');
CALL PERSON_GET(93, '');
CALL PERSON_DELETE(93, '');
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


-- -----------------------------------------------------------------------------
-- Third time through? Now let's use the Salesforce external data source ...
CL: CHGENVVAR ENVVAR(RMALIENS_HOST) VALUE('localhost');
CL: CHGENVVAR ENVVAR(RMALIENS_PORT) VALUE('3103');
CL: CHGENVVAR ENVVAR(RMALIENS_SF_MODE) VALUE('direct');
CL: ADDENVVAR ENVVAR(RMALIENS_SF_MODE) VALUE('nodejs');
STOP;

-- Let's start with an empty spreadsheet!
CALL CONTACT_DELETEALL();
STOP;

-- Seed the Salesforce contacts with some Star Trek characters
--   - we are providing the first name and last name
--   - ignore the empty third parameter, this is the returned response
--   - note that Salesforce requires a contact first name and last name
CALL CONTACT_CREATE('Beverly', 'Crusher', '');
CALL CONTACT_CREATE('Christopher', 'Pike', '');
CALL CONTACT_CREATE('Deanna', 'Troi', '');
CALL CONTACT_CREATE('Geordi', 'La Forge', '');
CALL CONTACT_CREATE('Hikaru', 'Sulu', '');
CALL CONTACT_CREATE('James T.', 'Kirk', '');
CALL CONTACT_CREATE('Jean-Luc', 'Picard', '');
CALL CONTACT_CREATE('Khan Noonien', 'Singh', '');
CALL CONTACT_CREATE('Leonard', 'McCoy', '');
CALL CONTACT_CREATE('Montgomery', 'Scott', '');
CALL CONTACT_CREATE('Mr', 'Data', '');
CALL CONTACT_CREATE('Mr', 'Spock', '');
CALL CONTACT_CREATE('Nyota', 'Uhura', '');
CALL CONTACT_CREATE('Pavel', 'Chekov', '');
CALL CONTACT_CREATE('Wesley', 'Crusher', '');
CALL CONTACT_CREATE('William', 'Riker', '');
CALL CONTACT_CREATE('Worf', 'TBC', '');
STOP ;

-- Now let's get all of our contact rows from Salesforce
CALL CONTACT_GETALL('');
STOP;

-- You can also get and delete a specific contact based on their Id
CALL CONTACT_GET('003WU0000036WTKYA2', '');
CALL CONTACT_DELETE('003WU0000035L25YAE', '');
STOP;

