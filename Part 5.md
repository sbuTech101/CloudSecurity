**Checkov** 
In Part 5 we are going to utalise checkoov which is a static code analysis tool for scannning infrastructure as code files for misconfigurations thay may lead to security or compliance problems.
Checkov checks for all common configuration and security errors in your Terraform code BEFORE deploying it.  Anytime you download a Terraform script to execute in your environment, you will want to run Checkov to make sure that it meets your standards for configuration.


**How to install checkov**

-Install Pip3 and Python 
-
-Install Checkov
- 
Pip3 install checkov

The after we are will create a terraform direcorty and cd into it.

Create  main.tf file with vscode 
THe create or paste code then save and exist vscode 
-Then format the file
>terraform fmt

Then we execute checkov and we make sure we in the directory that our file is in .

>checkov -fm main.tf 
