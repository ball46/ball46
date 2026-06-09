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
    name:   "checkers-game",
    desc:   "(no description)",
    stack:  ["Scala"],
    status: "in development",
    url:    "https://github.com/ball46/checkers-game",
  },
  {
    name:   "Project_UPBEAT",
    desc:   "(no description)",
    stack:  ["Java"],
    status: "in development",
    url:    "https://github.com/ball46/Project_UPBEAT",
  },
  {
    name:   "backend",
    desc:   "(no description)",
    stack:  ["Go","Dockerfile"],
    status: "in development",
    url:    "https://github.com/SE-Project-BOTMAPS/backend",
  },
  {
    name:   "crontab-ui",
    desc:   "Interactive TUI for managing crontab — no syntax memorization, no vim required.",
    stack:  ["Python","Shell"],
    status: "running in production",
    url:    "https://github.com/ball46/crontab-ui",
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
       src="https://github-readme-stats.vercel.app/api?username=ball46&show_icons=true&theme=catppuccin_mocha&hide_border=true&count_private=true" alt="ball46 stats" />
</a>
<a href="https://github.com/ball46">
  <img align="left" height="180em"
       src="https://github-readme-stats.vercel.app/api/top-langs/?username=ball46&layout=compact&theme=catppuccin_mocha&hide_border=true&exclude_repo=https---github.com-SE-Project-BOTMAPS-backend,upbeat_backend,Project_UPBEAT,Project_UPBEAT_Spring&langs_count=8" alt="ball46 top languages" />
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
// last_updated: 2026-06-09
// ───────────────────────────────────────────
```
