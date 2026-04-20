# Runbook: App Down

**Alert:** AppDown
**Severity:** SEV-1
**Server:** 3.80.93.142

## Symptoms
- Health endpoint returning non-200
- Smoke tests failing
- Users cannot access the service

## Diagnosis
```bash
# SSH into server
ssh -i sre-key.pem ubuntu@3.80.93.142

# Check app status
sudo systemctl status sre-app

# Check app logs
sudo journalctl -u sre-app -n 50

# Check if port is listening
sudo ss -tlnp | grep 8080
```

## Remediation

### Step 1: Restart the app
```bash
sudo systemctl restart sre-app
curl http://localhost:8080/health
```

### Step 2: If restart fails, check nginx
```bash
sudo systemctl restart nginx
sudo nginx -t
```

### Step 3: If still down, redeploy
```bash
cd /home/ubuntu/sre-app
source venv/bin/activate
gunicorn --workers 2 --bind 0.0.0.0:8080 app:app
```

## Escalation
- Not resolved in 15 min → escalate to SRE Lead
