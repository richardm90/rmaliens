import * as dotenv from 'dotenv';
dotenv.config({ path: `.env.${process.env.NODE_ENV}`, debug: true });

const server = process.env.DB_SERVER;
const database = process.env.DB_DATABASE;
const port = parseInt(process.env.DB_PORT);
const user = process.env.DB_USER;
const password = process.env.DB_PASSWORD;

export const config = {
    server,
    port,
    database,
    user,
    password,
    options: {
        encrypt: true,
        trustServerCertificate: true,
    }
};