import * as dotenv from 'dotenv';

dotenv.config({ path: `.env.${process.env.NODE_ENV}` });

const port = parseInt(process.env.PORT);
const googleDocId = process.env.GOOGLE_DOC_ID;
const googleSheetTitle = process.env.GOOGLE_SHEET_TITLE;
const googleServiceAccountEmail = process.env.GOOGLE_SERVICE_ACCOUNT_EMAIL;
const googlePrivateKey = process.env.GOOGLE_PRIVATE_KEY.replace(/\\n/g, '\n');

export const config = {
    port,
    googleDocId,
    googleSheetTitle,
    googleServiceAccountEmail,
    googlePrivateKey,
};