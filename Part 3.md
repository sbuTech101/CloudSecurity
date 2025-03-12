**Installing Terraform**

**Goal:**
In this part of our project we are going to go through detailed steps on how to install terraform and in our project we utalise the powershell.
why?

Using Bash on Windows, you're likely running it within WSL, which adds complexity to the installation. PowerShell keeps things simple and native to Windows environments.

**installing terraform on powershell?**
-Run powershell as admin
-Run the following command : curl.exe -O https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_windows_amd64.zip
Expand-Archive terraform_0.12.26_windows_amd64.zip
Rename-Item -path .\terraform_0.12.26_windows_amd64\ .\terraform

**The Azure cli tool**
The Azure CLI (Command-Line Interface) is a cross-platform tool used to manage and interact with Microsoft Azure services and resources. It allows users to perform tasks like creating, configuring, and managing Azure resources directly from the command line, without the need for a graphical user interface (GUI).

