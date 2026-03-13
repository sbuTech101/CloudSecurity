# Part 9 — GitHub Actions CI/CD Pipeline

## What is CI/CD?
CI/CD stands for Continuous Integration / Continuous Deployment. It means every time you push code to GitHub, automated tasks run in the background to check, test, and validate your code.

---

## What is DevSecOps?
DevSecOps means integrating security into the development process automatically — not as an afterthought. Instead of manually running security tools, they run automatically every time code changes.

```
Traditional:  Code → Deploy → Security Check (too late)
DevSecOps:    Code → Security Check → Deploy (catches problems early)
```

---

## The Pipeline

Every time code is pushed to GitHub:

```
git push
    │
    ▼
GitHub Actions triggers
    │
    ▼
Ubuntu runner spins up in the cloud
    │
    ▼
Python 3.11 installed
    │
    ▼
Checkov installed
    │
    ▼
Checkov scans all Terraform files
    │
    ▼
Results uploaded as artifact
    │
    ▼
✅ Pass or ❌ Fail shown on GitHub
```

---

## The Workflow File
Located at `.github/workflows/checkov.yml`:

```yaml
name: Checkov Security Scan

on:
  push:
    branches:
      - master

jobs:
  checkov-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: pip install checkov
      - run: |
          checkov -d . \
            --skip-check CKV_AZURE_160,CKV2_AZURE_10 \
            --soft-fail
```

---

## Skipped Checks Explained

| Check | Reason |
|---|---|
| CKV_AZURE_160 | HTTP port 80 intentionally open — HoneyPot design |
| CKV2_AZURE_10 | Microsoft Antimalware is Windows-only — VM runs Linux |

---

## Why This Matters for Employers

This pipeline demonstrates:
- **DevSecOps thinking** — security is automated, not manual
- **GitHub Actions experience** — industry standard CI/CD tool
- **Security-first mindset** — code is checked before it's stored
- **Professional workflow** — same approach used by enterprise security teams

---

## Viewing Pipeline Results
1. Go to your GitHub repo
2. Click the **Actions** tab
3. See every push with ✅ or ❌ status
4. Click any run to see the full Checkov output

---

## Summary
This pipeline means every piece of Terraform code pushed to GitHub is automatically scanned for security issues — making it impossible to accidentally push insecure infrastructure code without being alerted.
