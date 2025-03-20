**Deploying A honeyPot via Terraform**

**Create Terraform configuration file**

>Below we create a a dir that will contain our terraform configurations files.

https://github.com/sbuTech101/CloudSecurity/blob/299dd42a02b216a78b984ed4814327c80d4ad7b6/images/making%20a%20tpot%20dir.png

The after we create a file which we edit with vscode and the file contains configurations of or new resources we have created.

>https://github.com/sbuTech101/CloudSecurity/blob/11b0792041ce0abc17ee114153410409d5d5374e/Terraform%20config.files/Code%20main%20(2).tf

In windoes we will create a folder called tpot then inside we create a file that will h
there after we will open visual studio code and have the following configurations as shown in the following link.
In this file that will create a few resources but we all doing this manualy unlike with GUI.

The after again we terraform and apply.||
then we will have a public ip address that we will ssh into .Using the credentials and password we created.

And install honeyPot.
These are the commands we are going to use:

env bash -c "$(curl -sL https://github.com/telekom-security/tpotce/raw/master/install.sh)"

Select "Hive" install

sudo reboot (when finished)


Then we can ssh into out honeyPot in my case its : 

https://github.com/sbuTech101/CloudSecurity/blob/3c397fa1cd187080f964f24f0bc577ded02fd8be/images/par4%20now%20we%20ssh%20into%20it.PNG

