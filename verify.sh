#!/usr/bin/env bash
# Usage: ./verify.sh YYYY-MM-DD
#
# Re-computes the Merkle root from the day's details JSON and compares
# against the line in public_roots.txt. Exits:
#   0  match — claims hold
#   1  MISMATCH — ledger or public_roots.txt was modified after publication
#   2  missing data — date not yet published or details file absent
#
# This is the third-party verifier referenced by gammapulse.tech.
# Anyone, anywhere, can clone the repo and run it.
set -euo pipefail

DATE="${1:-}"
if [ -z "$DATE" ]; then
    echo "usage: $0 YYYY-MM-DD" >&2
    exit 2
fi

ROOTS_FILE="public_roots.txt"
DETAILS_FILE="details/${DATE}.json"

if [ ! -f "$ROOTS_FILE" ]; then
    echo "missing $ROOTS_FILE" >&2
    exit 2
fi
if [ ! -f "$DETAILS_FILE" ]; then
    echo "missing $DETAILS_FILE" >&2
    exit 2
fi

CLAIMED=$(awk -v d="$DATE" '$1==d {print $2; exit}' "$ROOTS_FILE")
if [ -z "$CLAIMED" ]; then
    echo "no entry for $DATE in $ROOTS_FILE" >&2
    exit 2
fi

RECOMPUTED=$(python3 - "$DETAILS_FILE" <<'PYEOF'
import sys, json, hashlib
d = json.load(open(sys.argv[1]))
leaves = (d.get("signal_leaves") or []) + (d.get("outcome_leaves") or [])
if not leaves:
    print(hashlib.sha256(b"GENESIS").hexdigest())
    raise SystemExit
level = [bytes.fromhex(h) for h in leaves]
while len(level) > 1:
    if len(level) % 2:
        level.append(level[-1])
    level = [hashlib.sha256(level[i] + level[i + 1]).digest()
             for i in range(0, len(level), 2)]
print(level[0].hex())
PYEOF
)

if [ "$CLAIMED" = "$RECOMPUTED" ]; then
    echo "OK $DATE  $CLAIMED"
    exit 0
fi
echo "MISMATCH $DATE"
echo "  claimed:    $CLAIMED"
echo "  recomputed: $RECOMPUTED"
exit 1
