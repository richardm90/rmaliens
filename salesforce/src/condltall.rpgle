**FREE

ctl-opt dftactgrp(*no) actgrp(*new) debug(*yes) bnddir('HTTPAPI') main(main);

/include qrpglesrc,httpapi_h
/include contact_d

dcl-ds contact_ids_t qualified;
  totalSize       int(10);
  num_records     int(10);
  dcl-ds records  dim(200);
    Id            like(SF_ID_t);
  end-ds;
end-ds;

dcl-proc main;
  dcl-pi *n extpgm('CONDLTALL') end-pi;

  dcl-ds ids likeds(contact_ids_t) inz(*likeds);
  dcl-s url varchar(1024);
  dcl-s res like(SF_BUFFER_t) ccsid(1208);
  dcl-s query like(SF_QUERY_t);
  dcl-s all_contacts_deleted ind;
  dcl-s index int(5);

  sf_inz();

  dow not all_contacts_deleted;
    query = 'SELECT Id FROM Contact WHERE Department = ''RMALIENS'' LIMIT 200';
    url = sf_url(*omit: query);
    res = web_req('GET': url);

    ids = get_contact_ids(res);
    if ids.totalSize = 0;
      all_contacts_deleted = *on;
      leave;
    endif;

    for index = 1 to ids.totalSize;
      url = sf_url(ids.records(index).id);
      res = web_req('DELETE': url);
    endfor;
  enddo;

  return;
end-proc;

dcl-proc get_contact_ids;
  dcl-pi *n likeds(contact_ids_t);
    res like(SF_BUFFER_t) ccsid(1208) const;
  end-pi;

  dcl-ds contact_ids likeds(contact_ids_t) inz(*likeds);

  data-into contact_ids
    %data(res : 'case=any allowextra=yes countprefix=num_')
    %parser('YAJLINTO');

  return contact_ids;
end-proc;

/include contact_p
