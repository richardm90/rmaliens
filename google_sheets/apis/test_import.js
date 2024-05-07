// import {default as data} from "./config/rmaliens-eaa97d3631e7.json" assert{type: "json"};;
// console.log(data); //<-- it will print the content of your json file

import * as fs from 'fs';
let data = JSON.parse(fs.readFileSync('./config/rmaliens-eaa97d3631e7.json', 'utf-8'));
console.log(data); //<-- it will print the content of your json file
