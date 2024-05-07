import { GoogleSpreadsheet } from 'google-spreadsheet';
import { JWT } from 'google-auth-library';

export default class Spreadsheet {

  async #getRow(rowNumber) {
    // Note that the header row is always skipped so the offset starts from
    // the second row, if you want row 8 the offset needs to be 6
    const offset = parseInt(rowNumber) - 2;
    const limit = 1;
    const rows = await this.sheet.getRows({ offset, limit });

    return rows[0];
  }

  #formatRow(row) {

    const formattedRow = {
      "id": row.rowNumber,
      "firstName": row.get('firstName'),
      "lastName": row.get('lastName'),
    }

    return formattedRow;
  }

  async #openDocument(docId) {
    const auth = new JWT({
      email: this.config.googleServiceAccountEmail,
      key: this.config.googlePrivateKey,
      scopes: [
            'https://www.googleapis.com/auth/spreadsheets',
            'https://www.googleapis.com/auth/drive.file',
          ],
    });
    
    const doc = new GoogleSpreadsheet(docId, auth);
    await doc.loadInfo();

    return doc;
  }

  async #openSheet(sheetTitle) {
    const sheet = this.doc.sheetsByTitle[sheetTitle];

    return sheet;
  }

  constructor(config) {
    this.config = config;
    this.connected = false;
  }

  async connect() {
    try {
      if (this.connected === false) {
        this.doc = await this.#openDocument(this.config.googleDocId);
        this.sheet = await this.#openSheet(this.config.googleSheetTitle);
        this.connected = true;
        console.log(`Spreadsheet connection successful: Title=${this.doc.title}, Sheet=${this.sheet.title}`);
      } else {
        console.log('Spreadsheet already connected');
      }
    } catch (error) {
      console.error(`Error connecting to spreadsheet: ${JSON.stringify(error)}`);
    }
  }

  async create(data) {
    await this.connect();
    const row = await this.sheet.addRow(data);

    const result = this.#formatRow(row);

    return result;
  }

  async readAll() {
    await this.connect();
    const rows = await this.sheet.getRows();

    const result = [];
    for (const i in rows) {
        const row = this.#formatRow(rows[i]);
        result.push(row);
    }

    return result;
  }

  async read(rowNumber) {
    await this.connect();

    const row = await this.#getRow(rowNumber);

    const result = this.#formatRow(row);

    return result;
  }

  async update(rowNumber, data) {
    await this.connect();

    const row = await this.#getRow(rowNumber);
    row.assign(data);
    await row.save();

    const result = this.#formatRow(row);

    return result;
  }

  async delete(rowNumber) {
    await this.connect();

    let result = null;

    if (rowNumber) {
      const row = await this.#getRow(rowNumber);
      await row.delete();
      result = this.#formatRow(row);
    } else {
      // Note the index starts at 2 to skip header row
      for (let i = 2; i < this.sheet.rowCount; i++) {
        const row = await this.#getRow(2);
        if (row) {
          await row.delete();
        } else {
          break;
        }
      }
    }

    return result;
  }
}