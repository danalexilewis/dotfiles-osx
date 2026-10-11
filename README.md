# dotfiles-osx

Curated macOS config + Homebrew apps for a fresh AI/dev machine, managed by [chezmoi](https://www.chezmoi.io/).
Runtime state (caches, OAuth tokens, conversation DBs) stays out of Git.

macOS only for now.

## One-shot bootstrap (new Mac)

After macOS setup, with network and a terminal:

```bash
# 1. Install Homebrew if you do not have it yet (bootstrap also does this)
# 2. Clone + bootstrap
git clone git@github.com:danalexilewis/dotfiles-osx.git ~/repos/dotfiles-osx
~/repos/dotfiles-osx/bootstrap
```

That installs Homebrew if needed, `brew install chezmoi`, then runs
`chezmoi init --apply --source ~/repos/dotfiles-osx`.

`chezmoi init` asks for a **machine profile** (`full` or `local-ai`) and then each
feature toggle, using the profile's values as the defaults. Answers are stored
in `~/.config/chezmoi/chezmoi.toml`. The source directory stays this checkout.

Skip Cursor extensions with `./bootstrap --no-extensions`.

### Still manual once per machine

- App Store / Xcode setup asks for your password
- Sign in to 1Password, then `gh auth login`
- `eas login`, when you first use EAS Build
- Activate Lunar Pro in the Lunar app
- Sign in to Cursor / Claude / Codex / T3
- OAuth for Figma / Linear / PostHog when first used
- Host-only secrets in `~/.zshrc.local`
- SSH key for GitHub if you clone via SSH before 1Password/gh is ready
  (HTTPS clone works too: `git clone https://github.com/danalexilewis/dotfiles-osx.git`)
- Apps already installed by hand may need
  `brew install --cask --adopt <cask>` before `brew bundle` will claim them
- Spark Desktop and Whisper Transcription come from the App Store (`mas`)

## Everyday commands

| Command | What it does |
| ------- | ------------ |
| `chezmoi diff` | Show what would change in `$HOME` |
| `chezmoi apply` | Make `$HOME` match this repo |
| `chezmoi status` | List drifted files |
| `chezmoi re-add PATH` | Pull a **plain** file's live edits back into the repo |
| `chezmoi merge PATH` | Three-way merge a **template** (git identity) |
| `chezmoi update` | `git pull` in the source repo, then apply |
| `chezmoi init --prompt` | Re-ask profile / toggles / git identity |
| `./doctor` | Verify apply, overrides, secrets, global MCPs |

chezmoi uses **copy mode**. Edits made through an app UI show up as drift.
Plain files come back with `re-add`; templates need `merge`. Codex
`~/.codex/config.toml` is a modify-template: it enforces a few keys and
keeps everything the app writes.

## Profiles and toggles

Profiles live in [`home/.chezmoi.toml.tmpl`](home/.chezmoi.toml.tmpl). To add a
profile later, add one dict entry there. Toggles can still override the
profile on each machine.

| Toggle | `full` | `local-ai` | What it controls |
| ------ | ------ | ---------- | ---------------- |
| `features.mobile` | on | on | Watchman, CocoaPods, Zulu 17, Android Studio, `android-cli`, Xcode, Android SDK 36, emulator, `eas-cli` |
| `features.ai` | on | on | T3 Code, Claude, `claude-code`, `codex`, ChatGPT, Repo Prompt, `beads`, `herdr`, Cursor `agent` CLI, `~/.codex`, `~/.t3` |
| `features.everyday` | on | on | Zen, Obsidian, AFFiNE, Figma, Linear, Discord, CleanShot, Loom, Screen Studio, Zoom, Notion, WhatsApp, Spotify, Wispr Flow, Spark, Whisper, Slack, Telegram, TickTick, DaisyDisk, 1Blocker |
| `features.localAi` | off | on | Ollama, LM Studio, OpenWhispr, `llm` |
| `features.pi` | off | off | `~/.pi/agent/settings.json` |
| `features.cursorExtensions` | on | on | Cursor extensions from package data |

**core** is always on: `gh`, `git-lfs`, `vite-plus`, `postgresql@16`, `ncdu`,
`mole`, `mas`, `chezmoi`, `neovim`, `ripgrep`, `fd`, `jq`, `just`, `uv`,
`shellcheck`, `ast-grep`, `pandoc`, `git-filter-repo`, 1Password + CLI,
Cursor, Ghostty, Amethyst, Lunar, Zed, Chrome, shell / git / Cursor /
Ghostty / Amethyst / Vite+ config, and oh-my-zsh.

Change a toggle later with `chezmoi init --prompt`, or edit
`~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.

## Design rules

- **Do not modify global configuration through an app UI unless the change is represented in this repository.**
- **No project-specific MCP may be installed globally.** Global MCPs stay rare (Chrome DevTools, Figma, agentmemory). Everything else lives in the project’s `.cursor/mcp.json`.
- **Never commit secrets.** Use `${env:NAME}` in MCP configs. Per-machine values go in `~/.zshrc.local` and `~/.gitconfig`.

## Packages

Declared in [`home/.chezmoidata/packages.yaml`](home/.chezmoidata/packages.yaml)
and installed by chezmoi scripts (`brew bundle` plus App Store / Xcode / CLIs).

| Kind      | Packages                                                                                                   |
| --------- | ---------------------------------------------------------------------------------------------------------- |
| CLI       | `gh`, `git-lfs`, `vite-plus`, `postgresql@16`, `ncdu`, `mole`, `mas`, `chezmoi`, `neovim`, `ripgrep`, `fd`, `jq`, `just`, `uv`, `shellcheck`, `ast-grep`, `pandoc`, `git-filter-repo`, Watchman, CocoaPods |
| Core      | Cursor, Ghostty, Amethyst, Lunar, Zed, Chrome, T3 Code, Claude, Claude Code (`claude`), Codex (`codex`), ChatGPT, Repo Prompt, 1Password + CLI |
| Everyday  | Zen, Obsidian, AFFiNE, Figma, Linear, Discord, CleanShot, Loom, Screen Studio, Zoom, Notion, WhatsApp, Spotify, Wispr Flow |
| App Store | 1Blocker, Spark Desktop, Whisper Transcription, Slack, Telegram, TickTick, DaisyDisk, Xcode                  |
| Local AI  | Ollama, LM Studio, OpenWhispr, `llm` (when `features.localAi` is on)                                        |
| Expo      | Zulu JDK 17, Android Studio, Android CLI, Android SDK 36, `eas`                                            |

The Cursor app cask does not install the agent CLI, so a script installs
`agent` when `~/.local/bin/agent` is missing. `claude` and `codex` come from
the `claude-code` and `codex` casks; the script installs either cask again if
that command is not on `PATH`.

Intentionally **not** included: Docker, Warp, tmux, worktrunk, Go, pgAdmin, Flameshot, PostgreSQL 14, Raycast, Signal.

## Layout

Source lives under [`home/`](home/) (see [`.chezmoiroot`](.chezmoiroot)).
chezmoi copies these into `$HOME`.

| Source | Target |
| ------ | ------ |
| `home/dot_zshrc` | `~/.zshrc` |
| `home/dot_zshenv` | `~/.zshenv` |
| `home/dot_bashrc` | `~/.bashrc` |
| `home/create_dot_gitconfig` | `~/.gitconfig` (created only if missing) |
| `home/dot_config/git/config.tmpl` | `~/.config/git/config` |
| `home/dot_config/git/ignore` | `~/.config/git/ignore` |
| `home/private_Library/private_Application Support/private_Cursor/private_User/*` | Cursor User dir (`~/Library` stays mode 700) |
| `home/dot_cursor/mcp.json` | `~/.cursor/mcp.json` |
| `home/dot_cursor/skills/` | `~/.cursor/skills/` (only files listed here; extra skills are kept) |
| `home/dot_t3/userdata/*` | `~/.t3/userdata/` |
| `home/dot_codex/modify_private_config.toml` | `~/.codex/config.toml` (modify-template) |
| `home/dot_config/vite-plus/config.json` | `~/.config/vite-plus/config.json` |
| `home/dot_config/ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` |
| `home/dot_config/amethyst/amethyst.yml` | `~/.config/amethyst/amethyst.yml` |
| `home/dot_pi/agent/settings.json` | `~/.pi/agent/settings.json` (when `features.pi` is on) |

oh-my-zsh is a `git-repo` external (`~/.oh-my-zsh`, refreshed weekly). That
stays compatible with omz's own git-based updater.

## Per-machine (not in Git)

- `~/.config/chezmoi/chezmoi.toml` — profile, toggles, git identity, `sourceDir`
- `~/.gitconfig` — SSH signing, CodeRabbit `machineId`, and anything from `git config --global`
- `~/.zshenv.local` — host-specific PATH for non-interactive shells (Foundry, Cargo)
- `~/.zshrc.local` — host-specific env / secrets for interactive zsh
- `~/.bashrc.local` — host-specific bash extras
- Lunar Pro license (activate in the Lunar app; up to 5 Macs)
- `~/.npmrc`, SSH keys, `gh` auth

## Node / package managers

Vite+ (`vp env`) manages Node and package-manager shims. Project pins use `.node-version`, `devEngines`, `engines.node`, or `.nvmrc`. Apply sets `vp env default lts`.

## Pi

Turn on `features.pi` (init prompt or chezmoi.toml) and `chezmoi apply`.
Never commit `auth.json`, sessions, or trust state.

## Eddy project MCPs

Project-specific servers belong in the Eddy repos:

- `~/repos/eddy/app/.cursor/mcp.json` — PostHog (OAuth), Sentry
- `~/repos/eddy.works/.cursor/mcp.json` — PostHog (OAuth), Sentry

## Scripts

- `./bootstrap` — Homebrew + chezmoi + `chezmoi init --apply`
- `chezmoi apply` — packages, App Store / Xcode, files, CLIs, extensions
- `./doctor` — chezmoi status/verify, overrides, secret scan, global MCPs
- `.githooks/pre-commit` — blocks obvious token strings (enabled via `core.hooksPath` on apply)
