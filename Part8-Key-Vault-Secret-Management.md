# Part 8 — Azure Key Vault Secret Management

## The Problem — Hardcoded Secrets
In the original project, sensitive values were hardcoded directly in Terraform files:

```hcl
# INSECURE — never do this
admin_password = "CyberNOW!"
subscription_id = "eb09d6e0-bcf0-41f0-ad96-efd7e8e14873"
password = "TempP@ss!Alice1"
```

**Why this is dangerous:**
- If pushed to GitHub, secrets are permanently exposed — even after deletion
- Anyone with repo access can see credentials
- Violates security best practices and AZ-500 principles

---

## The Solution — Azure Key Vault

Azure Key Vault is a cloud service for securely storing and accessing secrets, keys, and certificates. All sensitive values are stored encrypted in Key Vault and referenced in Terraform via data blocks.

---

## Key Vault Setup

### Step 1 — Create Key Vault
1. Azure Portal → Key Vaults → Create
2. Resource Group: tpot-resources
3. Name: tpot-keyvault
4. Region: South Africa North
5. Permission model: Azure role-based access control

### Step 2 — Assign Permissions
Assign yourself the **Key Vault Secrets Officer** role:
1. Key Vault → Access Control (IAM) → Add role assignment
2. Role: Key Vault Secrets Officer
3. Member: your account

### Step 3 — Store Secrets
Add the following secrets in Key Vault → Secrets:

| Secret Name | Value |
|---|---|
| vm-admin-password | VM admin password |
| subscription-id | Azure subscription ID |
| alice-password | Alice's temporary password |
| bob-password | Bob's temporary password |
| carol-password | Carol's temporary password |

---

## Terraform Integration

### Reference Key Vault in Terraform:
```hcl
# Point to the Key Vault
data "azurerm_key_vault" "tpot_kv" {
  name                = "tpot-keyvault"
  resource_group_name = "tpot-resources"
}

# Pull a specific secret
data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.tpot_kv.id
}

# Use the secret in a resource
os_profile {
  admin_password = data.azurerm_key_vault_secret.vm_password.value
}
```

---

## Before vs After

| | Before | After |
|---|---|---|
| VM Password | `"CyberNOW!"` hardcoded | Referenced from Key Vault |
| Subscription ID | Hardcoded in locals | Referenced from Key Vault |
| User Passwords | Hardcoded in user blocks | Referenced from Key Vault |
| Risk | High — exposed if pushed to GitHub | None — never in code |

---

## Key Vault Benefits
- ✅ Secrets encrypted at rest and in transit
- ✅ Full audit log of every secret access
- ✅ Role-based access control — only authorised users can read secrets
- ✅ Secrets never appear in Terraform code or GitHub

---

## Next Step
→ See **Part 9 — GitHub Actions CI/CD Pipeline**
