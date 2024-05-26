**free

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) main(main);
ctl-opt bnddir('HTTPAPI');
ctl-opt bnddir('YAJL');

/include qrpglesrc,httpapi_h
/include qrpglesrc,yajl_h
/include './contact_d.rpgleinc'

dcl-proc main;
  dcl-pi *n extpgm('CONDOWN') end-pi;

  dcl-s contacts_l like(SF_BUFFER_t) ccsid(1208);
  dcl-s contacts like(SF_BUFFER_t);
  dcl-ds contact likeds(CONTACT_t) inz(*likeds);

  // YAJL fields
  dcl-s errmsg  varchar(500);
  dcl-s root    like(YAJL_val);
  dcl-s records like(YAJL_val);
  dcl-s node    like(YAJL_val);
  dcl-s index   int(10);

  exec sql
    set option commit = *none,
           datfmt = *iso,
           datsep = '-',
           timfmt = *iso,
           closqlcsr= *endactgrp,
           naming = *sys;

  CONGETALL(contacts_l);
  contacts = contacts_l;
  
  root = YAJL_string_load_tree(contacts: errmsg);

  // Loop through contacts
  records = YAJL_object_find(root: 'records');
  if records <> *null;
    index = 0;
    dow YAJL_array_loop(records: index: node);
      reset contact;
      contact.id        = YAJL_get_string(YAJL_object_find(node: 'Id'));
      contact.firstName = YAJL_get_string(YAJL_object_find(node: 'FirstName'));
      contact.lastName  = YAJL_get_string(YAJL_object_find(node: 'LastName'));
    
      ibmi_save_contact(contact);
    enddo;
  endif;

  YAJL_tree_free(root);

  return;
end-proc;

dcl-proc ibmi_save_contact;
  dcl-pi *n;
    contact likeds(CONTACT_t) const;
  end-pi;

  exec sql
    INSERT INTO CONTACT
      (ID , FIRSTNAME, LASTNAME)
      VALUES(:contact.id, :contact.firstName, :contact.lastName);

end-proc;
