# Part 10 — SOC Team, Identity Management & Key Vault Secrets

## Overview
This part covers the complete identity and access management setup for the HoneyPot project — including the SOC team users created in Azure AD, their group assignments, RBAC roles, and how all their credentials are securely stored in Azure Key Vault.

---

##The SOC Team

Three users were created to simulate a real Security Operations Centre team, each with a specific role and access level:

| User | Email | Job Title | Department |
|---|---|---|---|
| **Alice Admin** | alice.admin@sibusisosekkhotogmail.onmicrosoft.com | Security Administrator | IT Security |
| **Bob Analyst** | bob.analyst@sibusisosekkhotogmail.onmicrosoft.com | Security Analyst | SOC |
| **Carol Viewer** | carol.viewer@sibusisosekkhotogmail.onmicrosoft.com | Compliance Auditor | Compliance |

---

## Why These Three Roles?

This mirrors a real-world SOC structure:

| Role | Responsibility | Real World Equivalent |
|---|---|---|
| **Alice — Admin** | Manages the HoneyPot VM, Sentinel workspace, and team access | SOC Manager / Security Lead |
| **Bob — Analyst** | Investigates Sentinel alerts and attack patterns from HoneyPot | Tier 2 SOC Analyst |
| **Carol — Viewer** | Reviews dashboards and compliance reports — read only | Compliance Officer / Auditor |

---

## Security Groups

Three Azure AD security groups were created — one per role:

```hcl
resource "azuread_group" "admins" {
  display_name     = "honeypot-admins"
  security_enabled = true
  description      = "Full access — manages HoneyPot infrastructure and Sentinel"
}

resource "azuread_group" "analysts" {
  display_name     = "honeypot-analysts"
  security_enabled = true
  description      = "Investigates Sentinel alerts and HoneyPot attack data"
}

resource "azuread_group" "viewers" {
  display_name     = "honeypot-viewers"
  security_enabled = true
  description      = "Read-only access to Sentinel dashboards and reports"
}
```

---

## RBAC Role Assignments

Each user was assigned the appropriate Microsoft Sentinel role:

```hcl
# Alice — full Sentinel management
resource "azurerm_role_assignment" "alice_sentinel" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Microsoft Sentinel Contributor"
  principal_id         = azuread_user.alice.id
}

# Bob — investigate and respond to incidents
resource "azurerm_role_assignment" "bob_sentinel" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Microsoft Sentinel Responder"
  principal_id         = azuread_user.bob.id
}

# Carol — view only
resource "azurerm_role_assignment" "carol_sentinel" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Microsoft Sentinel Reader"
  principal_id         = azuread_user.carol.id
}
```

---

## Principle of Least Privilege

Each user only has the minimum access needed to do their job:

| User | Can Create Rules | Can Investigate | Can Respond | Can View |
|---|---|---|---|---|
| Alice | ✅ | ✅ | ✅ | ✅ |
| Bob | ❌ | ✅ | ✅ | ✅ |
| Carol | ❌ | ❌ | ❌ | ✅ |

This prevents privilege escalation — if Bob's account is compromised, an attacker cannot make changes to the Sentinel configuration.

---

## Password Security — force_password_change

All users are created with:
```hcl
force_password_change = true
```

This means on first login, each user must set their own password — a security best practice that ensures only the user knows their own credentials.

---

## Azure Key Vault — Secrets Created

All sensitive values for this project are stored in **tpot-keyvault**:

| Secret Name | What it Stores | Why in Key Vault |
|---|---|---|
| `vm-admin-password` | HoneyPot VM admin password | Never hardcode VM credentials |
| `subscription-id` | Azure subscription ID | Prevents exposing subscription details in code |
| `alice-password` | Alice's temporary password | SOC team credentials secured |
| `bob-password` | Bob's temporary password | SOC team credentials secured |
| `carol-password` | Carol's temporary password | SOC team credentials secured |

---

## How Key Vault Was Set Up

### Step 1 — Created Key Vault
- Portal → Key Vaults → Create
- Name: **tpot-keyvault**
- Resource Group: **tpot-resources**
- Region: **South Africa North**
- Permission model: **Azure role-based access control**

### Step 2 — Assigned Key Vault Secrets Officer Role
- Key Vault → Access Control (IAM)
- Added role assignment: **Key Vault Secrets Officer**
- Assigned to project owner account

### Step 3 — Created All Secrets
- Key Vault → Secrets → Generate/Import
- Created all 5 secrets listed above
- All stored encrypted at rest

---

## How Terraform References Key Vault Secrets

```hcl
# Reference the Key Vault
data "azurerm_key_vault" "tpot_kv" {
  name                = "tpot-keyvault"
  resource_group_name = "tpot-resources"
}

# Pull subscription ID from Key Vault
data "azurerm_key_vault_secret" "subscription_id" {
  name         = "subscription-id"
  key_vault_id = data.azurerm_key_vault.tpot_kv.id
}

# Pull Alice's password from Key Vault
data "azurerm_key_vault_secret" "alice_password" {
  name         = "alice-password"
  key_vault_id = data.azurerm_key_vault.tpot_kv.id
}

# Use the secret in the user resource
resource "azuread_user" "alice" {
  password = data.azurerm_key_vault_secret.alice_password.value
}
```

---

## Conditional Access Policies (Planned)

Four Conditional Access policies were designed but require **Azure AD Premium P1** licensing:

| Policy | Purpose | Status |
|---|---|---|
| CA001 — Require MFA | Protect SOC team accounts | Commented out — needs P1 |
| CA002 — Block Legacy Auth | Prevent MFA bypass via old protocols | Commented out — needs P1 |
| CA003 — Compliant Device | Ensure team uses secure devices | Commented out — needs P1 |
| CA004 — Block by Location | Allow sign-ins from ZA/GB/US only | Commented out — needs P1 |

**Workaround:** Azure Security Defaults were enabled as a free alternative — providing basic MFA enforcement and legacy auth blocking without premium licensing.

---

## Summary

This section demonstrates:
- ✅ Real-world SOC team structure with appropriate roles
- ✅ Principle of least privilege applied to all users
- ✅ Azure AD groups for scalable access management
- ✅ RBAC role assignments scoped correctly
- ✅ All credentials secured in Azure Key Vault
- ✅ No hardcoded secrets anywhere in the codebase
- ✅ Security Defaults as a free Conditional Access alternative
