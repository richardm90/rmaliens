CREATE OR REPLACE PROCEDURE  CONTACT_DELETEALL ()
LANGUAGE RPGLE
PARAMETER STYLE SQL
DETERMINISTIC
MODIFIES SQL DATA
CALLED ON NULL INPUT
PROGRAM TYPE MAIN
EXTERNAL NAME  CONDLTALL
SPECIFIC CONDLTALL;
