# ball46 Profile README Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the auto-generated GitHub profile README at [ball46/ball46](https://github.com/ball46/ball46) with a hand-crafted TypeScript-type-file style profile backed by two maintenance workflows (daily timestamp refresh + dynamic pinned-projects sync).

**Architecture:** Static `README.md` carries the IDE-style content. Two GitHub Actions keep it live: one bumps a `last_updated` footer daily via cron; the other regenerates the `currently_building` project array from the owner's GitHub pinned repos via GraphQL. The pinned section is delimited by HTML comment markers so the sync workflow can target just that region without touching the rest.

**Tech Stack:** Markdown + embedded TypeScript code blocks (GitHub syntax highlighting), `github-readme-stats` + `github-readme-activity-graph` + `readme-typing-svg` (external widget services, `catppuccin_mocha` theme), GitHub Actions (YAML), `gh api graphql` + `jq` + `sed` (bash-based pinned sync — no Python runtime needed).

---

## File Structure

- **Create:** `.github/workflows/update-timestamp.yml` — daily cron that rewrites the footer date.
- **Create:** `.github/workflows/sync-pinned.yml` — weekly cron + push trigger that regenerates the pinned projects array.
- **Create:** `scripts/sync-pinned.sh` — bash script that queries GitHub GraphQL for pinned repos and rewrites the marker region in `README.md`. Called by both local testing and the workflow.
- **Create:** `scripts/fixtures/pinned-sample.json` — static GraphQL response fixture used for local testing without hitting the live API.
- **Create:** `scripts/test-sync-pinned.sh` — runs `sync-pinned.sh` against the fixture and diffs the result against a golden expected output.
- **Create:** `scripts/fixtures/pinned-expected.md` — golden expected output of running `sync-pinned.sh` on the fixture.
- **Modify:** `README.md` — complete rewrite per spec sections 6.1–6.9. Only the region inside `<!-- pinned:start -->` / `<!-- pinned:end -->` will later be touched by the sync workflow; all other sections are static.

No changes to `.gitignore` or any other config file are required.

---

## Task 0: Create feature branch and verify baseline

**Files:** none modified

- [ ] **Step 0.1: Confirm you are in the repo**

```bash
cd /root/ball46-profile
pwd
git status
```

Expected: `/root/ball46-profile` + `On branch main ... working tree clean`.

- [ ] **Step 0.2: Create feature branch from main**

```bash
git checkout -b feat/profile-redesign-v1
```

Expected: `Switched to a new branch 'feat/profile-redesign-v1'`.

- [ ] **Step 0.3: Verify pre-redesign backup tag exists**

```bash
git tag -l pre-redesign-backup
```

Expected: `pre-redesign-backup` (one line). If missing, abort and create it: `git tag pre-redesign-backup main~1` (pointing at the commit before the spec commit).

---

## Task 1: Verify all external widget URLs return valid SVG

Widgets are served by third-party services. Before committing them to the README, confirm every URL responds with an SVG so a dead service doesn't land in the final profile.

**Files:** none modified

- [ ] **Step 1.1: Test the typewriter header**

```bash
curl -sSI 'https://readme-typing-svg.demolab.com?font=JetBrains+Mono&size=28&pause=1000&color=CBA6F7&center=true&vCenter=true&width=600&lines=interface+Ball46+%7B;ship+%E2%80%A2+run+%E2%80%A2+translate;%2F%2F+currently%3A+trade-journal+v2' | grep -Ei 'HTTP|content-type'
```

Expected: `HTTP/... 200` and `content-type: image/svg+xml`.

- [ ] **Step 1.2: Test the stats card**

```bash
curl -sSI 'https://github-readme-stats.vercel.app/api?username=ball46&show_icons=true&theme=catppuccin_mocha&hide_border=true&count_private=true&include_all_commits=true' | grep -Ei 'HTTP|content-type'
```

Expected: `HTTP/... 200` and `content-type: image/svg+xml`.

- [ ] **Step 1.3: Test the top-languages card**

```bash
curl -sSI 'https://github-readme-stats.vercel.app/api/top-langs/?username=ball46&layout=compact&theme=catppuccin_mocha&hide_border=true&langs_count=8' | grep -Ei 'HTTP|content-type'
```

Expected: `HTTP/... 200` and `content-type: image/svg+xml`.

- [ ] **Step 1.4: Test the activity graph**

