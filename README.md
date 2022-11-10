# Problem statement

The application solution requires to retrieve data from a remote API weather.
Save the data to AWS DynamoDB, then get response the data from web interface.

# Solutioning approach

- Register on the weather site with API
- DynamoDB - storing all weather data
- S3 bucket - frontend data storage (HTML,JS)
- Cloudfront - serving static HTML,JS files for working with Lambda 
- Lambda_1 - responding to static site's request and interacting with DynamoDB
- Use script to retrieve data from remote site and redirect data to DynamoDB, extract data
- Use Amazon EventBridge for creating cron job to update a lambda_2 query
- Deploy Lambda function_2 that udate API key


# Pre-requirements

- Activated AWS account

## Register on the site

Register on openweathermap.org, get API Key. 
After receiving the key check access. The query link should be something like this:
 - http://api.openweathermap.org/data/2.5/find?q=Minsk&type=like&APPID=API_key
 - http://api.openweathermap.org/data/2.5/weather?q=Minsk&type=like&APPID=API_key


## Create DynamoDB table 
  
  - Create DynamoDB table name: weather
  - Partition key name: city
  - Sort key name: time


## S3 bucket and CloudFront

- Create S3 bucket,deny public access to S3
- Deploy CloudFront :
        - Origin path: leave blank
        - Add "Origin Access Identity" to allow Cloudfront to read bucket contents
        - Update the bucket policy
        - Protocol policy: Redirect HTTP to HTTPS
        - Allowed HTTP methods: GET, HEAD
-  Modify HTML file: Functionality - gets json request in a following format:
  - {
     "City":"$CITY",
      "Date":"$DATE",
       "TempFormat":"$TEMPFORMAT"
    }
- upload file to s3 bucket: scripts/weather.html
- verify access: $CLOUDFRONT_DOMAIN_NAME/weather.html

 
## Deploy Lambda function

- Deploy Lambda function
- Create IAM role for lambda
- Attach next policies to role: "Allow create Events in Cloudwatch Events", "Allow create Logs in Cloudwatch", "AmazonDynamoDBFullAccess"
- Add Function URL:
      - Auth type: NONE
      - Configure CORS:
      - Allow origin: *
      - Allow methods: *
      - Allow headers: content-type
                - Allow credentials: false
- example IaC to deploy lambda: lambda.tf

## Create script to retrieve data 

 - Ready template: scripts/weather.py
 - Modify the script: 
      - Should check for "time" data existence in DynamoDB, write if not existent or outdated, else return data
 ## Verification: $CLOUDFRONT_DOMAIN_NAME/weather.html
- Get extract data from DynamoDB

## *Deploy lambda_2 function 
- Deploy lambda_2
- Add permissions to Lambda "AllowExecutionFromCloudWatch"
- Write code to execute lambda query for update

## Cron job 

- Set Cron job in Amazon EventBridge, to update a lambda query once a month
