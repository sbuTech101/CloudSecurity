# Part 4 — Deploying the HoneyPot

## What Gets Deployed
Running `terraform apply` deploys the following resources to Azure:

| Resource | Name | Details |
|---|---|---|
| Resource Group | tpot-resources | East US region |
| Virtual Network | tpot-network | 10.0.0.0/16 |
| Subnet | internal | 10.0.2.0/24 |
| Public IP | tpot-vm-ip | Static — 52.188.2.165 |
| Network Interface | tpot-vm-nic | Connected to subnet |
| NSG | linux-vm-nsg | Open rules (intentional) |
| Virtual Machine | tpot-vm | Ubuntu 24.04 LTS |

---

## The HoneyPot VM
```hcl
resource "azurerm_virtual_machine" "main" {
  name     = "tpot-vm"
  vm_size  = "Standard_DC1ds_v3"

  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = data.azurerm_key_vault_secret.vm_password.value
  }
}
```

---

## Network Security Group — Intentionally Open
The NSG is deliberately configured to allow all inbound traffic:

```hcl
security_rule {
  name                   = "AllowALL"
  priority               = 100
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "*"
  source_address_prefix  = "Internet"
}
```

**Why?** A HoneyPot must be accessible to attackers. Blocking traffic would defeat the purpose. In a real production environment these rules would be locked down.

---

## Deployment Output
After `terraform apply` completes:
```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:
public_ip = "52.188.2.165"
```

---

## What Happens After Deployment
Within minutes of the VM going live at 52.188.2.165, real threat actors begin:
- Brute forcing SSH (port 22)
- Scanning for open ports
- Attempting to exploit known vulnerabilities
- Running automated attack tools

All of this activity is captured by Microsoft Sentinel for analysis.

---

## Next Step
→ See **Part 5 — Checkov Security Scan**
