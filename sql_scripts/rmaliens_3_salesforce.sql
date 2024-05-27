-- Ensure the connection is using system naming
-- Set the library list (not needed for user RMALIENS), which
--   has the initial library list set by the job description.
CL: CHGLIBL LIBL(RMALIENS ILEVATOR NOXDB LIBHTTP YAJL QGPL QTEMP);
STOP;

-- -----------------------------------------------------------------------------
-- Use the Salesforce external data source ...
CL: ADDENVVAR ENVVAR(RMALIENS_HOST) VALUE('localhost');
CL: ADDENVVAR ENVVAR(RMALIENS_PORT) VALUE('3103');
CL: ADDENVVAR ENVVAR(RMALIENS_SF_MODE) VALUE('nodejs');
-- CL: CHGENVVAR ENVVAR(RMALIENS_SF_MODE) VALUE('direct');
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

-- You can also get and delete a specific person based on their Id
CALL CONTACT_CREATE('Richard', 'Moulton', '');
CALL CONTACT_GET('003WU000003LM5RYAW', '');
CALL CONTACT_DELETE('003WU000003LM5RYAW', '');
STOP;

-- Now let's download all contact rows from the Salesforce
--   to a local DB2 for i table
DELETE FROM CONTACT;
CALL CONTACT_DOWNLOAD();
-- CALL CONTACT_UPLOAD();
SELECT * FROM CONTACT ORDER BY FIRSTNAME, LASTNAME ;
STOP;
