# PagerDuty Demo Environment Setup Guide


# Prereq

* Access to AWS S3 Bucket to host the "phone shop" website
* Pagerduty instance 
* Global event rule key
* Terraform installed (if you want to automate some of this, you can find this in the last section)


## Setting up the Phone Shop

1. Clone the demo app folder in this github repo, this contains the "Phone Shop" app that users can use to trigger off a group of incidents to run a typical incident workflow.

2. You will need to edit the cart.html file and input the global event integration key from your PagerDuty instance and input this for the serviceKey variable which can be shown on line 316 of the cart.html file (There is also one to be replaced on line 446 and 514. 
<img src="https://github.com/PD-hliang/DemoEnvironment/blob/master/images/example1.png" width="400">

3. For each user who needs their own phone shop instance, you will need to make a folder for them in the root directory of the S3 bucket. You can then copy and paste the contents of Demo App folder into the new folder. In the EMEADEMO S3 bucket, we have used the sales reps name as the folder name as you can see below. 
<img src="https://github.com/PD-hliang/DemoEnvironment/blob/master/images/example2.png" width="300">


This will allow you to route the triggered alerts to the correct service for each individual user, as the sales reps name is extracted from the URL of the website and will be passed in the payload to PagerDuty

4. You will need to put the directory into an S3 bucket and create a static website hosting on S3. https://docs.aws.amazon.com/AmazonS3/latest/dev/HowDoIWebsiteConfiguration.html 
The link above provides AWS documentation on how to set up a static website using S3 buckets.

5. This will allow each user to have their own individual links to a Phone Shop which will look something similar to:
http://AWSBucketName.com/SalesRepName/index.html


## Setting up PagerDuty to route the alerts

1. In PagerDuty we now need to create some event rules to route the alerts triggered to the relevant service. They will look something like the following:
<img src="https://github.com/PD-hliang/DemoEnvironment/blob/master/images/example3.png" width="1200">

Use the details.SystemRoute variable and the sales reps folder name to route the alerts to the correct service

2. We have also automatically set the priority of the incident to P1 so this automatically populates the status page business services

 
## Automating some of this

If you wanted to automate the creation of the Phone Shop, creating services, EP's, and event rules for each Rep to be on boarded, I have added some a terraform script that does this. It will build out a service, a simple EP with the Rep as the first escalation point so they will always be on call, and a event rule that will route their alert from their Phone Shop instance to the correct service. 

1. First of all you will need to clone both the terraformScript and Demo App folder (remember to make sure you do step 2 from Setting up the phone shop above). 

2. You will need to start filling out the vars.tf file out with all the necessary variables to automate this flow. The first set of variables you will need to fill out are the AWS environment variables as shown below: 

<img src="https://github.com/PD-hliang/DemoEnvironment/blob/master/images/awsVars.png" width="300">
You will need to add:
 - The preferred region the S3 bucket sits in
 - Your AWS access key and secret key
 - A unique bucket name
 
3. Once you have done that you will need to add in your PD variables as shown below: 

<img src="https://github.com/PD-hliang/DemoEnvironment/blob/master/images/pdVars.png" width="500">

You will need: 
 - You P1 incident priority ID
 - A list of email ID's (as shown in the example in the screenshot) and Rep first names (both list must be in the same Rep order, as shown in the example above)
 - a PD API key which can read and write 
 
4. The final step is to alter one section in the main.tf file. You need to set directory for where you save the DemoApp to be in (this can be found on line 56), you can see this in the screenshot below: 

<img src="https://github.com/PD-hliang/DemoEnvironment/blob/master/images/customCommand.png" width="700">

5. Now run terraform and it should automajically build out the Phone shop website, services, EP's and event rules for you!

