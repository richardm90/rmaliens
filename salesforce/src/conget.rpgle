**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('HTTPAPI') main(main);

/include qrpglesrc,httpapi_h
/include contact_d

dcl-proc main;
  dcl-pi *n extpgm('CONGET');
    id      like(SF_ID_t) const;
    result  like(SF_BUFFER_t) ccsid(1208) options(*nopass);
  end-pi;

  dcl-s url varchar(1024);
  dcl-s res like(SF_BUFFER_t) ccsid(1208);

  url = sf_inz(id);

  // Get the contact
  // TODO: is this going to return all fields?
  res = web_req('GET': url);

  // Return the response
  if %passed(result);
    result = res;
  endif;

  return;
end-proc;

/include contact_p
