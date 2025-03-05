# CloudSecurity
This project spans across 6 parts where we dive into the world of cloud security ,the architecture and we will look at how we utalised a variety of tools to protect our cloud enviroment.

<ins>**SettingUp HonePot** </ins>

**Goal**

This honeypot project is a fake computer system or network that looks real but isn’t actually used for any important work. It’s designed to attract hackers who are up to no good.THis Honeypot is to show us what type of attacks we are going to be hit with and where they originate from.

![image alt](https://github.com/sbuTech101/CloudSecurity/blob/ed99ea5980029cbec4200487842029e4a181ee9c/Microsoft%20Game%20DVR%20-%20T-Pot%20Attack%20Map%20-%20Google%20Chrome%20-%20VLC%20media%20player%202025_03_05%2022_00_51.png)

-Creating a virtual Machine on azure 

Name- Tpot-vm  

Region – East US available on Zone 2  

Security Type – Standard 

Ubuntu Minimal 24.04 LTS –x64 Gen2 

Virtual machine size is Standard E2s V3 (2 Cups, 16Gib memory) 

Vm Architecture x64 


<ins>**Part 1** </ins>
**Goal** 


<ins>**Part 2** </ins>

**Goal** 

Infrastructure as Code (IaC) is about using code to manage the computing infrastructure in the cloud rather than pointing and clicking and using the GUI. This includes things like operating systems, databases, and storage to name a few.

**Tool :**

Terraform

<ins>**Part 3** </ins>

**Goal** 

So here know we using terraform and we going to install terraform and we going to perform or first terrafrom life cycle.
which is a 4 step process:

init — Init. Initialize the (local) Terraform environment. Usually executed only once per session.

plan — Plan. Compare the Terraform state with the as-is state in the cloud, build and display an execution plan. This does not change the deployment (read-only).


apply — Apply the plan from the plan phase. This potentially changes the deployment (read and write).

destroy — Destroy all resources that are governed by this specific terraform environment.

Utalize Azure CLI tools and configure it to be used with terraform.



<ins>**Part 4** </ins>

**Goal** 

write configuration to create  a few new resources
Deploying a honeypot via terraform.

ssh into honeypot with username and password created from honeypot.


<ins>**Part 5** </ins>

**Goal**

Checkov checks for all common configuration and security errors in your Terraform code BEFORE deploying it.

Next up is Azure Infrastructure as Code - Part Five. Checkov is a static code analysis tool for scanning infrastructure as code (IaC) files for misconfigurations that may lead to security or compliance problems

Install Checkov

install Pip3 and Python


<ins>**Part 6** </ins>
**Goal**

we are going to put everything together and generate a report that can be presented to small to medium sized businesses on their cloud security posture

checkov -f main.tf running a check againt this file

Install Prowler

Prowler is an Open Source security tool to perform AWS, Azure, Google Cloud and Kubernetes security best practices assessments, audits, incident response, continuous monitoring, hardening and forensics readiness, and also remediations! 

output of prowel results in output file





