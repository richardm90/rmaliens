import express from 'express';
import multer from 'multer';
import { config } from './config.js';
import AWSS3 from './AWSS3.js';

const router = express.Router();
router.use(express.json());

// Configure Multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// Development only - don't do in production
if (process.env.NODE_ENV === 'development') {
  console.log(config);
}

// Create AWS S3 object
const awss3 = new AWSS3(config);

// Get a list of objects
router.get('/', async (req, res) => {
  try {
    const bucket = req.query.bucket;
    const prefix = req.query.prefix;

    const objects = await awss3.listObjects(bucket, prefix);
    console.log(`objects: ${JSON.stringify(objects)}`);
    res.status(200).json(objects);
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

// Create an object
router.post('/', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      res.status(400).send('No file provided.');
    }
  
    const bucket = req.query.bucket;
    const key = req.query.key;
    const body = req.file.buffer;

    const response = await awss3.putObject(bucket, key, body);
    console.log(`response: ${JSON.stringify(response)}`);
    res.status(200).json(response);
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

export default router;