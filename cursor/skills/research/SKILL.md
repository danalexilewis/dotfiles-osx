---
name: research
description: Research external projects, tools, and patterns to find improvements for the current codebase. Use when the user asks to investigate external repos, compare approaches, survey the ecosystem, or find patterns to extract from other projects.
---

# Research

Structured investigation of external projects, tools, and ecosystem patterns to surface actionable improvements for the current codebase.

## Workflow

### 1. Scope the investigation

Identify what to research. Common categories:

- **Reference projects** — repos that solve similar problems or inspired the current system
- **Ecosystem tools** — databases, frameworks, protocols that the system depends on or could adopt
- **Vendor guidance** — official best-practice docs from model providers (Anthropic, OpenAI, etc.)
- **Community patterns** — blog posts, conference talks, emerging conventions

### 2. Gather sources

For each target, use the appropriate tool:

| Source type           | Tool                            | Notes                                    |
| --------------------- | ------------------------------- | ---------------------------------------- |
| GitHub repo overview  | `WebFetch` on repo URL          | Get README, structure, star count        |
| Project docs site     | `WebFetch` on docs URL          | Architecture, concepts, API              |
| Ecosystem search      | `WebSearch` with specific terms | Combine project name + domain keywords   |
| Vendor best practices | `WebSearch` + `WebFetch`        | Anthropic blog, docs.anthropic.com, etc. |

Run independent searches **in parallel** (batch `WebSearch` calls in a single message).

### 3. Analyze against current system

For each finding, evaluate:

- **Relevance**: Does this solve a problem we actually have?
- **Delta**: What does this offer that we don't already have?
- **Cost**: What would adoption require (new deps, refactors, breaking changes)?
- **Fit**: Does this align with our architecture and constraints?

### 4. Produce output

Structure findings as a synthesis document with:

```markdown
## <Project/Pattern Name>

**What it is**: One-line summary
**Key patterns worth extracting**:

- Pattern 1: description + how it maps to our system
- Pattern 2: ...

**Gaps it fills**: What problem in our system this addresses
**Adoption cost**: Low / Medium / High + brief rationale
```

End with a **Recommendations** section ranking improvements by impact/effort ratio.

## Reference projects (Task-Graph ecosystem)

These repos are known influences or adjacent tools. Investigate them when the user asks for ecosystem research:

| Project          | URL                                     | Relationship                                                 |
| ---------------- | --------------------------------------- | ------------------------------------------------------------ |
| Gastown          | `https://github.com/steveyegge/gastown` | Multi-agent orchestration (Mayor/Polecat/Convoy model)       |
| Beads            | `https://github.com/steveyegge/beads`   | Git-backed issue tracker, Dolt-powered, formula system       |
| Superpowers      | `https://github.com/obra/superpowers`   | Skills framework for coding agents (brainstorm/plan/execute) |
| gt (Gastown CLI) | Part of Gastown repo (`cmd/gt`)         | The `gt` CLI for managing multi-agent workspaces             |
| Dolt             | `https://github.com/dolthub/dolt`       | Version-controlled SQL database (our storage layer)          |
| Dolt MCP         | `https://github.com/dolthub/dolt-mcp`   | MCP server for agent-Dolt integration                        |

### Vendor resources

| Resource                              | URL                                                                                 |
| ------------------------------------- | ----------------------------------------------------------------------------------- |
| Anthropic: Multi-agent systems        | `https://claude.com/blog/building-multi-agent-systems-when-and-how-to-use-them`     |
| Anthropic: Context engineering        | `https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents` |
| Anthropic: Building effective agents  | `https://resources.anthropic.com/building-effective-ai-agents`                      |
| Anthropic: Claude Code best practices | `https://docs.anthropic.com/en/docs/claude-code/best-practices`                     |
| DoltHub: Agentic workflows            | `https://www.dolthub.com/blog/2025-03-17-dolt-agentic-workflows/`                   |
| DoltHub: Agent mode                   | `https://www.dolthub.com/blog/2026-02-09-introducing-agent-mode/`                   |

## Tips

- **Don't boil the ocean.** Focus on patterns that map to actual pain points or known gaps. "Interesting but not actionable" findings waste tokens.
- **Check what we already have.** Read `docs/architecture.md`, `AGENT.md`, and `.cursor/rules/` before concluding something is missing — we may already have it under a different name.
- **Prioritize extractable patterns over wholesale adoption.** We're a small CLI; we don't need a Mayor/Deacon/Witness hierarchy. But the _idea_ of persistent agent identity or convoy-style work batching might be portable.
- **Include web search for recent developments.** Ecosystem moves fast; search with the current year to catch recent releases and blog posts.
