import sql from 'mssql';
import { fakerDE as faker } from '@faker-js/faker';

export default class Database {
  config = {};
  pool = null;
  connected = false;

  constructor(config) {
    this.config = config;
    console.log(`Database: config: ${JSON.stringify(config)}`);
  }

  async connect() {
    try {
      console.log(`Database connecting...${this.connected}`);
      if (this.connected === false) {
        this.pool = await sql.connect(this.config);
        this.connected = true;
        console.log('Database connection successful');
      } else {
        console.log('Database already connected');
      }
    } catch (error) {
      console.error(`Error connecting to database: ${JSON.stringify(error)}`);
    }
  }

  async disconnect() {
    try {
      this.pool.close();
      console.log('Database connection closed');
    } catch (error) {
      console.error(`Error closing database connection: ${error}`);
    }
  }

  async executeQuery(query) {
    await this.connect();
    const request = this.pool.request();
    const result = await request.query(query);

    return result.rowsAffected[0];
  }

  async create(data) {
    await this.connect();
    const request = this.pool.request();

    request.input('firstName', sql.NVarChar(255), data.firstName);
    request.input('lastName', sql.NVarChar(255), data.lastName);

    const result = await request.query(
      `INSERT INTO Person (firstName, lastName) VALUES (@firstName, @lastName)`
    );

    return result.rowsAffected[0];
  }

  async faker(opts) {
    let count = opts.count || 1;

    await this.connect();

    const table = new sql.Table('Person');
    table.columns.add('firstName', sql.NVarChar(255), {nullable: true});
    table.columns.add('lastName', sql.NVarChar(255), {nullable: true});
    for (let i = 0; i < count; i++) {
      table.rows.add(faker.person.firstName(), faker.person.lastName());
    }

    const request = new sql.Request(this.pool);
    const result = await request.bulk(table);

    return result;
  }

  async readAll() {
    await this.connect();
    const request = this.pool.request();
    const result = await request.query(`SELECT * FROM Person`);

    return result.recordsets[0];
  }

  async read(id) {
    await this.connect();

    const request = this.pool.request();
    const result = await request
      .input('id', sql.Int, +id)
      .query(`SELECT * FROM Person WHERE id = @id`);

    return result.recordset[0];
  }

  async update(id, data) {
    await this.connect();

    const request = this.pool.request();

    request.input('id', sql.Int, +id);
    request.input('firstName', sql.NVarChar(255), data.firstName);
    request.input('lastName', sql.NVarChar(255), data.lastName);

    const result = await request.query(
      `UPDATE Person SET firstName=@firstName, lastName=@lastName WHERE id = @id`
    );

    return result.rowsAffected[0];
  }

  async delete(id) {
    await this.connect();

    let result = null;

    const request = this.pool.request();

    if (id) {
      const idAsNumber = Number(id);

      result = await request
        .input('id', sql.Int, idAsNumber)
        .query(`DELETE FROM Person WHERE id = @id`);

    } else {
      result = await request
        .query(`DELETE FROM Person`);
    }

    return result.rowsAffected[0];
  }
}