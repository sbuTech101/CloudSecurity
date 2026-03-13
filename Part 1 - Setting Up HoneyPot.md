# Part 1 — Setting Up the HoneyPot

## What is a HoneyPot?
A HoneyPot is a deliberately vulnerable system designed to attract cyber attackers. It looks like a real target but its sole purpose is to be attacked — so we can monitor, study, and learn from the attackers' behaviour.

Think of it like a fake house with all the doors unlocked, filled with cameras, designed to catch burglars in the act.

---

## Why Build a HoneyPot on Azure?
- Azure provides a real cloud environment where actual threat actors operate
- Exposing a VM to the internet generates real attack data — not simulated
- Microsoft Sentinel gives us enterprise-grade SIEM capabilities to analyse the data
- The combination demonstrates a real-world SOC workflow

---

## What We're Building
A vulnerable Ubuntu VM deployed on Azure with:
- All inbound ports open (intentional — to attract attackers)
- SSH exposed on port 22 (to capture brute force attempts)
- Microsoft Sentinel connected to capture and alert on attack data
- A SOC team to analyse the threats

---

## Prerequisites
- Microsoft Azure account
- Azure subscription with contributor access
- Basic understanding of cloud computing concepts

---

## Azure Resources Overview

| Resource | Name | Purpose |
|---|---|---|
| Resource Group | tpot-resources | Container for all project resources |
| Virtual Machine | tpot-vm | The HoneyPot target |
| Public IP | tpot-vm-ip (52.188.2.165) | Exposes VM to the internet |
| Virtual Network | tpot-network | Network infrastructure |
| Subnet | internal (10.0.2.0/24) | VM subnet |
| NSG | linux-vm-nsg | Intentionally open security rules |

---

## Next Step
With the architecture planned, the next step is setting up **Infrastructure as Code** using Terraform to deploy everything consistently and repeatably.

→ See **Part 2 — Infrastructure as Code**
