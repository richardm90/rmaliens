**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('HTTPAPI') main(main);

/include qrpglesrc,httpapi_h
/include contact_d

dcl-proc main;
  dcl-pi *n extpgm('CONGETB');
    id      like(SF_ID_t) const;
    result  like(SF_BUFFER_t) ccsid(1208) options(*nopass);
  end-pi;

  dcl-ds login likeds(SF_LOGIN_t) inz(*likeds);
  dcl-s res like(SF_BUFFER_t) ccsid(1208);

  login = sf_login();
 
  // Set bearer token
  http_setauth(HTTP_AUTH_BEARER: '': login.access_token);

  // Create the contact
  res = web_req('DELETE': login.instance_url + SF_CONTACT_PATH + '/' + id);

  // Return the response
  if %passed(result);
    result = res;
  endif;

  return;
end-proc;

/define INCLUDE_HTTPAPI_STUFF
/include contact_p
