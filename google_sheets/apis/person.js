import express from 'express';
import { config } from './config.js';
import Spreadsheet from './spreadsheet.js';

const router = express.Router();
router.use(express.json());

// Create spreadsheet object
const spreadsheet = new Spreadsheet(config);

router.get('/', async (_, res) => {
  try {
    const rows = await spreadsheet.readAll();
    res.status(200).json(rows);
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const person = req.body;
    const row = await spreadsheet.create(person);
    res.status(201).json({rowsAffected: 1});
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.delete('/', async (req, res) => {
  try {
    const row = await spreadsheet.delete();
    res.status(204).json(row);
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const rowNumber = req.params.id;
    if (rowNumber) {
      const row = await spreadsheet.read(rowNumber);
      res.status(200).json(row);
    } else {
      res.status(404);
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
    const rowNumber = req.params.id;
    const person = req.body;

    if (rowNumber && person) {
      const row = await spreadsheet.update(rowNumber, person);
      res.status(200).json({rowsAffected: 1});
    } else {
      res.status(404);
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    const rowNumber = req.params.id;

    if (!rowNumber) {
      res.status(404);
    } else {
      const row = await spreadsheet.delete(rowNumber);
      res.status(204).json(row);
    }
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

export default router;