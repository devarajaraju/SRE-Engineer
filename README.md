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

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 1 of
SRE Project
Complete Study Material
Best Practices, Architecture, Issues &amp; Resolutions

Technologies Covered

Category Technologies
Cloud Infrastructure AWS EC2, Elastic IP, Security Groups, IAM, ECR, EKS
Infrastructure as Code Terraform, Modules, Remote State, CI/CD Integration
CI/CD Pipelines GitHub Actions, Jenkins, Docker Build, ECR Push
Containerization Docker, Dockerfile, AWS ECR, Kubernetes, Helm
Monitoring &amp; Alerts Prometheus, Node Exporter, Grafana, Slack Alerts
Application Python Flask, Gunicorn, Nginx, systemd
Reliability Runbooks, Post-mortems, Smoke Tests, Incident Response
Source Control GitHub, Branch Protection, CODEOWNERS, PR Templates

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 2 of

1. Project Overview
This document covers the complete SRE project built from scratch, including architecture decisions,
implementation details, best practices, and real issues encountered along with their resolutions.

1.1 Project Goal
Build a production-grade Site Reliability Engineering project on AWS that demonstrates:
• End-to-end CI/CD pipeline from code commit to production deployment
• Infrastructure as Code using Terraform for repeatable provisioning
• Container-based deployment with Docker and Kubernetes
• Real-time monitoring and alerting with Prometheus and Grafana
• Incident management with runbooks, post-mortems, and smoke tests
• Security best practices with IAM least privilege and branch protection

1.2 Architecture Overview

Component Technology Purpose
Application Python Flask +
Gunicorn

Health check API with /health, /ready, /metrics
endpoints

Web Server Nginx Reverse proxy on port 80, forwards to Flask on

8080

Cloud Host AWS EC2 t3.micro Free-tier eligible compute instance
Container Registry AWS ECR Stores Docker images for deployment
Orchestration Kubernetes + Helm Container orchestration with auto-scaling
IaC Terraform Provisions EC2, VPC, Security Groups, EKS
CI/CD GitHub Actions Automated lint, test, build, deploy pipeline
Monitoring Prometheus + Grafana Metrics collection and visualization
Alerting Grafana + Slack Real-time incident notifications
Process Manager systemd Auto-restarts Flask app on EC2

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 3 of

2. Repository Structure
The GitHub repository follows a structured layout that separates concerns clearly:
SRE-Engineer/
├── .github/
│ ├── workflows/
│ │ ├── ci.yml # Main CI/CD pipeline
│ │ └── terraform.yml # Terraform plan/apply pipeline
│ ├── ISSUE_TEMPLATE/
│ │ └── incident.md # Incident issue template
│ ├── CODEOWNERS # Auto-assign reviewers
│ └── pull_request_template.md
├── src/
│ ├── app.py # Flask application
│ ├── requirements.txt # Python dependencies
│ └── Dockerfile # Container image definition
├── infra/
│ ├── terraform/
│ │ └── environments/staging/
│ │ ├── main.tf # EC2, Security Group, EIP
│ │ ├── eks.tf # EKS cluster, VPC, nodes
│ │ ├── variables.tf
│ │ └── outputs.tf
│ ├── k8s/ # Kubernetes manifests
│ │ ├── deployment.yaml
│ │ ├── service.yaml
│ │ ├── hpa.yaml
│ │ ├── configmap.yaml
│ │ └── namespace.yaml
│ └── helm/sre-app/ # Helm chart
│ ├── Chart.yaml
│ ├── values.yaml
│ └── templates/
├── monitoring/
│ ├── alerts/
│ │ └── slo_alerts.yml # Prometheus alert rules
│ └── dashboards/ # Grafana dashboard JSON
├── docs/
│ ├── runbooks/ # Incident runbooks
│ └── postmortems/ # Post-mortem reports
├── tests/
│ └── smoke/
│ └── health_check.sh # Smoke test script

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 4 of

├── Jenkinsfile # Jenkins pipeline
├── .gitignore
└── README.md

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 5 of

3. Flask Application
3.1 Application Endpoints

