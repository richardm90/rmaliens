import {
  S3Client,
  ListBucketsCommand,
  ListObjectsV2Command,
  PutObjectCommand,
  // CreateBucketCommand,
  // DeleteObjectCommand,
  // DeleteBucketCommand,
  // paginateListObjectsV2,
  // GetObjectCommand,

} from "@aws-sdk/client-s3";

export default class AWSS3 {
  config = {};
  client = null;

  constructor(config) {
    this.config = config;
    this.client = new S3Client(this.config);
  }

  async listBuckets() {
    const command = new ListBucketsCommand({});

    const { Owner, Buckets } = await this.client.send(command);
    console.log(
      `${Owner.DisplayName} owns ${Buckets.length} bucket${
        Buckets.length === 1 ? "" : "s"
      }:`,
    );

    return Buckets;
  }

  async listObjects(bucket, prefix) {
    const command = new ListObjectsV2Command({
      Bucket: bucket,
      Prefix: prefix,
      MaxKeys: 100,
    });

    let contents = [];
    let isTruncated = true;
  
    while (isTruncated) {
      const { Contents, IsTruncated, NextContinuationToken } =
        await this.client.send(command);
      
      if (Contents) {
        contents = contents.concat(Contents);
      }
      isTruncated = IsTruncated;
      command.input.ContinuationToken = NextContinuationToken;
    }

    return contents;
  }

  async putObject(bucket, key, body) {
    const command = new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      Body: body,
      Metadata: {
        GBS_Name: "test.pdf"
      }
    });
  
    const response = await this.client.send(command);
    
    return response;
  }
}