```bash
curl -sSI 'https://github-readme-activity-graph.vercel.app/graph?username=ball46&theme=github-compact&bg_color=1e1e2e&color=cba6f7&line=cba6f7&point=f5e0dc&hide_border=true' | grep -Ei 'HTTP|content-type'
```

Expected: `HTTP/... 200` and `content-type: image/svg+xml`.

- [ ] **Step 1.5: If any widget fails, STOP and report**

If any curl above returns non-200 or wrong content-type, stop implementation. Either the service is down (try again later) or the URL is wrong (re-read spec §6.7 and fix). Do not commit a dead URL.

No commit for Task 1 — this is verification only.

---

## Task 2: Write new README.md (static sections only)

Replace the entire README with the new design. The `currently_building` region is wrapped in `<!-- pinned:start -->` / `<!-- pinned:end -->` markers and seeded with the initial 3 projects from the spec; the sync workflow will later rewrite this region automatically.

**Files:**
- Modify: `README.md` (complete rewrite)

- [ ] **Step 2.1: Back up the existing README by inspecting it**

```bash
wc -l README.md && head -1 README.md
```

Expected: `26 README.md` and `<h1 align="center">Hi 👋, I'm Charnchol Panusupairun</h1>`. This confirms you are about to replace the old template.

- [ ] **Step 2.2: Write the complete new README.md**

Write the file in one shot. Paste this exact content into `README.md`:

````markdown
<p align="center">
  <a href="https://github.com/ball46">
    <img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&size=28&pause=1000&color=CBA6F7&center=true&vCenter=true&width=600&lines=interface+Ball46+%7B;ship+%E2%80%A2+run+%E2%80%A2+translate;%2F%2F+currently%3A+trade-journal+v2" alt="ball46" />
  </a>
</p>

```typescript
/**
 * ball46.d.ts
 * ─────────────────────────────────────────────────
 * Full-stack engineer in Bangkok who runs the
 * servers his products live on.
 *
 * I build things to understand them. The things I
 * build tend to be the ones I actually needed —
 * a trading journal I couldn't find, an Obsidian
 * sync nobody would host for me, a crontab editor
 * I got tired of vimming into.
 *
 * Also: I translate between users who don't speak
 * code and developers who don't speak user.
 * ─────────────────────────────────────────────────
 */

interface Ball46 {
  readonly name:     "Charnchol Panusupairun"
  readonly handle:   "ball46"
  readonly role:     "full-stack engineer" & "sysadmin of one"
  readonly location: "Bangkok, Thailand (UTC+7)"
  readonly speaks:   ["Thai", "English", "TypeScript", "Python", "Go"]
  readonly bridges:  ["non-technical users", "developers"]

  currently_building:  Project[]
  stack_in_production: Service[]
  principles:          readonly string[]
}
```

<!-- pinned:start -->
```typescript
// ───────────────────────────────────────────
// § currently_building
// ───────────────────────────────────────────

const projects: Project[] = [
  {
    name:   "trade-journal",
    desc:   "MT5 analytics I built because I couldn't find one I'd use",
    stack:  ["FastAPI", "PostgreSQL", "Next.js", "Casdoor"],
    status: "running in production",
    url:    "journal.mysiteonly.tech",
  },
  {
    name:   "claude-agent-monitor",
    desc:   "Live dashboard for Claude Code agent activity across sessions",
    stack:  ["TypeScript", "React", "SSE"],
    status: "in design",
  },
  {
    name:   "yaos",
    desc:   "Self-hosted Obsidian sync on Cloudflare Workers",
    stack:  ["TypeScript", "Cloudflare Workers"],
    status: "running in production",
  },
]
```
<!-- pinned:end -->

```typescript
// ───────────────────────────────────────────
// § stack_in_production
//   One VPS. Everything below lives on it.
// ───────────────────────────────────────────

const infra: Service[] = [
  { name: "nginx",       role: "reverse proxy + TLS termination" },
  { name: "Docker",      role: "container runtime" },
  { name: "PostgreSQL",  role: "primary datastore" },
  { name: "Casdoor",     role: "SSO / identity provider" },
  { name: "Casbin",      role: "authorization / RBAC" },
  { name: "Loki",        role: "log aggregation" },
  { name: "Grafana",     role: "dashboards" },
  { name: "Uptime Kuma", role: "service monitoring" },
  { name: "SOPS",        role: "secrets management" },
]
```

