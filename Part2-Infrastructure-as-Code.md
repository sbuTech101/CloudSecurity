# Part 2 — Infrastructure as Code (IaC)

## What is Infrastructure as Code?
Infrastructure as Code (IaC) means writing your cloud infrastructure as code files instead of clicking through a portal. Every resource — VMs, networks, security groups — is defined in code and deployed automatically.

---

#Why I Used IaC for This Project?

| Manual (Portal) | Infrastructure as Code (Terraform) |
|---|---|
| Click through Azure Portal | Write code once |
| Easy to make mistakes | Consistent every time |
| Hard to reproduce | Deploy identical environments instantly |
| No audit trail | Full version history in GitHub |
| Can't automate | Fully automatable |

---

## Why Terraform?
- Works with Azure, AWS, and GCP — not locked to one cloud
- Declarative — you describe what you want, Terraform figures out how
- State management — tracks what's deployed vs what's in code
- Industry standard — used by most enterprise cloud teams

---

## IaC Principles Used in This Project

### 1. Declarative Configuration
We describe the desired end state, not the steps to get there:
```hcl
resource "azurerm_virtual_machine" "main" {
  name     = "tpot-vm"
  vm_size  = "Standard_DC1ds_v3"
}
```

### 2. Secret Management
Secrets referenced from Key Vault — never hardcoded:
```hcl
data "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.tpot_kv.id
}
```

### 3. Outputs
Key information printed after deployment:
```hcl
output "public_ip" {
  value = azurerm_public_ip.tpot-vm-ip.ip_address
}
```

---

## Next Step
→ See **Part 3 — Terraform**
