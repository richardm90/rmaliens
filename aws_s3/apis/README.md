https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/getting-started-nodejs.html
npm init -y
npm i @aws-sdk/client-s3

NODE_ENV=development node index.js

To run the application via `nodemon` use `npm run dev`.



https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/javascript_s3_code_examples.html

* [Controlling access to a bucket with user policies](https://docs.aws.amazon.com/AmazonS3/latest/userguide/walkthrough1.html#walkthrough-group-policy)
* [AWS S3Client Reference](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/client/s3/)
* [Actions, resources, and condition keys for Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/list_amazons3.html) - This page provides a list of actions and the resources and conditions that can be used with those actions.
* [S3 Bucket policy examples](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html)
* [Policies and Permissions in Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-policy-language-overview.html)

```shell
# .env.development
AWS_ACCESS_KEY_ID=<access_key_id>
AWS_SECRET_ACCESS_KEY=<secret_access_key>
AWS_REGION=eu-west-2
```

## TODO:

* `bucket` should not be part of the request but a pre-configured value loaded
as an environment variable