```typescript
// ───────────────────────────────────────────
// § principles
// ───────────────────────────────────────────

const principles = [
  "build the thing you need — nothing more, until you need more",
  "own the servers your product runs on",
  "fix root causes, never symptoms",
  "security is never a 'later' ticket",
  "automate anything you've done twice",
  "the best feedback loop is talking to the user",
] as const
```

```typescript
// ───────────────────────────────────────────
// § runtime_metrics
//   computed from github — live values
// ───────────────────────────────────────────
```

<a href="https://github.com/ball46">
  <img align="left" height="180em"
       src="https://github-readme-stats.vercel.app/api?username=ball46&show_icons=true&theme=catppuccin_mocha&hide_border=true&count_private=true&include_all_commits=true" alt="ball46 stats" />
</a>
<a href="https://github.com/ball46">
  <img align="left" height="180em"
       src="https://github-readme-stats.vercel.app/api/top-langs/?username=ball46&layout=compact&theme=catppuccin_mocha&hide_border=true&langs_count=8" alt="ball46 top languages" />
</a>

<br clear="both" />
<br />

<img src="https://github-readme-activity-graph.vercel.app/graph?username=ball46&theme=github-compact&bg_color=1e1e2e&color=cba6f7&line=cba6f7&point=f5e0dc&hide_border=true" alt="ball46 activity graph" />

```typescript
// ───────────────────────────────────────────
// § contact
// ───────────────────────────────────────────

const contact = {
  email:     "khunball46@gmail.com",
  github:    "https://github.com/ball46",
  instagram: "https://instagram.com/khunball46",

  // broken in the previous README — left empty pending URL verification
  linkedin:  null,
  facebook:  null,
  discord:   null,
} as const
```

```typescript
// ───────────────────────────────────────────
// EOF — ball46.d.ts
// last_updated: 2026-04-16
// ───────────────────────────────────────────
```
````

- [ ] **Step 2.3: Verify file was written correctly**

```bash
wc -l README.md
grep -c 'pinned:start' README.md
grep -c 'pinned:end' README.md
grep -c 'last_updated: 2026-04-16' README.md
```

Expected: line count > 120, each grep count = 1.

- [ ] **Step 2.4: Commit**

```bash
git add README.md
git commit -m "feat: rewrite profile README as TypeScript type-file

Replaces the 2023 auto-generated template with an IDE-style
README built as a ball46.d.ts type declaration. Adds pinned
markers and catppuccin_mocha widgets per design spec §6.

Design: docs/superpowers/specs/2026-04-16-ball46-profile-redesign-design.md"
```

Expected: 1 file changed.

---

## Task 3: Create the daily timestamp workflow

**Files:**
- Create: `.github/workflows/update-timestamp.yml`

- [ ] **Step 3.1: Create the workflow directory**

```bash
mkdir -p .github/workflows
```

- [ ] **Step 3.2: Write the workflow file**

Create `.github/workflows/update-timestamp.yml` with exactly this content:

```yaml
name: Update last_updated timestamp

on:
  schedule:
    - cron: '7 0 * * *'   # daily at 00:07 UTC
  workflow_dispatch:

permissions:
  contents: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Rewrite timestamp line
        run: |
          today=$(date -u +%Y-%m-%d)
          sed -i -E "s/last_updated: [0-9]{4}-[0-9]{2}-[0-9]{2}/last_updated: ${today}/" README.md

      - name: Commit if changed
        run: |
          if git diff --quiet README.md; then
            echo "No timestamp change — nothing to commit."
            exit 0
          fi
          git config user.name  "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git add README.md
          git commit -m "chore: refresh last_updated timestamp"
          git push
```

- [ ] **Step 3.3: Validate YAML locally**

```bash
python3 -c "import yaml, sys; yaml.safe_load(open('.github/workflows/update-timestamp.yml'))" && echo OK
```

Expected: `OK`. If YAML is invalid, fix and re-run.

- [ ] **Step 3.4: Dry-run the sed command locally against README.md**

```bash
today=$(date -u +%Y-%m-%d)
sed -E "s/last_updated: [0-9]{4}-[0-9]{2}-[0-9]{2}/last_updated: ${today}/" README.md | grep 'last_updated:'
```

Expected: one line showing `last_updated: <today>`. This proves the regex matches the exact line in README.md.

- [ ] **Step 3.5: Commit**

```bash
git add .github/workflows/update-timestamp.yml
git commit -m "ci: add daily workflow to refresh README last_updated footer"
```

Expected: 1 file changed.

---

## Task 4: Create the pinned-sync bash script

