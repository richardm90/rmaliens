-- Ensure the connection is using system naming
-- Set the library list (not needed for user RMALIENS), which
--   has the initial library list set by the job description.
CL: CHGLIBL LIBL(RMALIENS ILEVATOR NOXDB QGPL QTEMP);
STOP;

-- -----------------------------------------------------------------------------
-- Use the Google Sheet external data source ...
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
