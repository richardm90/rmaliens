**FREE

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) main(main);
ctl-opt bnddir('ILEVATOR');
ctl-opt bnddir('NOXDB');

/include qrpgleref,noxdb
/include qrpgleref,ilevator
/include person_d

dcl-proc main;
    dcl-pi *n extpgm('DOWNLOAD') end-pi;

    dcl-s people_l varchar(IV_BUFFER_SIZE:4) ccsid(1208);
    dcl-s people varchar(IV_BUFFER_SIZE:4);
    dcl-ds person likeds(PERSON_t) inz(*likeds);
    dcl-s res varchar(IV_BUFFER_SIZE:4) ccsid(1208);
    dcl-s document pointer;
    dcl-ds list likeds(JSON_ITERATOR);

    exec sql
        set option commit = *none,
                   datfmt = *iso,
                   datsep = '-',
                   timfmt = *iso,
                   closqlcsr= *endactgrp,
                   naming = *sys;

    // ibmi_delete_people();

    PERGETALL(people_l);
    people = people_l;
    
    // Loop through people
    document = json_ParseString(people);

    // Using an iterator
    list = json_SetIterator(document);
    dow json_ForEach(list);
        reset person;
        person.id = json_GetInt(list.this: 'id');
        person.firstName = json_GetStr(list.this: 'firstName');
        person.lastName = json_GetStr(list.this: 'lastName');
        
        ibmi_save_person(person);
    enddo;

    return;
end-proc;

dcl-proc ibmi_delete_people;
    dcl-pi *n end-pi;

    exec sql
        DELETE FROM PERSON;

end-proc;

dcl-proc ibmi_save_person;
    dcl-pi *n;
        person likeds(PERSON_t) const;
    end-pi;

    exec sql
        INSERT INTO PERSON
            (ID , FIRSTNAME, LASTNAME)
            VALUES(:person.id, :person.firstName, :person.lastName);

end-proc;
