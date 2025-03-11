# CloudSecurity
This project is divided into 6 parts where we explore cloud security, its architecture, and how we used different tools to secure our cloud environment.

<ins>**Part 1: SettingUP honeyPot**</ins>

**Goal** 

This honeypot project is a fake computer system or network that looks real but isn’t actually used for any important work. It’s designed to attract hackers who are up to no good.THis Honeypot is to show us what type of attacks we are going to be hit with and where they originate from.

![image alt](https://github.com/sbuTech101/CloudSecurity/blob/ed99ea5980029cbec4200487842029e4a181ee9c/Microsoft%20Game%20DVR%20-%20T-Pot%20Attack%20Map%20-%20Google%20Chrome%20-%20VLC%20media%20player%202025_03_05%2022_00_51.png)

<ins>**Creating a virtual Machine on azure** </ins>

Name- Tpot-vm  

Region – East US available on Zone 2  

Security Type – Standard 

Ubuntu Minimal 24.04 LTS –x64 Gen2 

Virtual machine size is Standard E2s V3 (2 Cups, 16Gib memory) 

Vm Architecture x64 


<ins>**Part 2** </ins>

**Goal** 

Infrastructure as Code (IaC) is about using code to manage the computing infrastructure in the cloud rather than pointing and clicking and using the GUI. This includes things like operating systems, databases, and storage to name a few. We are just going to explain what terraform is and what terraform is used for.

**Tool :**

Terraform

<ins>**Part 3** </ins>

**Goal** 

Here, we’ll be using Terraform. First, we’ll install Terraform and then perform our first Terraform lifecycle, which is a 4-step process:

**Init:**  Initialize the (local) Terraform environment. Usually executed only once per session.

**Plan:**  Compare the Terraform state with the as-is state in the cloud, build and display an execution plan.   This does not change the deployment (read-only).

**Apply:**  Apply the plan from the plan phase. This potentially changes the deployment (read and write).

**Destroy:**  All resources that are governed by this specific terraform environment.

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





