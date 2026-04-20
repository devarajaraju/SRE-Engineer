#!/bin/bash
# Smoke test: verify core endpoints are healthy

set -e

BASE_URL="${BASE_URL:-}"
TIMEOUT=10
PASS=0
FAIL=0

# Exit early if no URL is set
if [ -z "$BASE_URL" ]; then
  echo "WARNING: BASE_URL is not set. Skipping smoke tests."
  echo "Usage: BASE_URL=http://your-url ./tests/smoke/health_check.sh"
  exit 0
fi

check() {
  local name="$1"
  local url="$2"
  local expected_status="$3"

  actual_status=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time "$TIMEOUT" "$url" 2>/dev/null || echo "000")

  if [ "$actual_status" -eq "$expected_status" ]; then
    echo "PASS: $name returned $actual_status"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $name returned $actual_status (expected $expected_status)"
    FAIL=$((FAIL + 1))
  fi
}

echo "Running smoke tests against: $BASE_URL"
echo "----------------------------------------"

check "Health endpoint"  "$BASE_URL/health"   200
check "Readiness probe"  "$BASE_URL/ready"    200
check "Metrics endpoint" "$BASE_URL/metrics"  200
check "Admin blocked"    "$BASE_URL/admin"    403
check "Debug blocked"    "$BASE_URL/debug"    404

echo "----------------------------------------"
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  echo "SMOKE TESTS FAILED"
  exit 1
else
  echo "All smoke tests passed"
  exit 0
fi
