import { config } from './config.js';
import Spreadsheet from './spreadsheet.js';

// Create spreadsheet object
const spreadsheet = new Spreadsheet(config);

const persons = await spreadsheet.readAll();

// for (const i in persons) {
//     console.log(`#${i}: ${persons[i].get('ID')} ${persons[i].get('FirstName')} ${persons[i].get('LastName')}`);
// }

console.log(persons);

