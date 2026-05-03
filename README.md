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

# 🚀 SRE Engineer Project

> Production-grade Site Reliability Engineering project built on AWS — covering CI/CD, Infrastructure as Code, Containerization, Monitoring, Alerting, and Incident Management.

![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?style=flat&logo=github-actions)
![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?style=flat&logo=terraform)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=flat&logo=docker)
![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5?style=flat&logo=kubernetes)
![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?style=flat&logo=amazon-aws)
![Prometheus](https://img.shields.io/badge/Monitoring-Prometheus-E6522C?style=flat&logo=prometheus)
![Grafana](https://img.shields.io/badge/Dashboards-Grafana-F46800?style=flat&logo=grafana)

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Repository Structure](#-repository-structure)
- [Tech Stack](#-tech-stack)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Infrastructure as Code](#-infrastructure-as-code)
- [Docker and Kubernetes](#-docker-and-kubernetes)
- [Monitoring and Alerting](#-monitoring-and-alerting)
- [Incident Management](#-incident-management)
- [Best Practices](#-best-practices)
- [Issues and Resolutions](#-issues-and-resolutions)
- [Key Commands](#-key-commands)
- [SRE Principles](#-sre-principles)
- [Quick Start](#-quick-start)

---

## 🎯 Project Overview

This project demonstrates a complete SRE workflow from infrastructure provisioning to production monitoring. Built entirely on AWS Free Tier, it covers the full spectrum of modern DevOps and reliability engineering practices.

### What Was Built

| Category | Details |
|---|---|
| **Cloud Infrastructure** | AWS EC2, Elastic IP, Security Groups, IAM, ECR, EKS |
| **Infrastructure as Code** | Terraform modules, remote state, CI/CD integration |
| **CI/CD Pipelines** | GitHub Actions with lint, test, docker build, deploy stages |
| **Containerization** | Docker, AWS ECR, Kubernetes manifests, Helm charts |
| **Monitoring & Alerts** | Prometheus, Node Exporter, Grafana dashboards, Slack alerts |
| **Application** | Python Flask, Gunicorn, Nginx, systemd |
| **Reliability** | Runbooks, post-mortems, smoke tests, incident response |

---

## 🏗️ Architecture

```
Internet
    ↓
AWS EC2 (t3.micro - Free Tier)
    ├── Nginx          (port 80)   ← Reverse proxy
    ├── Flask App      (port 8080) ← Health check API
    ├── Prometheus     (port 9090) ← Metrics collection
    ├── Node Exporter  (port 9100) ← System metrics
    ├── Grafana        (port 3000) ← Dashboards & alerts
    └── Jenkins        (port 9191) ← CI/CD pipeline
            ↓
GitHub Actions CI/CD
    ├── lint → test → docker → deploy
    └── terraform plan → terraform apply
            ↓
AWS ECR → Docker Images
            ↓
AWS EKS → Kubernetes Cluster
    ├── Deployment (2 replicas)
    ├── Service (LoadBalancer)
    └── HPA (auto-scale 2-10 pods)
```

### CI/CD Flow

```
git push → GitHub Actions
    ├── Lint (shell, YAML, Terraform, K8s)
    ├── Smoke Tests
    ├── Docker Build + ECR Push
    ├── Deploy to EC2
    ├── Verify Deployment
    └── Slack Notification (success/failure)
```

---

## 📁 Repository Structure

```
SRE-Engineer/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                  # Main CI/CD pipeline
│   │   └── terraform.yml           # Terraform plan/apply
│   ├── ISSUE_TEMPLATE/
│   │   └── incident.md             # Incident issue template
│   ├── CODEOWNERS                  # Auto-assign reviewers
│   └── pull_request_template.md    # PR checklist
├── src/
│   ├── app.py                      # Flask application
│   ├── requirements.txt            # Python dependencies
│   └── Dockerfile                  # Container image
├── infra/
│   ├── terraform/
│   │   └── environments/staging/
│   │       ├── main.tf             # EC2, SG, EIP
│   │       ├── eks.tf              # EKS cluster + VPC
│   │       ├── variables.tf
│   │       └── outputs.tf
│   ├── k8s/                        # Kubernetes manifests
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── hpa.yaml
│   │   ├── configmap.yaml
│   │   └── namespace.yaml
│   └── helm/sre-app/               # Helm chart
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
├── monitoring/
│   ├── alerts/
│   │   └── slo_alerts.yml          # Prometheus alert rules
│   └── dashboards/                 # Grafana dashboard JSON
├── docs/
│   ├── runbooks/                   # Incident runbooks
│   └── postmortems/                # Post-mortem reports
├── tests/
│   └── smoke/
│       └── health_check.sh         # Smoke test script
├── Jenkinsfile                     # Jenkins pipeline
├── .gitignore
└── README.md
```

---

## 🛠️ Tech Stack

| Tool | Version | Purpose |
|---|---|---|
| Python/Flask | 3.11 / 3.x | Health check API |
| Gunicorn | 21.2.0 | WSGI server |
| Nginx | 1.24 | Reverse proxy |
| Docker | 24.x | Containerization |
| Terraform | 1.5.0 | Infrastructure as Code |
| Kubernetes | 1.28 | Container orchestration |
| Helm | 3.x | K8s package manager |
| Prometheus | 2.45.0 | Metrics collection |
| Grafana | 10.x | Dashboards and alerts |
| Node Exporter | 1.6.0 | System metrics |
| Jenkins | LTS | Enterprise CI/CD |
| GitHub Actions | - | Cloud CI/CD |
| AWS EC2 | t3.micro | Compute |
| AWS ECR | - | Container registry |
| AWS EKS | 1.28 | Managed Kubernetes |

---

## 🔄 CI/CD Pipeline

### Pipeline Stages

```
lint → test → docker → deploy → notify
```

| Stage | Jobs | When |
|---|---|---|
| **lint** | Shell, YAML, Terraform, K8s validation | Every push/PR |
| **test** | Smoke tests against staging URL | After lint |
| **docker** | Build image, push to ECR, scan | Main branch only |
| **deploy** | SCP to EC2, restart service, verify | Main branch only |
| **notify-success** | Slack message with deploy details | After success |
| **notify-failure** | Slack message with log link | After failure |

### Required GitHub Secrets

| Secret | Purpose |
|---|---|
| `EC2_HOST` | EC2 public IP address |
| `EC2_SSH_KEY` | Contents of sre-key.pem |
| `STAGING_URL` | `http://EC2_IP` |
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `SLACK_WEBHOOK_URL` | Slack webhook URL |

### Terraform Pipeline

- Triggers only on changes to `infra/terraform/**`
- Supports `workflow_dispatch` for manual runs
- `terraform plan` runs on every PR with output commented on PR
- `terraform apply` runs on merge to main with production approval gate

---

## 🏛️ Infrastructure as Code

### Resources Provisioned

| Resource | Type | Configuration |
|---|---|---|
| EC2 Instance | `aws_instance` | t3.micro, ami-0ff290337e78c83bf |
| Elastic IP | `aws_eip` | Attached to EC2, persists across restarts |
| Security Group | `aws_security_group` | Ports 22, 80, 443, 3000, 9090 |
| VPC | `aws_vpc` | CIDR 10.0.0.0/16, DNS enabled |
| Subnets | `aws_subnet` | Two public subnets in different AZs |
| EKS Cluster | `aws_eks_cluster` | Kubernetes 1.28 |
| EKS Node Group | `aws_eks_node_group` | t3.micro, min 1 max 3 nodes |

### Usage

```bash
cd infra/terraform/environments/staging

terraform init
terraform plan
terraform apply
terraform destroy   # when done to avoid costs
```

### IAM Permissions Required

```
AmazonEC2FullAccess
AmazonS3FullAccess
AmazonEKSClusterPolicy
AmazonEC2ContainerRegistryFullAccess
IAMFullAccess
```

---

## 🐳 Docker and Kubernetes

### Flask App Endpoints

| Endpoint | Status Code | Purpose |
|---|---|---|
| `/health` | 200 | Liveness check |
| `/ready` | 200 | Readiness check |
| `/metrics` | 200 | App metrics |
| `/admin` | 403 | Blocked endpoint |
| `/debug` | 404 | Blocked endpoint |

### Dockerfile Highlights

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
RUN useradd --no-create-home appuser && chown -R appuser /app
USER appuser                          # Non-root for security
HEALTHCHECK CMD curl -f http://localhost:8080/health || exit 1
CMD ["gunicorn", "--workers", "2", "--bind", "0.0.0.0:8080", "app:app"]
```

### Kubernetes Manifests

| File | Kind | Key Config |
|---|---|---|
| `deployment.yaml` | Deployment | 2 replicas, RollingUpdate, probes |
| `service.yaml` | Service | LoadBalancer, port 80→8080 |
| `hpa.yaml` | HorizontalPodAutoscaler | Min 2, max 10, scale at 70% CPU |
| `configmap.yaml` | ConfigMap | APP_VERSION, ENVIRONMENT |
| `namespace.yaml` | Namespace | Isolated sre namespace |

### Deploy with Helm

```bash
# Install
helm install sre-app infra/helm/sre-app --namespace default

# Upgrade
helm upgrade sre-app infra/helm/sre-app --set image.tag=NEW_TAG

# Rollback
helm rollback sre-app 1

# Uninstall
helm uninstall sre-app
```

### Local Testing with Minikube

```bash
eval $(minikube docker-env)
docker build -t sre-app:latest src/
kubectl apply -f infra/k8s/
kubectl get pods
minikube service sre-app-service --url
```

---

## 📊 Monitoring and Alerting

### Prometheus Targets

| Job | Target | Metrics |
|---|---|---|
| `prometheus` | localhost:9090 | Self-monitoring |
| `sre-app` | localhost:8080 | App health metrics |
| `node_exporter` | localhost:9100 | CPU, memory, disk, network |

### Grafana Dashboard Panels

| Panel | Visualization |
|---|---|
| App Health Status | Stat — green/red |
| CPU Usage % | Time series with thresholds |
| Memory Usage % | Gauge 0-100% |
| Disk Usage % | Gauge with 70%/90% thresholds |
| Network Traffic | Time series (inbound/outbound) |
| System Uptime | Stat with duration |

### Alert Rules

| Alert | Condition | Severity |
|---|---|---|
| AppDown | `up{job="sre-app"} == 0` for 1m | Critical |
| HighErrorRate | Error rate > 5% for 2m | Critical |
| HighCPUUsage | CPU > 85% for 5m | Warning |
| HighMemoryUsage | Memory > 85% for 5m | Warning |
| LowDiskSpace | Disk > 80% for 10m | Warning |

### Access URLs

| Service | URL |
|---|---|
| Flask App | `http://YOUR_EC2_IP/health` |
| Grafana | `http://YOUR_EC2_IP:3000` |
| Prometheus | `http://YOUR_EC2_IP:9090` |
| Jenkins | `http://YOUR_EC2_IP:9191` |

---

## 🚨 Incident Management

### Severity Levels

| Severity | Response Time | Definition |
|---|---|---|
| SEV-1 | 5 minutes | Complete outage or data loss |
| SEV-2 | 30 minutes | Partial degradation |
| SEV-3 | 2 hours | Minor issue with workaround |

### Incident Response Flow

```
Alert fires in Prometheus
    ↓
Grafana sends Slack notification to #sre-alerts
    ↓
On-call engineer acknowledges within SLA
    ↓
Opens GitHub Issue using incident template
    ↓
Follows runbook in docs/runbooks/
    ↓
Triggers incident_response.yml (restart/rollback/diagnostics)
    ↓
Smoke tests verify recovery
    ↓
Blameless post-mortem written in docs/postmortems/
```

### Available Runbooks

| Runbook | Alert |
|---|---|
| `docs/runbooks/app_down.md` | AppDown |
| `docs/runbooks/high_cpu.md` | HighCPUUsage |
| `docs/runbooks/high_memory.md` | HighMemoryUsage |
| `docs/runbooks/high_error_rate.md` | HighErrorRate |
| `docs/runbooks/disk_full.md` | LowDiskSpace |

---

## ✅ Best Practices

### GitHub

- Branch protection on `main` — required reviews, status checks, no force push
- `CODEOWNERS` auto-assigns reviewers by directory
- PR template includes summary, testing, SLO impact, rollback plan
- Semantic commit messages: `feat:`, `fix:`, `chore:`, `docs:`

### AWS Security

- Never use root user access keys — dedicated IAM user with least privilege
- Secrets stored in GitHub Secrets, never hardcoded
- Elastic IP prevents IP changes on restart
- Security group follows principle of least privilege

### Docker

- Slim base image reduces attack surface
- Non-root user in container
- Layer caching via requirements.txt first
- `HEALTHCHECK` for orchestrator integration
- `.dockerignore` excludes unnecessary files

### Kubernetes

- Resource requests and limits on all containers
- Both liveness and readiness probes defined
- `RollingUpdate` with `maxUnavailable: 0` for zero-downtime
- HPA for automatic scaling
- ResourceQuota per namespace

### Terraform

- Remote state with S3 + `use_lockfile`
- All resources tagged for cost tracking
- `terraform fmt` enforced in CI/CD
- `.terraform/` and `*.tfstate` excluded from git

---

## 🐛 Issues and Resolutions

### Git Issues

| Issue | Resolution |
|---|---|
| `fatal: pathspec 'https://github.com/...'` | URL goes in `git remote add`, not `git add` |
| Push rejected — branch behind remote | Run `git pull origin branch` before push |
| `.terraform/` 648MB file rejected by GitHub | Add to `.gitignore`, use `git filter-repo` to remove history |
| Branches have entirely different histories | `git push origin SRE:main --force` |
| `fatal: 'origin' does not appear to be a git repository` | Re-add with `git remote add origin URL` after filter-repo |

### AWS EC2 Issues

| Issue | Resolution |
|---|---|
| `Permission denied (publickey)` | Use correct `.pem` file, `chmod 400`, check current EC2 IP |
| SSH connection timeout from GitHub Actions | Set SSH inbound rule to `0.0.0.0/0` — runner IPs change every run |
| IP changes after EC2 stop/start | Attach Elastic IP — free when attached, never changes |
| Nginx returning 404 | Remove `/etc/nginx/sites-enabled/default`, configure `sre-app` site |

### Flask Application Issues

| Issue | Resolution |
|---|---|
| `gunicorn HaltServer: Worker failed to boot` | Recreate `app.py` with `nano` — heredoc polluted the file |
| `externally-managed-environment` pip error | Use `python3 -m venv venv` and install inside venv |
| `Failed to connect to localhost port 8080` | Check `journalctl -u sre-app`, verify gunicorn path in service file |
| `SyntaxError` — `cat > file << EOF` inside Python | Never use shell heredoc for Python files — use `nano` |

### GitHub Actions Issues

| Issue | Resolution |
|---|---|
| Smoke tests return `000` | Open port 80 inbound to `0.0.0.0/0` in security group |
| `actions/upload-artifact v3` deprecated | Update to `@v4` across all actions |
| `Invalid workflow file — 'on' already defined` | Delete and recreate file, check with `grep -n '^on:\|^env:\|^jobs:'` |
| YAML syntax error — notify job | All jobs under `jobs:` need exactly 2 spaces indent |
| `aws: error parsing --image-id imageT` | Put entire `aws ecr` command on single line, no backslash breaks |
| `terraform fmt` exit code 3 | Run `terraform fmt` locally, commit formatted file |

### Terraform Issues

| Issue | Resolution |
|---|---|
| `profile sre-terraform not found` in CI | Remove `profile` from provider block, use GitHub Secrets for credentials |
| `dynamodb_table is deprecated` | Replace with `use_lockfile = true` |
| `InvalidGroup.Duplicate` security group exists | Import with `terraform import` or use new name |
| `instance type not free tier eligible` | Use `t3.micro` with `ami-0ff290337e78c83bf` |
| `AccessDenied: iam:CreateRole` | Attach `IAMFullAccess` policy to IAM user |

### Docker and Kubernetes Issues

| Issue | Resolution |
|---|---|
| `AccessDeniedException: ecr:CreateRepository` | Attach `AmazonEC2ContainerRegistryFullAccess` to IAM user |
| `SVC_UNREACHABLE — no running pod` | Build with `eval $(minikube docker-env)`, set `imagePullPolicy: Never` |
| `error parsing deployment.yaml — did not find expected key` | Fix indentation — `ports:` must align with other container properties |
| `mapping values not allowed` in deployment.yaml | Remove `---` document separator from top of K8s files |
| `port 8080 already in use` | Kill with `fuser -k 8080/tcp`, run Jenkins on port 9191 |

### Jenkins Issues

| Issue | Resolution |
|---|---|
| `GPG error — public key not available` | Use `curl \| sudo gpg --dearmor` to add key correctly |
| Jenkins not feasible on free tier | t3.micro has insufficient memory — use GitHub Actions instead |
| `container name jenkins already in use` | Run `docker stop jenkins && docker rm jenkins` first |

---

## ⌨️ Key Commands

### Git

```bash
git status
git add . && git commit -m "feat: description" && git push origin main
git commit --allow-empty -m "ci: retrigger pipeline"
git switch -c feature/branch-name
git pull origin main --allow-unrelated-histories
git push origin SRE:main --force
```

### AWS CLI

```bash
aws sts get-caller-identity
aws configure --profile sre-terraform
aws ec2 describe-instances --output table
aws ecr create-repository --repository-name sre-app --region us-east-1
aws eks update-kubeconfig --name sre-staging-cluster --region us-east-1
aws iam attach-user-policy --user-name USER --policy-arn POLICY_ARN
```

### Terraform

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply
terraform destroy
terraform state list
terraform import RESOURCE_TYPE.NAME ID
```

### Kubernetes

```bash
kubectl get pods -o wide
kubectl describe pod POD_NAME
kubectl logs -l app=sre-app --tail=50
kubectl apply -f infra/k8s/
kubectl rollout status deployment/sre-app
kubectl scale deployment sre-app --replicas=3
helm install sre-app infra/helm/sre-app
helm rollback sre-app 1
```

### EC2 Service Management

```bash
sudo systemctl status sre-app
sudo systemctl restart sre-app
sudo systemctl restart nginx
sudo journalctl -u sre-app -n 50
sudo docker ps
sudo docker logs jenkins
```

---

## 📐 SRE Principles

### Four Golden Signals

| Signal | Metric | How Monitored |
|---|---|---|
| **Latency** | Request response time | HTTP response duration histogram |
| **Traffic** | Requests per second | `http_requests_total` counter |
| **Errors** | 5xx response rate | Error % of total traffic |
| **Saturation** | Resource utilization | CPU, memory, disk via Node Exporter |

### SLO Targets

| SLO | Target | Window |
|---|---|---|
| Availability | 99.9% uptime | Rolling 30 days |
| Error rate | < 1% requests return 5xx | Rolling 5 minutes |
| P99 latency | < 200ms for /health | Rolling 5 minutes |
| Deploy success | 100% smoke tests pass | Per deployment |

---

## 🚀 Quick Start

### Prerequisites

```bash
# Mac
brew install terraform kubectl helm eksctl awscli

# Verify
terraform --version && kubectl version --client && helm version
```

### Clone and Setup

```bash
git clone https://github.com/YOUR_USERNAME/SRE-Engineer.git
cd SRE-Engineer
```

### Run Smoke Tests

```bash
chmod +x tests/smoke/health_check.sh
BASE_URL=http://YOUR_EC2_IP ./tests/smoke/health_check.sh
```

### Provision Infrastructure

```bash
cd infra/terraform/environments/staging
terraform init
terraform plan
terraform apply
```

### Deploy to Kubernetes

```bash
eval $(minikube docker-env)
docker build -t sre-app:latest src/
kubectl apply -f infra/k8s/
kubectl get pods
curl $(minikube service sre-app-service --url)/health
```

---

## 📊 Project Progress

| Category | Status |
|---|---|
| GitHub repo + branch protection | ✅ Complete |
| Flask app + Nginx + systemd | ✅ Complete |
| GitHub Actions CI/CD pipeline | ✅ Complete |
| Prometheus + Grafana monitoring | ✅ Complete |
| Runbooks + incident response | ✅ Complete |
| Terraform EC2 + EKS provisioning | ✅ Complete |
| Docker + AWS ECR | ✅ Complete |
| Kubernetes manifests + Helm | ✅ Complete |
| Slack alert notifications | ✅ Complete |
| Jenkins installed (port 9191) | ✅ Complete |

---

## 👤 Author

**SRE Engineer Project**
- GitHub: [YOUR_USERNAME](https://github.com/YOUR_USERNAME)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/YOUR_PROFILE)

---

*Built with ❤️ as a production-grade SRE learning project*
