**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('ILEVATOR') main(main);

/include qrpgleref,ilevator
/include './person_d.rpgleinc'

dcl-proc main;
  dcl-pi *n extpgm('PERGET');
    id int(10) const;
    result varchar(IV_BUFFER_SIZE:4) ccsid(1208) options(*nopass);
  end-pi;

  dcl-s res varchar(IV_BUFFER_SIZE:4) ccsid(1208);
  dcl-s base_url varchar(1024);

  base_url = get_base_url();

  // Create the person
  res = iv_get(base_url + '/persons/' + %char(id) : 'application/json');

  // Return the response
  if %passed(result);
    result = res;
  endif;

  return;
end-proc;

/include './person_p.rpgleinc'
