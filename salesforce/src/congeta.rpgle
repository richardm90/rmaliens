**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('ILEVATOR') main(main);

/include qrpgleref,ilevator
/include contact_d

dcl-proc main;
  dcl-pi *n extpgm('CONGETA');
    id like(SF_ID_t) const;
    result varchar(IV_BUFFER_SIZE:4) ccsid(1208) options(*nopass);
  end-pi;

  dcl-s res varchar(IV_BUFFER_SIZE:4) ccsid(1208);
  dcl-s base_url varchar(1024);

  base_url = get_base_url();

  // Create the contact
  res = iv_get(base_url + '/contacts/' + id : 'application/json');

  // Output the response to the joblog
  iv_joblog(res);

  // Return the response
  if %passed(result);
    result = res;
  endif;

  return;
end-proc;

/include contact_p
