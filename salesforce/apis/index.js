import express from 'express';

// Import App routes
import contact from './contact.js';
import openapi from './openapi.js';

const port = process.env.PORT || 3103;

const app = express();

// Connect App routes
app.use('/api-docs', openapi);
app.use('/contacts', contact);
app.use('*', (_, res) => {
  res.redirect('/api-docs');
});

// Start the server
app.listen(port, () => {
  console.log(`Server started on port ${port}`);
});
