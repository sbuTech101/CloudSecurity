# Part 11 — Lessons Learned

## Overview
This document captures the key lessons, challenges, and insights gained from building the Azure HoneyPot Cloud Security project end to end.

---

## 1. Hardcoded Secrets Are a Real Risk — Even in Labs

**What happened:**
The original Terraform files had passwords hardcoded directly in the code:
```hcl
admin_password = "CyberNOW!"
```

**Why it matters:**
Checkov flagged this immediately. If this had been pushed to a public GitHub repo, the password would be permanently visible — even after deletion, Git history preserves it.

**What was done:**
All secrets moved to Azure Key Vault. Terraform now references them via `data` blocks — no sensitive values ever appear in code.

**Lesson:**
Treat every lab environment like a production environment. Bad habits in labs become bad habits in real jobs.

---

## 2. Azure RBAC vs Key Vault Access Policies

**What happened:**
After creating tpot-keyvault, the project owner kept getting **403 Forbidden** errors when trying to create secrets — even as the subscription Owner.

**Why it happened:**
Key Vault was set to use Azure RBAC permission model. Being a subscription Owner does not automatically grant Key Vault secret access. A specific **Key Vault Secrets Officer** role assignment was required.

**Lesson:**
Azure RBAC and Key Vault access are separate permission layers. Always explicitly assign Key Vault roles even when you have Owner access at the subscription level.

---

## 3. Conditional Access Requires Azure AD Premium P1

**What happened:**
Four Conditional Access policies were designed in Terraform — requiring MFA, blocking legacy auth, enforcing compliant devices, and restricting sign-in locations. They were ready to deploy but couldn't be activated.

**Why it happened:**
Conditional Access policies require Azure AD Premium P1 licensing. The free trial could not be activated on this tenant.

**Workaround:**
Azure Security Defaults were enabled — a free feature that provides basic MFA enforcement and legacy authentication blocking without premium licensing.

**Lesson:**
Always check licensing requirements before designing features. In enterprise environments, confirm what licenses are available before committing to a design.

---

## 4. Terraform State Files Are Sensitive

**What happened:**
`terraform.tfstate` was accidentally tracked by Git and almost pushed to GitHub. The state file contains resource IDs, IP addresses, and configuration details about every deployed resource.

**What was done:**
Added `*.tfstate` and `*.tfstate.backup` to `.gitignore` immediately.

**Lesson:**
The `.gitignore` file should be the first file created in any Terraform project — before the first `terraform apply`. Remote state storage in Azure Blob Storage is the production best practice.

---

## 5. Large Binary Files Break GitHub Pushes

**What happened:**
Terraform provider `.exe` files (some over 100MB) were accidentally tracked by Git. Every push was timing out with HTTP 408 errors because of the file sizes.

**What was done:**
Added `.terraform/` folders to `.gitignore` and removed them from Git tracking with `git rm --cached`.

**Lesson:**
Never commit the `.terraform/` folder. It contains provider binaries that are downloaded fresh by `terraform init` — they don't belong in version control.

---

## 6. HoneyPots Attract Attacks Immediately

**What happened:**
Within minutes of the VM going live at 52.188.2.165 with SSH exposed, real threat actors began brute force login attempts.

**Why it matters:**
This proves the HoneyPot concept works — the internet is constantly being scanned by automated attack tools. Any exposed service will be found and attacked quickly.

**Lesson:**
In real environments, every exposed service is a target. Defence in depth, NSGs, and monitoring are not optional.

---

## 7. DevSecOps Shifts Security Left

**What happened:**
After adding the GitHub Actions CI/CD pipeline, every push to GitHub now automatically runs Checkov and flags security issues before the code is stored.

**Why it matters:**
Security issues caught during development cost nothing to fix. Security issues caught in production can cost millions.

**Lesson:**
Automated security scanning in CI/CD pipelines is non-negotiable in modern cloud environments. This is exactly what employers in cloud security are looking for.

---

## 8. Documentation Is Part of the Project

**What happened:**
The technical infrastructure was built first — documentation came later. Some documentation was lost when the Git repository was reset.

**Lesson:**
Document as you build. Every decision, every design choice, every challenge overcome — write it down immediately. Documentation is what turns a lab into a portfolio project.

---

## Skills Gained

| Skill | Tool/Service |
|---|---|
| Cloud infrastructure deployment | Azure, Terraform |
| Identity and access management | Azure AD, RBAC |
| Security information and event management | Microsoft Sentinel |
| Log management | Log Analytics Workspace |
| Secret management | Azure Key Vault |
| Static security analysis | Checkov |
| Cloud compliance assessment | Prowler |
| CI/CD pipeline development | GitHub Actions |
| Version control | Git, GitHub |
| Security architecture design | HoneyPot, NSG, defence in depth |

---

## What I Would Do Differently

1. **Create `.gitignore` first** — before any other file
2. **Document every step as it happens** — not at the end
3. **Use remote Terraform state from day one** — Azure Blob Storage
4. **Activate Azure AD Premium P1 trial early** — to deploy Conditional Access policies
5. **Start the VM sooner** — to capture more real attack data in Sentinel

---

## Final Thoughts

This project demonstrates a complete, real-world cloud security workflow — from infrastructure deployment to threat detection, compliance reporting, and automated security scanning. Every tool used in this project is used by enterprise SOC teams and cloud security engineers globally.

The HoneyPot is not just a lab — it is live, it is being attacked by real threat actors, and every attack is being captured and analysed by Microsoft Sentinel.

That is real security operations experience.
