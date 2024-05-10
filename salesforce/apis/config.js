import * as dotenv from 'dotenv';

dotenv.config({ path: `.env.${process.env.NODE_ENV}` });

const port = parseInt(process.env.PORT);
const loginUrl = process.env.SF_LOGIN_URL;
const username = process.env.SF_USERNAME;
const password = process.env.SF_PASSWORD;

export const config = {
    port,
    loginUrl,
    username,
    password,
};