# Part 3 — Terraform

## Installing Terraform

### Windows Installation
1. Download Terraform from https://developer.hashicorp.com/terraform/downloads
2. Extract the zip file
3. Add terraform.exe to your system PATH
4. Verify installation:
```bash
terraform --version
```

---

## Terraform Commands Used in This Project

| Command | What it Does |
|---|---|
| `terraform init` | Downloads required providers (azurerm, azuread) |
| `terraform plan` | Shows what will be created/changed/destroyed |
| `terraform apply` | Deploys the infrastructure to Azure |
| `terraform destroy` | Removes all deployed resources |

---

## Provider Configuration
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.114.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
  }
}
```

---

## Setting Azure Credentials
Terraform needs credentials to connect to Azure:
```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```

---

## Important: Protect Your State File
The `terraform.tfstate` file contains sensitive resource information and must never be pushed to GitHub. Always include in `.gitignore`:
```
terraform.tfstate
terraform.tfstate.backup
*.tfstate
```

---

## Next Step
→ See **Part 4 — Deploying the HoneyPot**
