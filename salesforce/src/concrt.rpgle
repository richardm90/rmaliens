**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('HTTPAPI') main(main);

/include qrpglesrc,httpapi_h
/include './contact_d.rpgleinc'

dcl-proc main;
  dcl-pi *n extpgm('CONCRT');
    firstName varchar(255)      ccsid(1208) const;
    lastName  varchar(255)      ccsid(1208) const;
    result    like(SF_BUFFER_t) ccsid(1208) options(*nopass);
  end-pi;

  dcl-s url varchar(1024);
  dcl-s req like(SF_BUFFER_t) ccsid(1208);
  dcl-s res like(SF_BUFFER_t) ccsid(1208);

  url = sf_inz();

  // Build the request JSON body
  // - Note that I'm forcing the department with a value of RMALIENS, this
  //   makes it easier to filter my contacts in the Salesforce UI
  req = '{"firstName": "' + firstName + '","lastName": "' + lastName + '","Department": "RMALIENS"}';
  
  // Create the contact
  res = web_req('POST': url: req);

  // Return the response
  if %passed(result);
    result = res;
  endif;

  return;
end-proc;

/include './contact_p.rpgleinc'
