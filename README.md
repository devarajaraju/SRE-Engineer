# SRE-Engineer
Step by step guide to SRE practices
<img width="1472" height="1640" alt="image" src="https://github.com/user-attachments/assets/506f81fe-66f5-4450-8044-913d7a61c111" />
Branch Hierarchy & Flow
<img width="1472" height="920" alt="image" src="https://github.com/user-attachments/assets/f999e844-7796-4984-81a2-5984cc28a032" />

# SRE Engineer — Platform Reliability Repo

This repository contains infrastructure, monitoring, runbooks,
and automation for platform reliability.

## Quick Start

```bash
# Clone the repo
git clone https://github.com/devarajaraju/SRE-Engineer.git
cd SRE-Engineer

# Run smoke tests locally
chmod +x tests/smoke/health_check.sh
BASE_URL=https://api.mycompany.com ./tests/smoke/health_check.sh

# Validate Terraform
cd infra/terraform
terraform init && terraform validate
```

## Structure
| Folder | Purpose |
|---|---|
| `.github/workflows/` | CI/CD pipelines |
| `infra/terraform/` | Infrastructure as Code |
| `docs/runbooks/` | Incident runbooks |
| `monitoring/alerts/` | Prometheus alert rules |
| `tests/smoke/` | Post-deploy smoke tests |


