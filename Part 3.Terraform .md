<ins>**Installing Terraform**</ins>

**Goal:**

>In this part of our project we are going to go through detailed steps on how to install terraform and in our project we utalise the powershell.
why?

>Using Bash on Windows, you're likely running it within WSL(Windows subsystem for linux), which adds complexity to the installation. PowerShell keeps things simple and native to Windows environments.

<ins>**Installing terraform on powershell?**</ins>

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



**Terraform Block**

just to explian a little on the terraform configuration file that we have.We have a terraform block as we can see which contains the terraform settings ,including the required providers that terraform will use to provision our infrustructure.On each provider the source attribute difines the hostname,a namespace ,and the provider type.

**Providers**
THis block configures the specified provider which is azurerm.SO this will be a plugin that terraform will use to create and manage our resouces.

**Resource**

Resource blocks have two strings before the block: the resource type and the resource name. In our project the resource type is azurerm_resource_group and the name is rg. 
The prefix of the type maps to the name of the provider. For our project, Terraform manages the azurerm_resource_group resource with the azurerm provider. 
Together, the resource type and resource name form a unique ID for the resource.

So remeber in our part 2 we explained the terraform life cycle this is where we are going to use it.

First we initialize or terraform-azure-directory .
After we done with that we can now work with our terraform.

Than you can terraform plan to see any changes required for your infrustructure.

It should look something like this:

https://github.com/sbuTech101/CloudSecurity/blob/17212b7ddeccb70c49601e3dd0f93aa1a9183562/images/terraform%20applied.PNG

**<ins>Format and validate the configuration</ins>**

The **terraform fmt** command automatically updates configurations in the current directory for readability and consistency.
which we have already done 

You can also make sure your configuration is syntactically valid and internally consistent by using the >terraform validate command. 

if successful it will retun 
Success! The configuration is valid.

(https://github.com/sbuTech101/CloudSecurity/blob/2bfcf8f2a0ea77bdfda695662f8a5aeff05984da/images/part%206%20terraform%20installed.png).

**<ins>Apply your Terraform Configuration<ins/>**
Run the terraform apply command to apply your configuration. This output shows the execution plan and will prompt you for approval before proceeding. If anything in the plan seems incorrect or dangerous. And if it is you can abort .

after everything has be completed we go onto to inspect ourst state.

Terraform writes data into a field called terraform.tfstate and this file contains the properties and IDS of the resources  Terraform created so it can be managed and destroued going forward.And our >state file contains all of the data in our configuration file and may contain sensitive information which is best to keep safe.
We can view the current state by using **terraform show.**

and another useful command that we can use to review the information in our statefile is the >terraform list 

And we aslo have the terraform state <subcommand>  This command has subcommands for advanced state management. These subcommands can be used to slice and dice the Terraform state. This is sometimes necessary in advanced cases.
