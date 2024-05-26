**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) main(main);
ctl-opt bnddir('HTTPAPI');
ctl-opt bnddir('YAJL');

/include qrpglesrc,httpapi_h
/include qrpglesrc,yajl_h
/include './contact_d.rpgleinc'

dcl-proc main;
  dcl-pi *n extpgm('UPLOAD') end-pi;

  dcl-s num_rows uns(10);
  dcl-ds contacts likeds(CONTACT_t) dim(999);
  dcl-s index uns(5);

  exec sql
      set option commit = *none,
                  datfmt = *iso,
                  datsep = '-',
                  timfmt = *iso,
                  closqlcsr= *endactgrp,
                  naming = *sys;

  ibmi_get_all_contacts(contacts: num_rows);

  // Loop through contacts
  for index = 1 to num_rows;
    CONCRT(contacts(index).firstName: contacts(index).lastName);
  endfor;

  return;
end-proc;

dcl-proc ibmi_get_all_contacts;
  dcl-pi *n;
    contact likeds(CONTACT_t) dim(999);
    got_rows uns(10);
  end-pi;

  dcl-s page_size  int(10);
  dcl-s row_offset int(10);
  dcl-s total_rows uns(10);
  dcl-s statement  varchar(1024);

  statement =
    'SELECT ' +
      'ID , ' +
      'FIRSTNAME , ' +
      'LASTNAME ' +
    'FROM ' +
      'CONTACT ' +
    'ORDER BY ' +
      'ID ' +
    'FOR READ ONLY';

  exec sql
    PREPARE get_all_statement FROM :statement;

  exec SQL
    DECLARE get_all_cursor INSENSITIVE SCROLL CURSOR FOR get_all_statement;

  exec SQL
    open get_all_cursor;

  exec SQL
    get diagnostics :total_rows = DB2_NUMBER_ROWS;

  row_offset = 1;
  page_size = %elem(contact);

  exec SQL
    fetch relative :row_offset from get_all_cursor
      for :page_size rows into :contact;

  got_rows = SQLERRD(3);

  exec SQL
    close get_all_cursor;

  return;
end-proc;
