import express from 'express';
import { config } from './config.js';
import Salesforce from './salesforce.js';

const router = express.Router();
router.use(express.json());

// Development only - don't do in production
console.log(config);

// Create Salesforce object
const salesforce = new Salesforce(config);

router.get('/', async (_, res) => {
  try {
    // Return a list of contacts
    const contacts = await salesforce.readAll();
    res.status(200).json(contacts);
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.post('/', async (req, res) => {
  try {
    // Create a contact
    const contact = req.body;
    const result = await salesforce.create(contact);
    res.status(201).json({ result });
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.delete('/', async (_, res) => {
  try {
    const result = await salesforce.delete();
    res.status(204).json({ result });
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.post('/faker', async (req, res) => {
    try {
      // Create one or more fake contacts
      const opts = req.body;
      const result = await salesforce.faker(opts);
      res.status(201).json({ result });
    } catch (err) {
      res.status(500).json({ error: err?.message });
    }
  });
  
router.get('/:id', async (req, res) => {
  try {
    // Get the contact with the specified ID
    const contactId = req.params.id;
    if (contactId) {
      const result = await salesforce.read(contactId);
      res.status(200).json(result);
    } else {
      res.status(404);
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
    // Update the contact with the specified ID
    const contactId = req.params.id;
    const contact = req.body;

    if (contactId && contact) {
      const result = await salesforce.update(contactId, contact);
      res.status(200).json({ result });
    } else {
      res.status(404);
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    // Delete the contact with the specified ID
    const contactId = req.params.id;

    if (!contactId) {
      res.status(404);
    } else {
      const result = await salesforce.delete(contactId);
      res.status(204).json({ result });
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

export default router;