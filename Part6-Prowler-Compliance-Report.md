# Part 6 — Prowler Compliance Report

## What is Prowler?
Prowler is an open-source security tool that performs Azure security assessments and compliance checks. It scans your Azure environment against industry frameworks and generates detailed reports.

---

## Compliance Frameworks Scanned

| Framework | Description |
|---|---|
| CIS Azure Benchmark 2.0 | Center for Internet Security best practices |
| CIS Azure Benchmark 2.1 | Updated CIS controls |
| CIS Azure Benchmark 3.0 | Latest CIS framework |
| MITRE ATT&CK | Adversarial tactics and techniques framework |
| ENS RD2022 | Spanish National Security Scheme |

---

## Installing Prowler
```bash
pip install prowler
```

---

## Running Prowler Against Azure
```bash
prowler azure --subscription-id your-subscription-id
```

---

## Report Outputs Generated

| Format | File | Use |
|---|---|---|
| CSV | prowler-output.csv | Data analysis |
| HTML | prowler-output.html | Visual report |
| JSON | prowler-output.json | Integration with other tools |
| OCSF JSON | prowler-output.ocsf.json | Security telemetry standard |

---

## Key Findings

### What Prowler Checks For:
- Storage accounts without encryption
- VMs without disk encryption
- Lack of MFA enforcement
- Overly permissive IAM policies
- Missing diagnostic logging
- Network security misconfigurations
- Key Vault access policies
- Sentinel and monitoring gaps

---

## Why This Matters
Running Prowler demonstrates:
- Understanding of cloud compliance frameworks
- Ability to assess an environment against industry standards
- Business communication skills — results can be formatted as client-ready reports
- Real-world security posture assessment workflow

---

## Report Location
Full Prowler reports are available in the `/output/` folder of this repository in CSV, HTML, and JSON formats.

---

## Next Step
→ See **Part 7 — Azure Sentinel Integration**
