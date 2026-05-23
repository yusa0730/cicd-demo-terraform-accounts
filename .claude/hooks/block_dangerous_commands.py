#!/usr/bin/env python3
"""
Pre-tool hook: blocks dangerous shell commands before Claude executes them.
Accounts repo manages security baseline — GuardDuty/CloudTrail/Config disable is critical.
"""
import json
import sys

try:
    payload = json.load(sys.stdin)
except Exception:
    sys.exit(0)

command = payload.get("tool_input", {}).get("command", "")

BLOCKED_PATTERNS = [
    ("terraform apply", "Use CI/CD pipeline for apply operations"),
    ("terraform destroy", "Account baseline destruction requires explicit authorization"),
    ("terraform state rm", "Manual state removal requires explicit authorization"),
    ("terraform state push", "Manual state push requires explicit authorization"),
    ("terraform state mv", "Manual state move requires explicit authorization"),
    ("terraform force-unlock", "Force unlock requires explicit authorization"),
    ("aws guardduty delete-detector", "GuardDuty deletion violates security baseline"),
    ("aws cloudtrail delete-trail", "CloudTrail deletion violates security baseline"),
    ("aws securityhub disable-security-hub", "Security Hub disable violates security baseline"),
    ("aws configservice delete-configuration-recorder", "Config deletion violates security baseline"),
    ("aws iam delete-role", "IAM role deletion requires explicit authorization"),
    ("aws s3 rb", "S3 bucket removal requires explicit authorization"),
    ("git push --force", "Force push is not allowed"),
    ("git push -f ", "Force push is not allowed"),
    ("git reset --hard", "Hard reset discards uncommitted work"),
]

for pattern, reason in BLOCKED_PATTERNS:
    if pattern in command:
        print(
            json.dumps({
                "decision": "block",
                "reason": f"Blocked: '{pattern}' — {reason}."
            })
        )
        sys.exit(2)

sys.exit(0)
