import express from 'express';
import * as dotenv from 'dotenv';

// Import App routes
import buckets from './bucket.js';
import objects from './object.js';
import openapi from './openapi.js';

dotenv.config({ path: `.env.${process.env.NODE_ENV}`, debug: true });

console.log(`NODE_ENV=${process.env.NODE_ENV}`);
console.log(`AWS_REGION=${process.env.AWS_REGION}`);
console.log(`AWS_ACCESS_KEY_ID=${process.env.AWS_ACCESS_KEY_ID}`);
console.log(`AWS_SECRET_ACCESS_KEY=${process.env.AWS_SECRET_ACCESS_KEY}`);

const port = process.env.PORT || 3102;

const app = express();

// Development only - don't do in production
// Run this to create the table in the database
// if (process.env.NODE_ENV === 'development') {}

// Connect App routes
app.use('/api-docs', openapi);
app.use('/buckets', buckets);
app.use('/objects', objects);
app.use('*', (_, res) => {
  res.redirect('/api-docs');
});

// Start the server
app.listen(port, () => {
  console.log(`Server started on port ${port}`);
});
