# Runbook: High CPU Usage

**Alert:** HighCPUUsage
**Severity:** SEV-2
**Server:** 3.80.93.142

## Symptoms
- CPU above 85% for 5+ minutes
- App response times increasing

## Diagnosis
```bash
# SSH into server
ssh -i sre-key.pem ubuntu@3.80.93.142

# Check CPU usage
top

# Check which process is using CPU
ps aux --sort=-%cpu | head -10

# Check app logs for errors
sudo journalctl -u sre-app -n 50
```

## Remediation

### Step 1: Restart the app
```bash
sudo systemctl restart sre-app
```

### Step 2: If CPU stays high, reboot instance
```bash
sudo reboot
```

## Escalation
- Not resolved in 30 min → escalate to SRE Lead# Runbook: High CPU Usage

**Alert:** `HighCPUUsage`
**Severity:** SEV-2
**Team:** SRE On-Call
**Last updated:** 2024-03-15

---

## Symptoms
- CPU usage above 85% for more than 5 minutes
- Application response times increasing
- PagerDuty alert triggered from `slo_alerts.yaml`

---

## Diagnosis

### Step 1: Identify the affected host
```bash
# Check which nodes have high CPU
kubectl top nodes

# Check which pods are consuming the most CPU
kubectl top pods --all-namespaces --sort-by=cpu
```

### Step 2: Check recent deployments
```bash
# Was anything deployed in the last 30 minutes?
kubectl rollout history deployment/my-service
```

### Step 3: Check application logs
```bash
# Look for errors or unusual activity
kubectl logs -l app=my-service --tail=100 | grep -i error
```

---

## Remediation

### Option A: Scale up the deployment (fastest fix)
```bash
kubectl scale deployment my-service --replicas=5
```

### Option B: Roll back if caused by a bad deploy
```bash
kubectl rollout undo deployment/my-service
```

### Option C: Restart pods if stuck in bad state
```bash
kubectl rollout restart deployment/my-service
```

---

## Escalation
- Not resolved in 15 min → escalate to **Engineering Lead**
- Data loss risk → escalate to **VP Engineering**

---

## Related
- [Dashboard](https://grafana.mycompany.com/cpu)
- [SLO Policy](../policies/slo_policy.md)
- [Post-mortem: 2024-01-10 CPU spike](../postmortems/2024-01-10-cpu-spike.md)
