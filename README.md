# PagerDuty Demo Environment Setup Guide


# Prereq

* Access to AWS S3 Bucket to host the "phone shop" website
* Pagerduty instance 
* Global event rule key


## Setting up the Phone Shop

1. Clone the demo app folder in this github repo, this contains the "Phone Shop" app that users can use to trigger off a group of incidents to run a typical incident workflow.

2. You will need to edit the cart.html file and input the global event integration key from your PagerDuty instance and input this for the serviceKey variable which can be shown on line 313 and 316 of the cart.html file. 
![Alt text](https://github.com/PD-hliang/DemoEnvironment/blob/master/images/example1.png)

3. For each user who needs their own phone shop instance, you will need to make a folder for them in the root directory of the S3 bucket. You can then copy and paste the contents of Demo App folder into the new folder. In the EMEADEMO S3 bucket, we have used the sales reps name as the folder name as you can see below. 
![Alt text](https://github.com/PD-hliang/DemoEnvironment/blob/master/images/example2.png)
This will allow you to route the triggered alerts to the correct service for each individual user, as the sales reps name is extracted from the URL of the website and will be passed in the payload to PagerDuty

4. You will need to put the directory into an S3 bucket and create a static website hosting on S3. https://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html 
The link above provides AWS documentation on how to set up a static website using S3 buckets.

5. This will allow each user to have their own individual links to a Phone Shop which will look something similar to:
http://AWSBucketName.com/SalesRepName/index.html


## Setting up PagerDuty to route the alerts

1. In PagerDuty we now need to create some event rules to route the alerts triggered to the relevant service. They will look something like the following:
![Alt text](https://github.com/PD-hliang/DemoEnvironment/blob/master/images/example3.png)

Use the details.SystemRoute variable and the sales reps folder name to route the alerts to the correct service

2. We have also automatically set the priority of the incident to P1 so this automatically populates the status page business services

 




