# PagerDuty Demo Environment Setup Guide


# Prereq

* Access to AWS S3 Bucket to host the "phone shop" website
* Pagerduty instance 
* Global event rule key


## Setup

1. Clone the demo app folder in this directory, this contains the "Phone Shop" app that users can use to trigger off a group of incidents to run a typical incident workflow.

2. You will need to edit the cart.html file and input the global event integration key from your PagerDuty instance and input this for the serviceKey variable which can be shown on line 313 and 316 of the cart.html file. 
![alt text](https://github.com/PD-hliang/DemoEnvironment/images/example1.png)


3. You will need to put the directory into an S3 bucket and create a static website hosting on S3. https://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html This is a link to AWS documentation on how to set up a static website using S3 buckets.

4. 
 




