**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('ILEVATOR') main(main);

/include qrpgleref,ilevator
/include contact_d

dcl-proc main;
  dcl-pi *n extpgm('CONCRTA');
    firstName varchar(255) ccsid(1208) const;
    lastName varchar(255) ccsid(1208) const;
    result varchar(IV_BUFFER_SIZE:4) ccsid(1208) options(*nopass);
  end-pi;

  dcl-s req varchar(IV_BUFFER_SIZE:4) ccsid(1208);
  dcl-s res varchar(IV_BUFFER_SIZE:4) ccsid(1208);
  dcl-s base_url varchar(1024);

  base_url = get_base_url();

  // Build the request JSON body
  req = '{"firstName": "' + firstName + '","lastName": "' + lastName + '"}';
  
  // Create the contact
  res = iv_post(base_url + '/contacts' : req : 'application/json');

  // Return the response
  if %passed(result);
    result = res;
  endif;

  return;
end-proc;

/include contact_p
