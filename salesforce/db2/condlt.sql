CREATE OR REPLACE PROCEDURE CONTACT_DELETE (
  IN ID VARCHAR(18) ,
  OUT RESULT CLOB(1M) CCSID 1208
)
LANGUAGE RPGLE
PARAMETER STYLE SQL
DETERMINISTIC
MODIFIES SQL DATA
CALLED ON NULL INPUT
PROGRAM TYPE MAIN
EXTERNAL NAME CONDLT
SPECIFIC CONDLT;