This script queries GitHub GraphQL for the owner's pinned items, renders them as a TypeScript `Project[]` array, and rewrites the region of `README.md` between the `<!-- pinned:start -->` and `<!-- pinned:end -->` markers.

**Files:**
- Create: `scripts/sync-pinned.sh`

- [ ] **Step 4.1: Create the scripts directory**

```bash
mkdir -p scripts
```

- [ ] **Step 4.2: Write the sync-pinned script**

Create `scripts/sync-pinned.sh` with exactly this content:

```bash
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
```

- [ ] **Step 4.3: Make the script executable**

```bash
chmod +x scripts/sync-pinned.sh
```

- [ ] **Step 4.4: Shellcheck the script (if available)**

```bash
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck scripts/sync-pinned.sh && echo "shellcheck OK"
else
  echo "shellcheck not installed — skipping lint"
fi
```

Expected: either `shellcheck OK` or `skipping lint`.

- [ ] **Step 4.5: Commit**

```bash
git add scripts/sync-pinned.sh
git commit -m "feat: add sync-pinned.sh to regenerate currently_building section"
```

Expected: 1 file changed, script created.

---

## Task 5: Create a fixture and test the sync-pinned script

Test the script deterministically using a fixture JSON file (no network). The fixture mirrors the shape of `gh api graphql`'s response so the script's logic can be validated in isolation.

**Files:**
- Create: `scripts/fixtures/pinned-sample.json`
- Create: `scripts/fixtures/pinned-expected.md`
- Create: `scripts/test-sync-pinned.sh`

- [ ] **Step 5.1: Create the fixtures directory**

```bash
mkdir -p scripts/fixtures
```

- [ ] **Step 5.2: Write the fixture JSON**

Create `scripts/fixtures/pinned-sample.json` with exactly this content. `pushedAt` values are chosen relative to the reference date `2026-04-16T00:00:00Z`: `trade-journal` was pushed 10 days ago (= running in production), `vintage-lib` was pushed 200 days ago (= in development), `old-thing` is archived.

```json
{
  "data": {
    "viewer": {
      "pinnedItems": {
        "nodes": [
          {
            "name": "trade-journal",
            "description": "MT5 analytics I built because I couldn't find one I'd use",
            "homepageUrl": "https://journal.mysiteonly.tech",
            "url": "https://github.com/ball46/trade-journal",
            "isArchived": false,
            "pushedAt": "2026-04-06T12:00:00Z",
            "languages": {
              "nodes": [
                { "name": "Python" },
                { "name": "TypeScript" },
                { "name": "CSS" }
              ]
            }
          },
          {
            "name": "vintage-lib",
            "description": "An experiment from a while back",
            "homepageUrl": "",
            "url": "https://github.com/ball46/vintage-lib",
            "isArchived": false,
            "pushedAt": "2025-09-28T00:00:00Z",
            "languages": {
              "nodes": [
                { "name": "Go" },
                { "name": "Makefile" }
              ]
            }
          },
          {
            "name": "old-thing",
            "description": "Archived reference project",
            "homepageUrl": "",
            "url": "https://github.com/ball46/old-thing",
            "isArchived": true,
            "pushedAt": "2024-01-01T00:00:00Z",
            "languages": {
              "nodes": [
                { "name": "C" }
              ]
            }
          }
        ]
      }
    }
  }
}
```

- [ ] **Step 5.3: Create a minimal README-under-test with the markers**

This step builds a temporary README snippet just for the test. The test script (next step) will copy it into place, run the sync, and diff the result.

```bash
cat > scripts/fixtures/readme-before.md <<'EOF'
# test readme

some content above

<!-- pinned:start -->
OLD CONTENT TO BE REPLACED
<!-- pinned:end -->

some content below
EOF
```

- [ ] **Step 5.4: Write the expected golden output**

Create `scripts/fixtures/pinned-expected.md` with exactly this content:

````markdown
# test readme

some content above

<!-- pinned:start -->
```typescript
// ───────────────────────────────────────────
// § currently_building
// ───────────────────────────────────────────

const projects: Project[] = [
  {
    name:   "trade-journal",
    desc:   "MT5 analytics I built because I couldn't find one I'd use",
    stack:  ["Python","TypeScript","CSS"],
    status: "running in production",
    url:    "https://journal.mysiteonly.tech",
  },
  {
    name:   "vintage-lib",
    desc:   "An experiment from a while back",
    stack:  ["Go","Makefile"],
    status: "in development",
    url:    "https://github.com/ball46/vintage-lib",
  },
  {
    name:   "old-thing",
    desc:   "Archived reference project",
    stack:  ["C"],
    status: "archived",
    url:    "https://github.com/ball46/old-thing",
  },
]
```
<!-- pinned:end -->

