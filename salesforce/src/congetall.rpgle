**FREE

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('HTTPAPI') main(main);

/include qrpglesrc,httpapi_h
/include contact_d

dcl-ds contacts_t qualified;
  num_records     int(10);
  dcl-ds records  dim(50);
    Id            like(SF_ID_t);
    FirstName     like(SF_FIRSTNAME_t);
    LastName      like(SF_LASTNAME_t);
  end-ds;
end-ds;

dcl-proc main;
  dcl-pi *n extpgm('CONGETALL');
    result  like(SF_BUFFER_t) ccsid(1208) options(*nopass);
  end-pi;

  dcl-s url varchar(1024);
  dcl-s res like(SF_BUFFER_t) ccsid(1208);
  dcl-s query like(SF_QUERY_t);

  query = 'SELECT Id, FirstName, LastName ' +
          'FROM Contact ' +
          'WHERE Department = ''RMALIENS''';

  url = sf_inz(*omit: query);

  // Get the contacts
  res = web_req('GET': url);

  // Return the response
  if %passed(result);
    // result = res;
    result = format_response(res);
  endif;

  return;
end-proc;

dcl-proc format_response;
  dcl-pi *n like(SF_BUFFER_t);
    res like(SF_BUFFER_t) ccsid(1208) const;
  end-pi;

  dcl-ds contacts likeds(contacts_t) inz(*likeds);
  dcl-s res_out like(SF_BUFFER_t);

  data-into contacts
    %data(res : 'case=any allowextra=yes countprefix=num_')
    %parser('YAJLINTO');

  data-gen contacts
    %data(res_out : 'countprefix=num_')
    %gen('YAJLDTAGEN');

  return res_out;
end-proc;

/include contact_p
