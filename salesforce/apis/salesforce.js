import jsforce  from 'jsforce';
import { fakerDE as faker } from '@faker-js/faker';

export default class Salesforce {
  config = {};
  conn = null;
  connected = false;

  constructor(config) {
    this.config = config;
    console.log(`Salesforce config: ${JSON.stringify(config)}`);
  }

  async connect() {
    try {
      console.log(`Connecting to Salesforce...${this.connected}`);
      if (this.connected === false) {
        this.conn = new jsforce.Connection({ loginUrl: this.config.url });
        await this.conn.login(this.config.username, this.config.password);
        this.connected = true;		
        console.log('Connected to Salesforce');
      } else {
        console.log('Already connected to Salesforce');
      }
    } catch (error) {
      console.error(`Error connecting to Salesforce: ${JSON.stringify(error)}`);
    }
  }

  async disconnect() {
    try {
      await this.conn.logout();
      this.connected = false;
      console.log('Closed connection to Salesforce');
      return;
    } catch (error) {
      console.error(`Error closing Salesforce connection: ${error}`);
    }
  }

  async create(data) {
    await this.connect();

    const result = await this.conn.sobject('Contact').create(data);

    await this.disconnect();

    return result;
  }

  async faker(opts) {
    let count = opts.count || 1;
    let result = [];

    for (let i = 0; i < count; i++) {  
      const data = {
        FirstName: faker.person.firstName(),
        LastName: faker.person.firstName(),
        Email: faker.internet.email(),
        Title:  faker.person.jobTitle(),
        MailingStreet: faker.location.street(),
        MailingCity: faker.location.state(),
        MailingPostalCode: faker.location.zipCode(),
        Phone: faker.phone.number(),
        HomePhone: faker.phone.number(),
        Department: "RMALIENS",
      }

      const contact = await this.create(data);

      result.push(contact);
    }

    return result;
  }

  async readAll(query) {
    await this.connect();

    // Execute the SOQL query to retrieve all Contact records
    const result = await this.conn.query(query);

    await this.disconnect();

    return result;
  }

  async read(id) {
    await this.connect();

    const result = await this.conn.sobject('Contact').retrieve(id);

    await this.disconnect();

    return result;
  }

  async update(id, data) {
    await this.connect();

    const contact = {
      Id: id,
      ...data
    }

    const result = await this.conn.sobject('Contact').update(contact);

    await this.disconnect();

    return result;
  }

  async delete(id) {
    let result;
    await this.connect();

    if (id) {
      result = await this.conn.sobject('Contact').destroy(id);
    }
    else
    {
      let allContactsDeleted = false;
      let totalCount = 0;
      let lastId = '';
  
      while (!allContactsDeleted) {
        // Query for up to 200 Contact records
        const query = `SELECT Id FROM Contact WHERE Id > '${lastId}' ORDER BY Id LIMIT 200`;
        const contacts = await this.conn.query(query);

        if (contacts.totalSize === 0) {
          allContactsDeleted = true;
          console.log('All contacts deleted successfully.');
          break;
        }

        // Not all contacts may get deleted so we need to keep track
        // of the last id that was read
        lastId = contacts.records[contacts.totalSize-1].Id;
  
        const contactIds = contacts.records.map(contact => contact.Id);
        const deleteResults = await this.conn.sobject('Contact').destroy(contactIds);
  
        totalCount += deleteResults.length;
        console.log(`Batch deleted ${deleteResults.length} contacts. Total deleted: ${totalCount}`);
      }
    }
    
    await this.disconnect();

    return result;
  }
}