**Checkov** 
In Part 5 we are going to utalise checkoov which is a static code analysis tool for scannning infrastructure as code files for misconfigurations thay may lead to security or compliance problems.
Checkov checks for all common configuration and security errors in your Terraform code BEFORE deploying it.  Anytime you download a Terraform script to execute in your environment, you will want to run Checkov to make sure that it meets your standards for configuration.


**How to install checkov**

-Install Pip3 and Python 
-

>https://github.com/sbuTech101/CloudSecurity/blob/3b6a9086c7f172fd2802ab7f8331ddfb24e8b3ac/images/pip%20installed.png

-Install Checkov
- 
Pip3 install checkov

>https://github.com/sbuTech101/CloudSecurity/blob/e32809187ebbb1534b2ca3321196c8b4f7ce6a54/images/check%20installed%20part5.png

The after we are will create a terraform direcorty and cd into it.

Create  main.tf file with vscode 
THe create or paste code then save and exist vscode 
-Then format the file
>terraform fmt

Then we execute checkov and we make sure we in the directory that our file is in .

>checkov -fm main.tf 
