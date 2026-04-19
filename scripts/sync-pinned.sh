#!/usr/bin/env bash
# scripts/sync-pinned.sh
#
# Regenerate the currently_building section of README.md from the
# owner's GitHub pinned repositories.
#
# Usage:
#   scripts/sync-pinned.sh               # live: queries GitHub GraphQL via `gh`
#   PINNED_FIXTURE=path/to.json scripts/sync-pinned.sh   # test: read fixture
#
# Requires: bash, jq, sed. For live mode also `gh` (authenticated).

set -euo pipefail

README="${README_PATH:-README.md}"
START_MARKER='<!-- pinned:start -->'
END_MARKER='<!-- pinned:end -->'

GRAPHQL_QUERY='{
  viewer {
    pinnedItems(first: 6, types: REPOSITORY) {
      nodes {
        ... on Repository {
          name
          description
          homepageUrl
          url
          isArchived
          pushedAt
          languages(first: 3, orderBy: {field: SIZE, direction: DESC}) {
            nodes { name }
          }
        }
      }
    }
  }
}'

if [[ -n "${PINNED_FIXTURE:-}" ]]; then
  raw="$(cat "$PINNED_FIXTURE")"
else
  raw="$(gh api graphql -f query="$GRAPHQL_QUERY")"
fi

# Derive status: archived -> archived, pushed in last 90d -> running in production, else in development
now_epoch="$(date -u +%s)"
ninety_days_ago=$(( now_epoch - 90 * 86400 ))

# Build the TypeScript block in a temp file.
tmp_block="$(mktemp)"
trap 'rm -f "$tmp_block"' EXIT

{
  echo '```typescript'
  echo '// ───────────────────────────────────────────'
  echo '// § currently_building'
  echo '// ───────────────────────────────────────────'
  echo ''
  echo 'const projects: Project[] = ['
} >> "$tmp_block"

echo "$raw" | jq -r --argjson cutoff "$ninety_days_ago" '
  .data.viewer.pinnedItems.nodes[]
  | {
      name,
      description: (.description // "(no description)"),
      homepageUrl,
      url,
      isArchived,
      pushed: (.pushedAt | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601),
      langs: [.languages.nodes[].name]
    }
  | {
      name,
      desc: .description,
      stack: .langs,
      status: (
        if .isArchived then "archived"
        elif .pushed >= $cutoff then "running in production"
        else "in development"
        end
      ),
      url: (if .homepageUrl and .homepageUrl != "" then .homepageUrl else .url end)
    }
  | "  {\n    name:   \"\(.name)\",\n    desc:   \"\(.desc)\",\n    stack:  \(.stack | tojson),\n    status: \"\(.status)\",\n    url:    \"\(.url)\",\n  },"
' >> "$tmp_block"

{
  echo ']'
  echo '```'
} >> "$tmp_block"

# Rewrite the marker region of the README in-place.
awk -v block_file="$tmp_block" -v start="$START_MARKER" -v end="$END_MARKER" '
  BEGIN {
    while ((getline line < block_file) > 0) block = block (block ? "\n" : "") line
    close(block_file)
    inside = 0
  }
  $0 == start {
    print
    print block
    inside = 1
    next
  }
  $0 == end {
    inside = 0
    print
    next
  }
  !inside { print }
' "$README" > "$README.new"

mv "$README.new" "$README"

echo "Updated $README between $START_MARKER and $END_MARKER."
