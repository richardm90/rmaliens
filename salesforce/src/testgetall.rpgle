**FREE

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) main(main);
ctl-opt bnddir('ILEVATOR');
ctl-opt bnddir('NOXDB');

/include qrpgleref,noxdb
/include qrpgleref,ilevator
/include person_d

dcl-proc main;
    dcl-pi *n extpgm('PERDLTALL') end-pi;

    dcl-s people varchar(IV_BUFFER_SIZE:4) ccsid(1208);
    dcl-s person_id int(10);
    dcl-s document pointer;
    dcl-ds list likeds(JSON_ITERATOR);
    dcl-s base_url varchar(1024);

    base_url = get_base_url();

    // Get all people, from the Cloud MS SQL DB
    // - the 'people' variable is set in PERGETALL and contains a JSON string
    //   of the response from the HTTP GET Web API
    PERGETALL(people);
    
    // Parse the JSON string using noxDB
    // - we need to tell noxDB the CCSID of our JSON string
    document = json_ParseStringCcsid(%addr(people: *data): 1208);

    // Loop through JSON array
    list = json_SetIterator(document);
    dow json_ForEach(list);
        // We only need the Id to delete a person
        person_id = json_GetInt(list.this: 'id');

        // Now the delete the Cloud DB person
        iv_delete(base_url + '/persons/' + %char(person_id));
    enddo;

    return;
end-proc;

/include person_p
