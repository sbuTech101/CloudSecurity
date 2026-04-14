# Part 7 — Azure Sentinel Integration

## What is Microsoft Sentinel?
Microsoft Sentinel is Azure's cloud-native SIEM (Security Information and Event Management) tool. It collects security data from across your environment, detects threats, and helps SOC analysts investigate and respond to incidents.

---

##Why Sentinel for This Project?
- Captures all attack data from the HoneyPot VM in real time
- Provides a central dashboard for the SOC team to analyse threats
- Enables alert rules to notify when specific attack patterns are detected
- Industry standard tool used by enterprise SOC teams globally

---

## Architecture

```
HoneyPot VM (tpot-vm)
       │
       │ Syslog (LOG_WARNING+)
       ▼
Log Analytics Workspace (tpot-logs)
       │
       │ Data ingestion
       ▼
Microsoft Sentinel
       │
       │ Alerts & Incidents
       ▼
SOC Team (Alice, Bob, Carol)
```

---

## Deployment Steps

### Step 1 — Create Log Analytics Workspace
1. Azure Portal → Log Analytics Workspaces → Create
2. Resource Group: tpot-resources
3. Name: tpot-logs
4. Region: South Africa North

### Step 2 — Deploy Microsoft Sentinel
1. Azure Portal → Microsoft Sentinel → Create
2. Select tpot-logs workspace
3. Click Add

### Step 3 — Install Syslog Connector
1. Sentinel → Content Hub → Search "Syslog via AMA"
2. Install connector

### Step 4 — Create Data Collection Rule
1. Sentinel → Data Connectors → Syslog → Open Connector Page
2. Create data collection rule: tpot-collection-rule
3. Add resource: tpot-vm
4. Log levels: LOG_WARNING (cost efficient — captures attacks without noise)

---

## Log Levels Explained

| Level | What it Captures | Cost |
|---|---|---|
| LOG_DEBUG | Everything | High |
| LOG_WARNING | Warnings and above | Low |
| LOG_ERROR | Errors only | Minimal |

**We chose LOG_WARNING** — captures attack attempts and security events without flooding Sentinel with normal system noise.

---

## Verifying the Connection
Once the VM is running, query Sentinel logs:
```kql
Syslog
| take 10
```

A successful result shows real syslog entries from the HoneyPot VM flowing into Sentinel.

---

## SOC Team Access
Each team member has appropriate Sentinel access via RBAC:

| User | Sentinel Role | Can Do |
|---|---|---|
| Alice Admin | Sentinel Contributor | Manage everything in Sentinel |
| Bob Analyst | Sentinel Responder | Investigate and respond to incidents |
| Carol Viewer | Sentinel Reader | View dashboards and reports only |

---

## Next Step
→ See **Part 8 — Key Vault Secret Management**
