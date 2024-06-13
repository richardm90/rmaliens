import express from 'express';
import { config } from './config.js';
import Database from './database.js';

const router = express.Router();
router.use(express.json());

// Development only - don't do in production
console.log(config);

// Create database object
const database = new Database(config);

router.get('/', async (_, res) => {
  try {
    // Return a list of persons
    const persons = await database.readAll();
    res.status(200).json(persons);
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.post('/', async (req, res) => {
  try {
    // Create a person
    const person = req.body;
    const rowsAffected = await database.create(person);
    res.status(201).json({ rowsAffected });
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.post('/faker', async (req, res) => {
  try {
    // Create one or more fake contacts
    const opts = req.body;
    const result = await database.faker(opts);
    res.status(201).json({ result });
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.delete('/', async (_, res) => {
  try {
    const rowsAffected = await database.delete();
    res.status(204).json({ rowsAffected });
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    // Get the person with the specified ID
    const personId = req.params.id;
    if (personId) {
      const result = await database.read(personId);
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
    // Update the person with the specified ID
    const personId = req.params.id;
    const person = req.body;

    if (personId && person) {
      delete person.id;
      const rowsAffected = await database.update(personId, person);
      res.status(200).json({ rowsAffected });
    } else {
      res.status(404);
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    // Delete the person with the specified ID
    const personId = req.params.id;

    if (!personId) {
      res.status(404);
    } else {
      const rowsAffected = await database.delete(personId);
      res.status(204).json({ rowsAffected });
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

export default router;