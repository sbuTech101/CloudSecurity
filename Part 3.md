<ins>**Installing Terraform**</ins>

**Goal:**

>In this part of our project we are going to go through detailed steps on how to install terraform and in our project we utalise the powershell.
why?

>Using Bash on Windows, you're likely running it within WSL(Windowsubsystem for linux, which adds complexity to the installation. PowerShell keeps things simple and native to Windows environments.

<ins>**installing terraform on powershell?**</ins>

-Run powershell as admin
-Run the following command : curl.exe -O https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_windows_amd64.zip
Expand-Archive terraform_0.12.26_windows_amd64.zip
Rename-Item -path .\terraform_0.12.26_windows_amd64\ .\terraform

**Terraform installed:**

https://github.com/sbuTech101/CloudSecurity/blob/c790ae84b9d693eb751bb48cb9b0c75f36881960/images/installing%20terraform.PNG


**The Azure cli tool**

The Azure CLI (Command-Line Interface) is a cross-platform tool used to manage and interact with Microsoft Azure services and resources. It allows users to perform tasks like creating, configuring, and managing Azure resources directly from the command line, without the need for a graphical user interface (GUI).

_Install The Azure CLI Tool_

Then we are going to install our ClI tool which is very simple to do we will just run the followinf commmand.

$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi

And after the installation we can run the az command from the command prompt.
In cmd: Type **az login** 

https://github.com/sbuTech101/CloudSecurity/blob/bf865b8ec7ed704fb04b9145701939c5a3a4aa17/images/login%20into%20az%20with%20cmd.PNG


And from the we can select the account description we want to use and you can choose  your account.

The after we need to write a configuration file for our terraform .

**Found on the link below:**

https://github.com/sbuTech101/CloudSecurity/blob/5dce5d1ca335d873f45c248349c4c9982a72d9df/code%20main.tf