Endpoint Method Status Code Purpose
/health GET 200 Liveness check - is the app running?
/ready GET 200 Readiness check - is the app ready for traffic?
/metrics GET 200 Basic app metrics for monitoring
/admin GET 403 Blocked endpoint - returns forbidden
/debug GET 404 Blocked endpoint - returns not found

3.2 Deployment Stack
The Flask app runs on EC2 with the following process hierarchy:
Internet → Nginx (port 80) → Gunicorn (port 8080) → Flask app
• Nginx acts as a reverse proxy and handles SSL termination
• Gunicorn runs with 2 workers for concurrent request handling
• systemd manages the process lifecycle and auto-restarts on failure
• Virtual environment (venv) isolates Python dependencies

3.3 Best Practices Applied
• Non-root user in Dockerfile for security
• Health check defined in Dockerfile for container orchestration
• Requirements pinned to specific versions for reproducibility
• Environment variables used for configuration, not hardcoded values

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 6 of

4. CI/CD Pipeline
4.1 GitHub Actions Pipeline Stages
The CI/CD pipeline runs automatically on every push to main and staging branches. The pipeline has 6
stages that run sequentially:

Stage Jobs When Runs Purpose
1. lint Shell lint, YAML lint,
Terraform validate, K8s
validate

Every push/PR Catch syntax errors early

2. test Smoke tests against
staging URL

After lint passes Verify app endpoints respond correctly

3. docker Build image, push to
ECR, scan for
vulnerabilities

Main branch only Package app as container

4. deploy SCP files to EC2,
restart service, verify
deployment

Main branch only Deploy to staging server

5. notify-
success

Send Slack message
with deploy details

After deploy
succeeds

Alert team of success

6. notify-
failure

Send Slack message
with log link

After deploy fails Alert team of failure

4.2 Required GitHub Secrets

Secret Name Value Used In
EC2_HOST EC2 public IP address deploy job - SSH connection
EC2_SSH_KEY Contents of sre-key.pem deploy job - SSH authentication
STAGING_URL http://EC2_IP test job - smoke test target
AWS_ACCESS_KEY_I
D

IAM user access key docker + terraform jobs

AWS_SECRET_ACCE
SS_KEY

IAM user secret key docker + terraform jobs

SLACK_WEBHOOK_U
RL

Slack webhook URL notify jobs - Slack messages

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 7 of

