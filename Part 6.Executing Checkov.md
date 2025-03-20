**In this final Part of the project.**
SO here are going to put everything together and show people the state of cloud security posture .
we firatly going to analyze terraform code with checkov.

Make a terraform directory and move there.
Create main.tf with vscode
and it will have the following configurations in it.

**format the file**
terraform fmt

**Execute Checkov**
checkov -f main.tf

>https://github.com/sbuTech101/CloudSecurity/blob/5f5a6d6b612a40d467caf36a818dd74d447fbdf7/images/part6%20update%20checkov.png

We have seven failed checks.  Looking through the list it is warning us for stuff that we have configured specifically like ports that are exposed to the public internet.  Since this is the honeypot that we just configured in
Azure Cybersecurity Labs - Part Four, we know that this works and we know that this is how it needs to be configured to work properly.  

>Then we deploy this to azure

we login: **az login**

**Then we initialize the directory.**
>terraform init

**Then we plan:**

>terraform plan

>then we apply

**Prowler**
Prowler is an Open Source security tool to perform AWS, Azure, Google Cloud and Kubernetes security best practices assessments, audits, incident response, continuous monitoring, hardening and forensics readiness, and also remediations! 
We have Prowler CLI (Command Line Interface) that we call Prowler Open Source.

**Install Prowel.**

pip3 install prowler
>

**Run Prowel** 
>https://github.com/sbuTech101/CloudSecurity/blob/6f3c10def7f25f117fbf93b9e99c5f9599346792/images/part%206%20prowel%20working%20and%20intializing%20scan.png

>prowler azure --az-cli-auth


THe after we have prowel test results and the output of test as file.
>Prowel test 
>https://github.com/sbuTech101/CloudSecurity/blob/8f9c9287e0471c7685ba8c7ed66acaf460878a6b/images/prowel%20test%20results%20part%206.PNG