some content below
````

**Note on dates:** the golden file assumes the test runs before `2026-07-05` (otherwise `trade-journal` would no longer be within the 90-day window). Task 5.5 overrides the current time to make the test deterministic.

- [ ] **Step 5.5: Write the test runner script**

Create `scripts/test-sync-pinned.sh` with exactly this content:

```bash
#!/usr/bin/env bash
# scripts/test-sync-pinned.sh
#
# Deterministic test: runs sync-pinned.sh against the fixture and diffs
# the resulting README against the golden expected file.

set -euo pipefail

cd "$(dirname "$0")/.."

# Work in a temp dir so we don't touch the real README.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cp scripts/fixtures/readme-before.md "$tmp_dir/README.md"

# Pin "now" so the status logic is deterministic regardless of when
# the test runs. We do this by faketime if available, otherwise we
# warn and continue (the fixture dates are far enough apart that
# boundaries are only crossed quarterly).
if command -v faketime >/dev/null 2>&1; then
  FAKE_CMD=(faketime '2026-04-16 12:00:00')
else
  echo "warning: faketime not installed; using real system clock" >&2
  FAKE_CMD=()
fi

PINNED_FIXTURE="$(pwd)/scripts/fixtures/pinned-sample.json" \
README_PATH="$tmp_dir/README.md" \
  "${FAKE_CMD[@]}" bash scripts/sync-pinned.sh

if diff -u scripts/fixtures/pinned-expected.md "$tmp_dir/README.md"; then
  echo "PASS: sync-pinned.sh output matches golden file."
else
  echo "FAIL: output differs from golden file." >&2
  exit 1
fi
```

- [ ] **Step 5.6: Make it executable**

```bash
chmod +x scripts/test-sync-pinned.sh
```

- [ ] **Step 5.7: Run the test**

```bash
./scripts/test-sync-pinned.sh
```

Expected: `PASS: sync-pinned.sh output matches golden file.` If it fails, the diff will be printed — compare the `+` and `-` lines; the fault is almost always in `sync-pinned.sh`'s `jq` expression (Task 4.2) or in the expected golden file (Step 5.4). Fix whichever is wrong and rerun.

- [ ] **Step 5.8: Commit**

```bash
git add scripts/fixtures/ scripts/test-sync-pinned.sh
git commit -m "test: add fixture-based test for sync-pinned.sh"
```

Expected: 4 files changed (3 fixture files + test script).

---

## Task 6: Create the sync-pinned GitHub workflow

**Files:**
- Create: `.github/workflows/sync-pinned.yml`

- [ ] **Step 6.1: Write the workflow file**

Create `.github/workflows/sync-pinned.yml` with exactly this content:

```yaml
name: Sync pinned projects

on:
  schedule:
    - cron: '23 4 * * 1'   # weekly, Monday 04:23 UTC
  workflow_dispatch:
  push:
    branches: [main]
    paths:
      - 'scripts/sync-pinned.sh'
      - '.github/workflows/sync-pinned.yml'

permissions:
  contents: write

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Install jq
        run: sudo apt-get update && sudo apt-get install -y jq

      - name: Run sync-pinned.sh
        env:
          GH_TOKEN: ${{ secrets.PINNED_PAT || secrets.GITHUB_TOKEN }}
        run: bash scripts/sync-pinned.sh

      - name: Commit if changed
        run: |
          if git diff --quiet README.md; then
            echo "No pinned changes — nothing to commit."
            exit 0
          fi
          git config user.name  "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git add README.md
          git commit -m "chore: sync currently_building from pinned repos"
          git push
```

**Note on `GH_TOKEN`:** the default `GITHUB_TOKEN` can read public repo data including pinned items on public users. If the owner's pinned set includes any private repos, add a fine-grained PAT with `read:user` + `repo` scopes as repo secret `PINNED_PAT`. The workflow falls back to `GITHUB_TOKEN` if `PINNED_PAT` is unset.

- [ ] **Step 6.2: Validate YAML**

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/sync-pinned.yml'))" && echo OK
```

Expected: `OK`.

- [ ] **Step 6.3: Commit**

```bash
git add .github/workflows/sync-pinned.yml
git commit -m "ci: add weekly sync-pinned workflow

