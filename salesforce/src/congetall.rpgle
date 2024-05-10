**FREE

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('HTTPAPI') main(main);

/include qrpglesrc,httpapi_h
/include contact_d

dcl-proc main;
  dcl-pi *n extpgm('CONGETALL');
    result  like(SF_BUFFER_t) ccsid(1208) options(*nopass);
  end-pi;

  dcl-s url varchar(1024);
  dcl-s res like(SF_BUFFER_t) ccsid(1208);
  dcl-s res like(SF_QUERY_t);

  query = 'SELECT Id, FirstName, LastName ' +
          'FROM Contact ' +
          'WHERE Department = ''RMALIENS''';

  url = sf_inz(id: query);

  // Get the contacts
  res = web_req('GET': url);

  // Return the response
  if %passed(result);
    result = res;
  endif;

  return;
end-proc;

/include contact_p
