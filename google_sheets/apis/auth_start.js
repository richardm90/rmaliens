import { GoogleSpreadsheet } from 'google-spreadsheet';
import { JWT } from 'google-auth-library';
import * as fs from 'fs';

let creds = JSON.parse(fs.readFileSync('./config/rmaliens-eaa97d3631e7.json', 'utf-8'));

const SCOPES = [
  'https://www.googleapis.com/auth/spreadsheets',
  'https://www.googleapis.com/auth/drive.file',
];

const jwt = new JWT({
  email: creds.client_email,
  key: creds.private_key,
  scopes: SCOPES,
});
const doc = new GoogleSpreadsheet('1FueeO8aONryRZPrLF5KVUV7_az5dhVCwJypOLGT5VMo', jwt);

await doc.loadInfo(); // loads document properties and worksheets
console.log(doc.title);
// await doc.updateProperties({ title: 'renamed doc' });

const sheet1 = doc.sheetsByIndex[0]; // or use `doc.sheetsById[id]` or `doc.sheetsByTitle[title]`
console.log(sheet1.title);
console.log(sheet1.rowCount);

const steveRow = await sheet1.addRow({ ID: 2, FirstName: 'Steve' , LastName: 'Austin' });

// read rows
const rows = await sheet1.getRows(); // can pass in { limit, offset }

// console.log(rows);

const xlsxBuffer = await doc.downloadAsXLSX();
fs.writeFileSync('./downloads/people.xlsx', Buffer.from(xlsxBuffer));