Runs scripts/sync-pinned.sh on a weekly cron and on pushes
that touch the script or workflow. Uses PINNED_PAT if set,
falls back to GITHUB_TOKEN for public pinned data."
```

Expected: 1 file changed.

---

## Task 7: Push the feature branch and preview on GitHub

**Files:** none modified locally; publishing to remote.

- [ ] **Step 7.1: Review local commit history**

```bash
git log --oneline main..HEAD
```

Expected: 5 commits from Tasks 2, 3, 4, 5, 6 (in that order). If commits are missing, go back and re-run the missing task.

- [ ] **Step 7.2: Push the feature branch**

```bash
git push -u origin feat/profile-redesign-v1
```

Expected: push succeeds. Report the pushed branch to the user.

- [ ] **Step 7.3: Verify the preview**

Ask the user to open `https://github.com/ball46/ball46/blob/feat/profile-redesign-v1/README.md?plain=0` in a browser and confirm:

1. Typewriter banner renders at the top.
2. TypeScript code blocks display with syntax highlighting.
3. Stats card + top-languages card sit side-by-side (may stack on narrow viewports — acceptable).
4. Activity graph fills the width below.
5. `last_updated: 2026-04-16` appears in the footer.

Do NOT merge until the user confirms visual correctness.

- [ ] **Step 7.4: If the preview looks wrong, iterate on the feature branch**

If the user reports any visual issue, fix it on this branch (amend or add commits), push again, and re-preview. Do not move to Task 8 until the preview is approved.

No commit for Task 7 beyond what was already committed in Tasks 2–6.

---

## Task 8: Merge to main and verify live

**Files:** none modified locally.

- [ ] **Step 8.1: Wait for user approval of the preview**

User must explicitly say the preview looks right. If not, return to Task 7.4.

- [ ] **Step 8.2: Check out main and fast-forward merge**

```bash
git checkout main
git merge --ff-only feat/profile-redesign-v1
```

Expected: fast-forward merge completes. If it refuses (someone pushed to main in the meantime), rebase the feature branch onto main first, then retry.

- [ ] **Step 8.3: Push main**

```bash
git push origin main
```

Expected: push succeeds.

- [ ] **Step 8.4: Manually trigger both workflows once**

```bash
gh workflow run update-timestamp.yml --ref main
gh workflow run sync-pinned.yml --ref main
```

Expected: both return "workflow run successfully triggered". After ~30 seconds:

```bash
gh run list --workflow=update-timestamp.yml --limit 1
gh run list --workflow=sync-pinned.yml --limit 1
```

Expected: both show `completed success`. If either shows `failure`, open the run URL (`gh run view <id> --web`) and fix the failing step on a new branch before anyone sees the broken profile.

- [ ] **Step 8.5: Verify the live profile**

Ask the user to open `https://github.com/ball46` and confirm the redesigned README is visible on their profile page. This is the final acceptance check.

- [ ] **Step 8.6: Push the tag**

```bash
git push origin pre-redesign-backup
```

Expected: push succeeds. Pushing the backup tag to remote gives a clean rollback target visible to anyone with repo access.

- [ ] **Step 8.7: Delete the feature branch (local + remote)**

```bash
git branch -d feat/profile-redesign-v1
git push origin :feat/profile-redesign-v1
```

Expected: both succeed.

---

## Rollback Plan

If anything goes wrong after merging to main:

```bash
cd /root/ball46-profile
git checkout main
git reset --hard pre-redesign-backup
git push --force-with-lease origin main
```

The `pre-redesign-backup` tag points to the commit before the redesign began, so this restores the old README exactly. Only run this if the user asks — force-push is a destructive shared-state action.

---

## Self-review notes (recorded during plan writing)

- **Spec coverage:** §6.1 → Task 2.2; §6.2–6.6 → Task 2.2; §6.7 widgets → Task 1 (verify) + Task 2.2 (embed); §6.8 contact → Task 2.2; §6.9 footer → Task 2.2; §7.1 timestamp workflow → Task 3; §7.2 pinned sync → Tasks 4–6; §8 build plan mapped 1:1 to Tasks 0–8. No gaps.
- **Placeholder scan:** no TBD/TODO in steps; every code block is complete; every expected output is stated.
- **Type consistency:** `README_PATH`, `PINNED_FIXTURE`, marker strings, and marker positions are identical across `sync-pinned.sh` (Task 4), fixture test (Task 5), and the workflow (Task 6).
