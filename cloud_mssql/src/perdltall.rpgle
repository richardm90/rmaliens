**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) main(main);
ctl-opt bnddir('ILEVATOR');
ctl-opt bnddir('NOXDB');

/include qrpgleref,ilevator
/include person_d

dcl-proc main;
  dcl-pi *n extpgm('PERDLTALL') end-pi;

  dcl-s base_url varchar(1024);

  base_url = get_base_url();

  // Delete all person rows
  iv_delete(base_url + '/persons/');

  return;
end-proc;

/include person_p
