# Part 5 — Checkov Security Scan

# What is Checkov?
Checkov is a static code analysis tool that scans Infrastructure as Code files and checks them against security best practices. It identifies misconfigurations before they reach production.

---

## Installing Checkov
```bash
pip install checkov
```

Verify installation:
```bash
checkov --version
```

**Note:** Checkov requires Python 3.11. It has compatibility issues with Python 3.13. If you encounter errors, upgrade Checkov:
```bash
pip install --upgrade checkov
```

---

## Running Checkov
```bash
checkov -d "path/to/terraform/files"
```

Save results to file:
```bash
python -m checkov.main -d "C:\Users\Sbu\OneDrive\Terraform configurations" > checkov-results.txt
```

---

## Scan Results Summary

| Result | Count |
|---|---|
| ✅ Passed | 27 |
| ❌ Failed | 29 |
| ⏭️ Skipped (intentional) | 2 |

---

## Key Findings and Actions Taken

### 🔴 Critical — Fixed

**Hardcoded Passwords**
- **Finding:** VM admin password `CyberNOW!` hardcoded in `main.tf`
- **Risk:** If pushed to GitHub, password is permanently exposed
- **Fix:** Moved to Azure Key Vault — referenced via `data.azurerm_key_vault_secret`

**Hardcoded Subscription ID**
- **Finding:** Subscription ID hardcoded in `az500-honeypot-team.tf`
- **Risk:** Exposes Azure subscription details publicly
- **Fix:** Moved to Azure Key Vault

**Hardcoded User Passwords**
- **Finding:** Alice, Bob, Carol passwords hardcoded
- **Risk:** SOC team credentials exposed in code
- **Fix:** All moved to Azure Key Vault

---

### 🟡 Intentionally Skipped

**CKV_AZURE_160 — HTTP Port 80 Restricted**
- **Why skipped:** HoneyPot design requires open ports to attract attackers
- **Justification:** This is a deliberate security design choice

**CKV2_AZURE_10 — Microsoft Antimalware**
- **Why skipped:** This check is for Windows VMs only. Our VM runs Ubuntu Linux
- **Justification:** False positive — not applicable to Linux

---

## Before vs After Key Vault Integration

**Before (insecure):**
```hcl
os_profile {
  admin_password = "CyberNOW!"
}
```

**After (secure):**
```hcl
os_profile {
  admin_password = data.azurerm_key_vault_secret.vm_password.value
}
```

---

## Next Step
→ See **Part 6 — Prowler Compliance Report**
