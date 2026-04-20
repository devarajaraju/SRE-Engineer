# Runbook: High Memory Usage

**Alert:** HighMemoryUsage
**Severity:** SEV-2
**Server:** 3.80.93.142

## Symptoms
- Memory above 85% for 5+ minutes
- Possible OOM kills

## Diagnosis
```bash
# SSH into server
ssh -i sre-key.pem ubuntu@3.80.93.142

# Check memory usage
free -h

# Check which process uses most memory
ps aux --sort=-%mem | head -10

# Check for OOM kills
sudo dmesg | grep -i oom
```

## Remediation

### Step 1: Restart the app
```bash
sudo systemctl restart sre-app
```

### Step 2: Clear system cache
```bash
sudo sync
sudo echo 3 > /proc/sys/vm/drop_caches
```

## Escalation
- Not resolved in 30 min → escalate to SRE Lead
