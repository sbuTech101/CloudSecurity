**SettingUp Honeypot**

<ins>**Introduction**</ins>

This TPOT (Threat Perception and Observation Tool) is designed to attract hackers with malicious intent.Hackers are attracted to honeypots because they seem like easy targets. However, when they try to break in, cybersecurity experts can monitor their actions. This allows us to study how they attack, what methods they use, and even trace where the attacks originate from. 

**Pre-Requiaites**

-Basic Understanding of Azure Portal

-Familarity with Vms

**VM Setup:**

To create a Tpot system ,youll need to create a virtual machine that will hold/run your tpot system ,which will be open to attacks
so we need this in a virtual enviroment so that or physical machine wont be affected what better way than the azure cloud.
To setup our Tpot we will have to:

In our Azure Portal we will have a resource group and in that resopurce group wil have

Virtual Machine, Public IP address, Network Security Group

**Virtual machine simulation:**
**Description**: This creation of the vm will allow us to run our resources in a controlled enviroment that can be deleted at anytime
without harming our personal machine and also will also be to see what attacks do to our systems.

Name the virtual machine, “tpot-vm”

Set the region to "East US"

Set the security type to “standard”

Click see all images and select “Ubuntu Minimal 24.04 LTS -x64 Gen1” 

Choose size “Standard_A2m_v2 — 2 vcpus, 16 GiB memory”

Thorough detailed steps with images on how to setup the virtual machine:

**refer to this link:** https://github.com/sbuTech101/CloudSecurity/blob/6f17555885194c7ebc97e1ce3452f9cc2883309a/Vm%20Part1%20setup.docx





