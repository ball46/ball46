# ball46 GitHub Profile README — Redesign Design Doc

**Date:** 2026-04-16
**Repo:** [ball46/ball46](https://github.com/ball46/ball46) (profile README repo)
**Status:** Design approved, ready for implementation planning
**Previous README:** generic `github-profile-readme-generator` template from ~2023, with outdated info, broken social links, and a 30-icon tech stack dump.

---

## 1. Goals

Replace the current auto-generated template README with a hand-crafted profile that reflects the owner's actual identity: a full-stack engineer who runs his own infrastructure and bridges non-technical users with developers. The redesign must feel distinctive, substantively reflect current work, and remove all broken/outdated artifacts from the previous README.

## 2. Audience & Positioning

**Primary audience:** Personal showcase — the profile is a canonical self-representation, not targeted at recruiters or clients.
**Secondary audience:** Fellow developers / open-source community — technical substance matters, but no corporate/resume voice, no "hire me" CTAs, no marketing-speak.

**Core identity** (two strands, equally weighted):
1. **Full-stack engineer who runs the servers his products live on** — ships product AND owns the infra it runs on (single-VPS sysadmin culture).
2. **Technical bridge** — translates between users who don't speak code and developers who don't speak user.

**Tagline (implicit, not literally printed):** "builds the product, runs the servers, talks to the users"

## 3. Visual Direction

**Style:** IDE / Code-file aesthetic + Stats dashboard elements.

The entire README reads like opening a TypeScript type declaration file (`ball46.d.ts`) in VS Code. JSDoc block comments carry the warm reflective voice; the TS interface and const declarations provide the dry-technical structure; widget cards at the end act as "runtime metrics" of the declared type.

**Theme:** `catppuccin_mocha` — applied consistently to all rendered widgets so they match GitHub's dark-mode view and feel like a cohesive IDE workspace.

**Header:** Typewriter SVG via [`readme-typing-svg`](https://github.com/DenverCoder1/readme-typing-svg) cycling through:
- `interface Ball46 {`
- `ship • run • translate`
- `// currently: trade-journal v2`

Fallback if the external service is down: static H1 + subtitle.

## 4. Voice / Tone

**Dry technical + warm reflective** (Q4: a + c).

- Structure is formal and spec-like (types, const arrays, comment headers).
- JSDoc block comments carry personal voice — reflective, first-person, no hedging.
- No emoji in body prose (structural emoji in tables OK).
- No exclamation marks. No marketing adjectives ("passionate", "comprehensive", etc.).
- No "currently learning X" filler.
- Short sentences. Concrete nouns over vague abstractions.

## 5. File Layout

```
┌─────────────────────────────────────────────┐
│ 1. Header banner — typewriter SVG           │
│ 2. File intro — JSDoc block                 │
│ 3. Main interface declaration               │
│ 4. § currently_building                     │
│ 5. § stack_in_production                    │
│ 6. § principles                             │
│ 7. § runtime_metrics (stats widgets)        │
│ 8. § contact                                │
│ 9. Footer — // EOF with last_updated        │
└─────────────────────────────────────────────┘
```

Each section is a TypeScript code block (triple-backtick `typescript`) with GitHub's syntax highlighting rendering the monospace IDE feel.

## 6. Full Content

### 6.1 Header — Typewriter SVG

```markdown
<p align="center">
  <a href="https://github.com/ball46">
    <img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&size=28&pause=1000&color=CBA6F7&center=true&vCenter=true&width=600&lines=interface+Ball46+%7B;ship+%E2%80%A2+run+%E2%80%A2+translate;%2F%2F+currently%3A+trade-journal+v2" alt="ball46" />
  </a>
</p>
```

Color `#CBA6F7` = catppuccin mocha mauve. Font: JetBrains Mono.

### 6.2 File intro — JSDoc block

````markdown
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
```
````

### 6.3 Main interface

````markdown
```typescript
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
````

### 6.4 § currently_building

````markdown
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
````

### 6.5 § stack_in_production

````markdown
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
````

### 6.6 § principles

````markdown
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
````

Each principle sourced from the owner's actual feedback-memory corpus (not invented marketing lines).

### 6.7 § runtime_metrics — Stats dashboard widgets

Three widgets, all `catppuccin_mocha` theme, arranged as:
- Stats card + Top languages — side-by-side on one row
- Activity graph — full-width below

**Widget 1 — Stats card** ([`anuraghazra/github-readme-stats`](https://github.com/anuraghazra/github-readme-stats))

```markdown
<a href="https://github.com/ball46">
  <img align="left" height="180em"
       src="https://github-readme-stats.vercel.app/api?username=ball46&show_icons=true&theme=catppuccin_mocha&hide_border=true&count_private=true&include_all_commits=true" />
</a>
```

**Widget 2 — Top languages** (same project, `top-langs` endpoint)

```markdown
<a href="https://github.com/ball46">
  <img align="left" height="180em"
       src="https://github-readme-stats.vercel.app/api/top-langs/?username=ball46&layout=compact&theme=catppuccin_mocha&hide_border=true&langs_count=8&exclude_repo=https---github.com-SE-Project-BOTMAPS-backend" />
</a>
```

**Widget 3 — Activity graph** ([`ashutosh00710/github-readme-activity-graph`](https://github.com/Ashutosh00710/github-readme-activity-graph))

```markdown
<br clear="both" />

<img src="https://github-readme-activity-graph.vercel.app/graph?username=ball46&theme=github-compact&bg_color=1e1e2e&color=cba6f7&line=cba6f7&point=f5e0dc&hide_border=true" />
```

Note: activity graph uses `github-compact` as base theme since it lacks a built-in catppuccin option, but the `bg_color`, `color`, `line`, `point` params are set to catppuccin mocha tokens so the visual output matches.

**Explicitly excluded widgets** (with reason):
- ❌ Streak stats (`github-readme-streak-stats.herokuapp.com`) — Heroku endpoint frequently down.
- ❌ Profile view counter (`komarev`) — uninformative noise.
- ❌ github-profile-trophy — redundant with the stats card.
- ❌ The 30-icon tech stack dump from the old README — replaced by `speaks` field and per-project `stack` arrays.

### 6.8 § contact

````markdown
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
````

**Decision:** keep all original channels from the previous README structure; leave the broken ones as `null` so it's obvious they're unfilled rather than silently dropped. Owner will fill in real URLs in a follow-up edit when convenient.

### 6.9 Footer

````markdown
```typescript
// ───────────────────────────────────────────
// EOF — ball46.d.ts
// last_updated: 2026-04-16
// ───────────────────────────────────────────
```
````

The `last_updated` line is maintained by a GitHub Action (see §7.1).

## 7. Optional additions (approved — will ship with v1)

### 7.1 Daily `last_updated` refresh

GitHub Action at `.github/workflows/update-timestamp.yml` that runs on a daily cron, rewrites the `last_updated: YYYY-MM-DD` line in `README.md`, and commits the change back.

**Implementation sketch:**
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
      - uses: actions/checkout@v4
      - name: Rewrite timestamp line
        run: |
          today=$(date -u +%Y-%m-%d)
          sed -i -E "s/last_updated: [0-9]{4}-[0-9]{2}-[0-9]{2}/last_updated: ${today}/" README.md
      - name: Commit if changed
        run: |
          if ! git diff --quiet; then
            git config user.name  "github-actions[bot]"
            git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
            git add README.md
            git commit -m "chore: refresh last_updated timestamp"
            git push
          fi
```

Rationale: reinforces the "live dashboard" feeling of the § runtime_metrics section without taking on a real service dependency.

### 7.2 Dynamic pinned projects via workflow

A second GitHub Action that, on each push (and on a weekly cron as safety net), reads the owner's GitHub pinned repositories via the GraphQL API and rewrites the `projects` array inside § currently_building to match.

**Implementation sketch:**
- `.github/workflows/sync-pinned.yml` calls a small Python script (`scripts/sync-pinned.py`) using `PyGithub` or a raw GraphQL query against `viewer.pinnedItems(first: 6)`.
- Script maps each pinned repo to a `{ name, desc, stack, status, url }` entry. `desc` comes from the repo description; `stack` is inferred from GitHub's detected language set (top 3); `status` is one of `"running in production"` / `"in development"` / `"archived"` based on repo state (pushed-recently / archived flag).
- Script rewrites the region between two HTML comment markers:
  ```html
  <!-- pinned:start -->
  ...
  <!-- pinned:end -->
  ```
- Workflow needs `contents: write` + a `GITHUB_TOKEN` with `read:user` scope for pinned-item access. (Default `GITHUB_TOKEN` works for public repos; private pins need a fine-grained PAT stored as repo secret `PINNED_PAT`.)

**Trade-off to confirm in implementation phase:** dynamic sync means the README structure around § currently_building becomes partially owned by the workflow — manual edits to that region get overwritten on next sync. Acceptable because the rest of the file (principles, infra, contact) stays static.

## 8. Build / ship plan (summary for writing-plans)

1. **Pre-flight**: confirm repo access, preserve original `README.md` via git tag `pre-redesign-backup`.
2. **Static content**: write the new `README.md` with sections 6.1–6.9 as designed. Verify TS syntax highlighting renders on GitHub.
3. **Widget URLs**: test each widget URL in a browser (or via `curl -I`) to confirm it returns a valid SVG before committing.
4. **Daily timestamp workflow** (§7.1): create `.github/workflows/update-timestamp.yml`, test via `workflow_dispatch`.
5. **Dynamic pinned workflow** (§7.2): create script + workflow, test against owner's actual pinned repos, verify the generated array stays within the `<!-- pinned:start -->` / `<!-- pinned:end -->` markers.
6. **Verification**: push to a feature branch first, visually inspect the rendered README on GitHub (preview PR), then merge to `main`.
7. **Rollback plan**: if anything looks broken on live profile, `git revert` the merge commit — `pre-redesign-backup` tag gives a clean restore point.

## 9. Out of scope (v1)

- Custom SVG illustrations (beyond the typewriter header).
- Blog-post feed (no blog exists yet).
- WakaTime widgets (no WakaTime account configured).
- i18n / bilingual TH/EN split — deferred; English-only for v1 given "fellow developers" as secondary audience.
- Renaming the repo or changing branch protection rules.

## 10. Open questions deferred to implementation

- Exact URL strings for `linkedin`, `facebook`, `discord` — owner will fill in after verification.
- Whether to use `PyGithub` or raw GraphQL in the pinned-sync script — decide based on which is simpler for 1 API call.
- Whether to run the daily timestamp workflow on a weekday-only cron to avoid weekend commit noise — preference question, defer to owner.
