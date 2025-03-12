# Part 2

**What is IAC?**

Infrastructure as Code (IaC) is about using code to manage the computing infrastructure in the cloud rather than pointing and clicking and using the GUI. This includes things like operating systems, databases, and storage to name a few.The coolest thing about IaC is that rather than going through tideous manual setupt you can simply with IaC define what you want your infrastructure to look like with code without worrying about all the detailed steps to get there.  For instance, you can just say that you want a Debian server with 32gb of ram and 120gb of hard drive space and it figures out everything it needs to do to make that happen. 

**Why should we use IaC?**

**Benefits**

Easy environment duplication.  You can use the same IaC to deploy an environment in one location that you do in another. 

Reduced configuration errors.  Manual configurations are error-prone due to human mistakes so having it automated with IaC it reduces the error

The ability to build and branch on environments easily. 

<ins>***How does IaC Work?***<ins/>

Infrastructure as Code (IaC) is a method of managing IT infrastructure using configuration files that describe the setup of resources like servers and networks, similar to how software code defines an application. These configuration files can be stored in version control systems (like Git), allowing teams to automate, track, and collaborate on infrastructure changes just like software code. This ensures consistency, reduces manual errors, and makes it easier to manage environments across development, testing, and production.

Then we have 2 approaches when it comes to Iac.

**Immutable and Mutable Infrastructure**

In mutable infrastructure, components are changed in production while the service continues to operate normally.  

Immutable infrastructure, components and are set and assembled to create a full service or application.  If any change is required, the entire set of components has to be deleted and redeployed fully to be updated.

<ins>***We have 2 basic approaches to IaC***:<ins/>

**Declarative** describes the desired end state of a system, and the IaC solution creates it accordingly.  Its simple to use if the developer knows what components and settings are needed.  

**Imperative**describes all the steps to set up resources to reach the desired running state.  It's more complex but necessary for intricate infrastructure deployments where the order of events matter.

**Terraform IaC**An open-source tool, Terraform, takes an immutable declarative approach and uses its own language Hashicorp Configuration Language (HCL).with terraform you can use the same configuration for multiple cloud providers.

Terraform is capable of both provisioning and configuration management, but it’s inherently a provisioning tool that uses cloud provider APIs to manage required resources. And since it natively and easily handles the orchestration of new infrastructure, it’s more equipped to build immutable infrastructures, where you have to replace components fully to make changes.

Terraform uses state files to manage infrastructure resources and track changes. State files record everything Terraform builds, so you can easily refer to them.

