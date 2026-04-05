#!/usr/bin/env bash
# Creates (or replaces) the branch ruleset for main on this repository.
# Requirements: gh CLI authenticated with a token that has repo admin access.
#
# Usage:
#   ./scripts/setup-branch-ruleset.sh
set -euo pipefail

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
RULESET_NAME="Protect main"

echo "Repository : $REPO"
echo "Ruleset    : $RULESET_NAME"

# ------------------------------------------------------------------
# Delete any existing ruleset with the same name so this is idempotent.
# ------------------------------------------------------------------
EXISTING_ID=$(
  gh api "/repos/${REPO}/rulesets" --jq \
    ".[] | select(.name == \"${RULESET_NAME}\") | .id" 2>/dev/null || true
)

if [ -n "$EXISTING_ID" ]; then
  echo "Found existing ruleset (id=$EXISTING_ID) — deleting..."
  gh api --method DELETE "/repos/${REPO}/rulesets/${EXISTING_ID}"
fi

# ------------------------------------------------------------------
# Create the ruleset.
# ------------------------------------------------------------------
echo "Creating ruleset..."

gh api \
  --method POST \
  "/repos/${REPO}/rulesets" \
  --input - <<'JSON'
{
  "name": "Protect main",
  "target": "branch",
  "enforcement": "active",

  "bypass_actors": [
    {
      "actor_id": 5,
      "actor_type": "RepositoryRole",
      "bypass_mode": "always"
    }
  ],

  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },

  "rules": [
    {
      "type": "deletion"
    },
    {
      "type": "non_fast_forward"
    },
    {
      "type": "required_linear_history"
    },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": true,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": false,
        "required_status_checks": [
          { "context": "Validate" }
        ]
      }
    }
  ]
}
JSON

echo "Done."
