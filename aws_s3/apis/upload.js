import express from 'express';
import multer from 'multer';
import {S3Client, PutObjectCommand} from "@aws-sdk/client-s3";
import * as dotenv from 'dotenv';

dotenv.config({ path: `.env.${process.env.NODE_ENV}`, debug: true });

const app = express();
const port = 3102;

// Configure Multer for file uploads
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

const s3Client = new S3Client({
    region: process.env.AWS_REGION,
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    },
});
// Endpoint to handle file upload and save to S3
app.post('/objects', upload.single('file'), async (req, res) => {
    console.log('got here');

    if (!req.file) {
      return res.status(400).send('No file uploaded.');
    }

    // Save the file to S3
    const uploadParams = {
        Bucket: 'gbportal-dev',
        Key: `uploads/${Date.now()}_${req.file.originalname}`,
        Body: req.file.buffer,
    };

    try {
        const command = new PutObjectCommand(uploadParams);
        await s3Client.send(command);
        console.log('success');
        return res.status(200).send('File uploaded to S3 successfully.');
    } catch (error) {
        console.error('Error uploading to S3:', error);
        return res.status(500).send('Internal Server Error');
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});