4.3 Terraform CI/CD Pipeline
A separate workflow handles Infrastructure as Code changes:
• Triggers only when files under infra/terraform/** change
• Supports manual workflow_dispatch trigger for on-demand runs
• terraform plan runs on every PR and comments the plan output
• terraform apply runs on merge to main with production environment approval gate

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 8 of

5. Terraform Infrastructure as Code
5.1 Resources Provisioned

Resource Type Configuration
EC2 Instance aws_instance t3.micro, ami-0ff290337e78c83bf, sre-key pair
Elastic IP aws_eip Attached to EC2, persists across restarts
Security Group aws_security_group Ports 22, 80, 443, 3000, 9090 open
VPC aws_vpc CIDR 10.0.0.0/16, DNS enabled
Subnets aws_subnet Two public subnets in different AZs
Internet Gateway aws_internet_gateway Enables public internet access
EKS Cluster aws_eks_cluster Kubernetes 1.28, sre-staging-cluster
EKS Node Group aws_eks_node_group t3.micro nodes, min 1 max 3

5.2 Best Practices
• Profile removed from provider block for CI/CD compatibility - credentials injected via
environment variables
• Remote state stored in S3 with use_lockfile for state locking (dynamodb_table is deprecated)
• Resources tagged with Name, Environment, ManagedBy, Team for cost allocation
• Separate files for main.tf, variables.tf, outputs.tf, eks.tf for maintainability
• terraform fmt enforced in CI/CD to maintain consistent formatting
• .terraform/ directory excluded from git via .gitignore

5.3 IAM Permissions Required
The sre-terraform-user IAM user requires these policies:
• AmazonEC2FullAccess - for EC2, security groups, VPC
• AmazonS3FullAccess - for Terraform remote state
• AmazonEKSClusterPolicy - for EKS cluster creation
• AmazonEC2ContainerRegistryFullAccess - for ECR operations
• IAMFullAccess - for creating EKS IAM roles

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 9 of

6. Docker and Kubernetes
6.1 Docker Image
The Flask app is containerized using a multi-layer Dockerfile optimized for size and security:
FROM python:3.11-slim # Minimal base image
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt # Cached layer
COPY app.py .
RUN useradd --no-create-home appuser &amp;&amp; chown -R appuser /app
USER appuser # Non-root for security
HEALTHCHECK CMD curl -f http://localhost:8080/health || exit 1
CMD [&quot;gunicorn&quot;, &quot;--workers&quot;, &quot;2&quot;, &quot;--bind&quot;, &quot;0.0.0.0:8080&quot;, &quot;app:app&quot;]

6.2 Kubernetes Manifests

File Kind Key Configuration
deployment.yaml Deployment 2 replicas, RollingUpdate, liveness/readiness

probes

service.yaml Service LoadBalancer type, port 80 -&gt; 8080
hpa.yaml HorizontalPodAutoscale

r

Min 2, max 10 pods, scale at 70% CPU
configmap.yaml ConfigMap APP_VERSION, ENVIRONMENT, LOG_LEVEL
namespace.yaml Namespace Isolated sre namespace
resourcequota.yaml ResourceQuota CPU 2/4, Memory 2Gi/4Gi limits

6.3 Helm Chart
The Kubernetes manifests are packaged as a Helm chart for reusable deployments across
environments:
• values.yaml contains all configurable parameters
• Templates use Go template syntax for dynamic values
• HPA template conditionally rendered with {{- if .Values.autoscaling.enabled }}
• helm upgrade --install enables idempotent deployments
• helm rollback provides instant rollback to previous release

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 10 of

7. Monitoring and Alerting
7.1 Prometheus Configuration
Prometheus scrapes metrics from three targets every 15 seconds:

Job Target Metrics Collected
prometheus localhost:9090 Prometheus self-monitoring metrics
sre-app localhost:8080 Flask app health and custom metrics
node_exporter localhost:9100 CPU, memory, disk, network system metrics

7.2 Grafana Dashboard Panels

Panel Query Visualization
App Health Status up{job=&quot;sre-app&quot;} Stat with green/red value mapping
CPU Usage % 100 -

(avg(rate(node_cpu_seconds_total
{mode=&quot;idle&quot;}[5m])) * 100)

Time series with thresholds

Memory Usage % (node_memory_MemTotal_bytes -
node_memory_MemAvailable_byt
es) /
node_memory_MemTotal_bytes *
100

Gauge 0-100%

Disk Usage % 100 -

(node_filesystem_avail_bytes /
node_filesystem_size_bytes * 100)

Gauge with 70%/90% thresholds

Network Traffic rate(node_network_receive_bytes

_total[5m])

Time series, dual query
inbound/outbound

System Uptime node_time_seconds -
node_boot_time_seconds

Stat with duration unit

7.3 Alert Rules

Alert Name Condition Severity Runbook
AppDown up{job=&quot;sre-app&quot;} == 0

for 1m

Critical docs/runbooks/app_down.md

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 11 of

HighErrorRate error rate &gt; 5% for 2m Critical docs/runbooks/high_error_rate.m

d

HighCPUUsage CPU &gt; 85% for 5m Warning docs/runbooks/high_cpu.md
HighMemoryUsage Memory &gt; 85% for 5m Warning docs/runbooks/high_memory.md
LowDiskSpace Disk &gt; 80% for 10m Warning docs/runbooks/disk_full.md

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 12 of

8. Incident Management
8.1 Severity Levels

Severity Response Time Definition Example
SEV-1 5 minutes Complete service outage or

data loss

App completely down, all health
checks failing

SEV-2 30 minutes Partial degradation affecting

users

Error rate above 5%, latency
above 2 seconds

SEV-3 2 hours Minor issue with workaround

available

Single endpoint slow, non-critical
alert firing

8.2 Incident Response Flow
When an alert fires in Grafana or Prometheus, the following steps are taken:
Alert fires in Prometheus
↓
Grafana sends notification to Slack #sre-alerts channel
↓
On-call engineer acknowledges within SLA time
↓
Opens GitHub Issue using incident template
↓
Follows runbook in docs/runbooks/
↓
Triggers incident_response.yml workflow if needed
(Options: restart-app, rollback-deploy, run-diagnostics)
↓
Smoke tests verify recovery automatically
↓
Write blameless post-mortem in docs/postmortems/

8.3 Runbook Structure
Each runbook in docs/runbooks/ follows this standard format:
• Alert name, severity, and affected server at the top
• Symptoms section describing what the user sees
• Diagnosis steps with exact commands to run

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 13 of
• Remediation options ordered from fastest to most invasive
• Escalation path with names and contact details
• Links to related dashboards and post-mortems

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 14 of

9. Best Practices
9.1 GitHub Best Practices

Practice Implementation Benefit
Branch protection Required PR reviews, status
checks, no force push on main

Prevents broken code reaching
production

CODEOWNERS .github/CODEOWNERS maps
paths to team owners

Auto-assigns correct reviewers

PR templates Checklist with summary, testing,
SLO impact, rollback plan

Consistent, thorough change reviews

Issue templates Incident template with timeline

and checklist

Structured incident tracking

.gitignore Excludes .terraform/, *.tfstate,
venv/, __pycache__

Prevents secrets and binaries in repo
Semantic commits feat:, fix:, chore:, docs: prefixes Clear change history and changelogs

9.2 AWS Security Best Practices
• Never use root user access keys - create dedicated IAM users with least privilege
• Use IAM roles for EC2 instances instead of storing credentials on the server
• Use OIDC for GitHub Actions instead of long-lived access keys
• Store secrets in GitHub Secrets, never hardcode in code or config files
• Elastic IP prevents IP changes on instance restart, critical for stable DNS
• Security group rules follow principle of least privilege

9.3 Docker Best Practices
• Use slim base images to reduce attack surface and image size
• Run containers as non-root users for security
• Copy requirements.txt before source code to leverage layer caching
• Add HEALTHCHECK instruction so orchestrators know when container is ready
• Use .dockerignore to exclude unnecessary files from build context
• Pin base image versions for reproducible builds

9.4 Kubernetes Best Practices

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 15 of
• Always define resource requests and limits to prevent noisy neighbors
• Use both liveness and readiness probes for proper traffic management
• Set RollingUpdate strategy with maxUnavailable=0 for zero-downtime deployments
• Use HPA for auto-scaling based on CPU and memory metrics
• Define ResourceQuota per namespace to prevent resource exhaustion
• Use ConfigMaps for non-sensitive configuration, Secrets for sensitive data

9.5 Terraform Best Practices
• Use remote state with locking to prevent concurrent modifications
• Tag all resources for cost tracking and resource identification
• Separate files by concern: main.tf, variables.tf, outputs.tf
• Run terraform fmt in CI/CD to enforce consistent formatting
• Use data sources instead of hardcoded AMI IDs for portability
• Never commit .terraform/ directory or .tfstate files to git

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 16 of

10. Issues Faced and Resolutions
10.1 GitHub and Git Issues

Issue Root Cause Resolution
fatal: pathspec
&#39;https://github.com/...&#39; did not
match any files

Passed URL to git add
instead of file path

Use git add . for files, URL only goes
in git remote add or git clone

error: failed to push - tip of
branch is behind remote

Remote has commits not in
local branch

Run git pull origin branch before git
push

Large file rejected -
.terraform/ provider binary
648MB

Accidentally committed
.terraform/ directory

Add .terraform/ to .gitignore, use git
filter-repo to remove from history

main and SRE branches
have entirely different
histories

Branches created
independently without
common ancestor

Use git push origin SRE:main --force
to make SRE the new main

fatal: &#39;origin&#39; does not appear
to be a git repository

git filter-repo removes remote
configuration

Re-add with git remote add origin
https://USERNAME:TOKEN@github.
com/repo.git

10.2 AWS EC2 Issues

Issue Root Cause Resolution
Permission denied
(publickey) on SSH

Wrong key file name or
wrong IP after restart

Use correct .pem file, check current
IP in EC2 console, chmod 400 key

Error establishing SSH
connection

Security group blocking port
22 or instance stopped

Start instance, add SSH inbound rule
0.0.0.0/0, try EC2 Instance Connect

Connection timeout on port
22 from GitHub Actions

Security group only allows
My IP, not GitHub runner IPs

Set SSH inbound rule source to
0.0.0.0/0 for CI/CD to work

New IP generated after EC2
stop/start

No Elastic IP attached Attach Elastic IP - free when attached
to running instance, IP never changes

curl http://IP/health returns
404 Not Found

Nginx not configured or
default site enabled

Remove /etc/nginx/sites-
enabled/default, create correct sre-
app config

10.3 Flask Application Issues

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 17 of
Issue Root Cause Resolution
gunicorn.errors.HaltServer:
Worker failed to boot

SyntaxError in app.py from
heredoc pollution

Recreate app.py using nano editor,
not cat &lt;&lt; EOF command

error: externally-managed-
environment for pip install

Ubuntu 22.04+ protects
system Python

Create virtual environment with
python3 -m venv venv, use
venv/bin/pip

Failed to connect to localhost
port 8080

sre-app.service not created
or failed to start

Check journalctl -u sre-app, verify
gunicorn path in service file is correct

SyntaxError: invalid syntax -
cat &gt; file &lt;&lt; EOF

Shell heredoc command
written inside Python file

Never use cat EOF in terminal for
Python files, use nano instead

systemd service Unit not
found

Service file created in wrong
location or not loaded

Create in /etc/systemd/system/, run
daemon-reload, then enable and start

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 18 of

10.4 GitHub Actions Pipeline Issues

Issue Root Cause Resolution
Smoke tests return 000 -
connection refused

GitHub Actions runner IP
blocked by security group

Open port 80 inbound to 0.0.0.0/0 in
security group

actions/upload-artifact
deprecated v3 error

Using deprecated version of
GitHub Action

Update all action versions:
checkout@v4, upload-artifact@v4,
configure-aws-credentials@v4

Invalid workflow file - &#39;on&#39;
already defined

Duplicate on:, env:, jobs:
sections in YAML

Delete and recreate file with nano,
verify with grep -n &#39;^on:\|^env:\|^jobs:&#39;

YAML syntax error on line
207

notify-success job missing 2-
space indentation

All jobs under jobs: must have exactly
2 spaces indent

aws: error parsing parameter
--image-id imageT

Line continuation backslash
breaking CLI parameter

Put entire aws ecr command on
single line without backslash breaks

Terraform fmt exit code 3 Formatting errors in main.tf -

wrong indentation

Run terraform fmt locally to auto-fix,
then commit the formatted file

10.5 Terraform Issues

Issue Root Cause Resolution
No valid credential sources -
profile sre-terraform not
found

Local AWS profile not
available in GitHub Actions
environment

Remove profile from provider block,
use AWS_ACCESS_KEY_ID and
AWS_SECRET_ACCESS_KEY
secrets

The parameter
dynamodb_table is
deprecated

AWS provider updated - old
parameter name

Replace dynamodb_table with
use_lockfile = true in backend block

InvalidGroup.Duplicate -
security group already exists

Terraform trying to create
existing security group

Import with terraform import or use
new name like sre-staging-sg-tf-v2

InvalidParameterCombination
- instance type not free tier

AMI ami-0c7217cdde317cfec
not eligible for t2.micro

Use ami-0ff290337e78c83bf with
t3.micro for free tier

Error: resource address does
not exist in configuration

Ran terraform import before
adding resource block

Add the resource block to main.tf first,
then run terraform import

AccessDenied:
iam:CreateRole not
authorized

sre-terraform-user missing
IAM permissions

Attach IAMFullAccess policy to the
IAM user

10.6 Docker and ECR Issues

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 19 of
Issue Root Cause Resolution
AccessDeniedException:
ecr:CreateRepository not
authorized

sre-terraform-user missing
ECR permissions

Attach
AmazonEC2ContainerRegistryFullAc
cess policy to IAM user

Exiting due to
SVC_UNREACHABLE - no
running pod for service

Pods in ImagePullBackOff
state - cannot pull ECR
image in Minikube

Build image locally with eval
$(minikube docker-env) and set
imagePullPolicy: Never

error parsing
deployment.yaml - did not
find expected key

Wrong indentation on ports:
field (7 spaces instead of 10)

Fix indentation - ports: must align with
other container properties

deployment.yaml mapping
values not allowed error

Leading --- document
separator causing YAML
parser issues

Remove --- from top of K8s manifest
files

docker: port 8080 address
already in use

Another process (Jenkins
service) already using port
8080

Kill with fuser -k 8080/tcp or run
Jenkins on different port 9191

10.7 Jenkins Issues

Issue Root Cause Resolution
GPG error - public key not
available for Jenkins apt repo

Jenkins GPG key added
incorrectly with wget instead
of curl+gpg

Use curl | sudo gpg --dearmor to
properly add the key

Jenkins pipeline not feasible
on free tier EC2

t3.micro insufficient memory
for Jenkins + Docker + builds

Use Docker-in-Docker approach or
skip Jenkins on free tier, use GitHub
Actions instead

Container name jenkins
already in use

Previous Docker container
still exists

Run docker stop jenkins and docker
rm jenkins before creating new
container

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 20 of

11. Key Commands Reference
11.1 Git Commands

Command Purpose
git status Check staged/unstaged changes
git add . &amp;&amp; git commit -m &#39;msg&#39; &amp;&amp; git push origin
main

Stage, commit, push all changes
git commit --allow-empty -m &#39;ci: retrigger&#39; Retrigger CI pipeline without code change
git switch -c feature/branch-name Create and switch to new branch
git pull origin main --allow-unrelated-histories Merge branches with different histories
git push origin SRE:main --force Make SRE branch the new main branch
git remote set-url origin
https://USER:TOKEN@github.com/repo.git

Update remote URL with credentials

11.2 AWS CLI Commands

Command Purpose
aws sts get-caller-identity Verify AWS credentials are working
aws configure --profile sre-terraform Configure named AWS profile
aws ec2 describe-instances --output table List EC2 instances in table format
aws ecr create-repository --repository-name sre-
app

Create ECR container registry

aws ecr get-login-password | docker login --
username AWS --password-stdin ECR_URI

Login to ECR for Docker push

aws eks update-kubeconfig --name sre-staging-
cluster --region us-east-1

Configure kubectl for EKS cluster

aws iam attach-user-policy --user-name USER --
policy-arn POLICY_ARN

Attach IAM policy to user

11.3 Terraform Commands

Command Purpose

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 21 of
terraform init Initialize providers and backend
terraform validate Check configuration syntax
terraform fmt Auto-format all .tf files
terraform plan Preview changes before applying
terraform apply Create/update infrastructure
terraform destroy Destroy all managed infrastructure
terraform state list List all resources in state
terraform import RESOURCE_TYPE.NAME ID Import existing resource into state

11.4 Kubernetes Commands

Command Purpose
kubectl get pods -o wide List pods with node and IP details
kubectl describe pod POD_NAME Full pod details including events
kubectl logs -l app=sre-app --tail=50 View logs from all matching pods
kubectl apply -f infra/k8s/ Apply all manifests in directory
kubectl rollout status deployment/sre-app Watch deployment rollout progress
kubectl scale deployment sre-app --replicas=3 Manually scale deployment
helm install sre-app infra/helm/sre-app Deploy Helm chart
helm rollback sre-app 1 Rollback to previous Helm release

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 22 of

12. SRE Principles Applied
12.1 The Four Golden Signals
This project monitors all four golden signals defined by Google SRE:

Signal What It Measures How Monitored in This Project
Latency Time to serve a request HTTP response time via Prometheus histogram
Traffic Demand on the system Request rate via http_requests_total counter
Errors Rate of failed requests 5xx response rate as percentage of total traffic
Saturation How full the service is CPU, memory, disk usage via Node Exporter

12.2 SLO and Error Budget
Service Level Objectives defined for this project:

SLO Target Measurement Window
Availability 99.9% uptime Rolling 30 days
Error rate &lt; 1% of requests return 5xx Rolling 5 minutes
P99 latency &lt; 200ms for /health endpoint Rolling 5 minutes
Deployment success 100% smoke tests pass Per deployment

12.3 Toil Reduction
Manual toil was reduced through automation throughout the project:
• Auto-deploy on git push eliminates manual deployment steps
• Smoke tests run automatically after every deployment
• Prometheus alerts fire automatically when thresholds breached
• Terraform provisions infrastructure reproducibly without manual AWS console steps
• GitHub Actions handles all CI tasks without manual intervention
• systemd auto-restarts Flask app on crash without human intervention

12.4 Blameless Post-mortems
Post-mortems stored in docs/postmortems/ follow blameless culture:

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 23 of

• Focus on systems and processes, not individuals
• Timeline reconstructed from logs and monitoring data
• Root cause analysis identifies contributing factors
• Action items assigned to fix systemic issues
• Lessons learned shared with the team

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 24 of

13. Interview Preparation
13.1 Common SRE Interview Questions

Question Key Points to Cover
Explain your CI/CD pipeline lint → test → docker build → ECR push → EC2 deploy → smoke
test → Slack notify. Automated on push, manual approval for
terraform apply

How do you handle incidents? Severity levels, runbooks, GitHub Issues for tracking, post-
mortems, Slack alerts, incident_response.yml workflow for
automated remediation

What is an SLO and error budget? SLO = target reliability percentage. Error budget = allowed
downtime. When budget exhausted, freeze feature work until
reliability restored

Explain Infrastructure as Code Terraform manages all AWS resources. State in S3. Plan in CI
on PR, apply on merge. Reproducible, version controlled, peer
reviewed

How do you monitor your
services?

Prometheus scrapes metrics every 15s. Grafana visualizes
golden signals. Alerts fire to Slack. Node Exporter for system
metrics

What is your rollback strategy? helm rollback for K8s, git revert + push for code, terraform apply

previous state for infra. Smoke tests verify recovery
How do you manage secrets? GitHub Secrets for CI/CD, no secrets in code, IAM roles
preferred over access keys, Vault for production

13.2 Project Highlights for Resume

Achievement Technologies
Built end-to-end CI/CD pipeline with
automated testing and deployment

GitHub Actions, Docker, AWS ECR, EC2

Provisioned cloud infrastructure as code
with remote state management

Terraform, AWS S3, EKS, VPC

Deployed containerized application to
Kubernetes with auto-scaling

Docker, AWS EKS, Helm, HPA

Implemented real-time monitoring with
custom dashboards and alerting

Prometheus, Grafana, Slack, Node Exporter

Built incident management system with
runbooks and post-mortems

GitHub Issues, GitHub Actions workflows

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 25 of

Resolved 30+ real-world DevOps and SRE
issues during implementation

All technologies above

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 26 of

14. Final Project Checklist

Category Item Status
Repository GitHub repo with branch protection Done
Repository CODEOWNERS and PR templates Done
Repository Directory structure with placeholders Done
Application Flask app with health endpoints Done
Application Nginx reverse proxy configured Done
Application systemd service with auto-restart Done
Application Dockerfile with non-root user Done
CI/CD GitHub Actions lint stage Done
CI/CD Automated smoke tests Done
CI/CD Docker build and ECR push Done
CI/CD Auto-deploy to EC2 on merge Done
CI/CD Terraform plan/apply pipeline Done
CI/CD Slack success/failure notifications Done
Monitoring Prometheus with Node Exporter Done
Monitoring Grafana dashboards (6 panels) Done
Monitoring Alert rules for critical conditions Done
Monitoring Grafana Slack contact point Done
IaC Terraform EC2 + security group + EIP Done
IaC Terraform EKS cluster + node group Done
IaC IAM user with least privilege Done
Containers Docker image in AWS ECR Done
Containers Kubernetes manifests (all types) Done
Containers Helm chart with values.yaml Done
Containers Minikube local testing Done
Reliability Runbooks for all alert conditions Done
Reliability Post-mortem template Done
Reliability Incident response workflow Done
Jenkins Jenkins installed on EC2 port 9191 Done

SRE Project Study Material | Complete Guide &amp; Best Practices

Site Reliability Engineering Project | Page 27 of
Jenkins Jenkinsfile pipeline defined Done
Profile LinkedIn updated with GitHub link Done

Congratulations! You have built a production-grade SRE project covering the full
spectrum of modern DevOps and reliability engineering practices.
