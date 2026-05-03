# Slack Alert Configuration

## Webhook Channel
- Channel: #sre-alerts
- Bot name: Grafana SRE Bot

## Alert Rules
| Alert | Condition | Severity |
|---|---|---|
| App Down | up < 1 for 2m | Critical |
| High CPU | cpu > 85% for 5m | Warning |
| High Memory | memory > 85% for 5m | Warning |
| Low Disk | disk > 80% for 10m | Warning |

## Notification Policy
- Group wait: 30s
- Group interval: 5m
- Repeat interval: 4h
