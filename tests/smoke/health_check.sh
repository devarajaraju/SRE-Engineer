#!/bin/bash
# Smoke test: verify core endpoints are healthy after deployment

set -e  # Exit immediately on any failure

BASE_URL="${BASE_URL:-https://api.mycompany.com}"
TIMEOUT=10
PASS=0
FAIL=0

check() {
  local name="$1"
  local url="$2"
  local expected_status="$3"

  actual_status=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time "$TIMEOUT" "$url")

  if [ "$actual_status" -eq "$expected_status" ]; then
    echo "PASS: $name ($url) returned $actual_status"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $name ($url) returned $actual_status (expected $expected_status)"
    FAIL=$((FAIL + 1))
  fi
}

echo "Running smoke tests against: $BASE_URL"
echo "----------------------------------------"

# Core health checks
check "Health endpoint"   "$BASE_URL/health"       200
check "Readiness probe"   "$BASE_URL/ready"         200
check "Metrics endpoint"  "$BASE_URL/metrics"       200
check "API v1 status"     "$BASE_URL/api/v1/status" 200

# Negative checks — these should NOT be publicly accessible
check "Admin blocked"     "$BASE_URL/admin"         403
check "Debug blocked"     "$BASE_URL/debug"         404

echo "----------------------------------------"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  echo "SMOKE TESTS FAILED — deployment may be unhealthy"
  exit 1
else
  echo "All smoke tests passed"
  exit 0
fi
