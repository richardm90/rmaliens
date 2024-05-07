import express from 'express';
import { config } from './config.js';
import AWSS3 from './AWSS3.js';

const router = express.Router();
router.use(express.json());

// Development only - don't do in production
if (process.env.NODE_ENV === 'development') {
  console.log(config);
}

// Create database object
const awss3 = new AWSS3(config);

// Return a list of buckets
router.get('/', async (_, res) => {
  try {
    const buckets = await awss3.listBuckets();
    console.log(`buckets: ${JSON.stringify(buckets)}`);
    res.status(200).json(buckets);
  } catch (err) {
    res.status(500).json({ error: err?.message });
  }
});

export default router;