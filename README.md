# dotfiles-osx

Curated macOS config + Homebrew apps for a fresh AI/dev machine.
Runtime state (caches, OAuth tokens, conversation DBs) stays out of Git.

## One-shot bootstrap (new Mac)

After macOS setup, with network and a terminal:

```bash
# 1. Install Homebrew if you do not have it yet (bootstrap also does this)
# 2. Clone + bootstrap
git clone git@github.com:danalexilewis/dotfiles-osx.git ~/repos/dotfiles-osx
~/repos/dotfiles-osx/bootstrap
```

That runs, in order:

1. [`./install-apps`](install-apps) — Homebrew, App Store (including Xcode), `brew bundle`, CLIs, Expo toolchain
2. oh-my-zsh (if missing)
3. `./install` (symlinks + Cursor extensions)
4. `vp env default lts`
5. `./doctor`

Skip Cursor extensions with `./bootstrap --no-extensions`.

### Still manual once per machine

- `./install-apps` asks for your password while setting up Xcode
- Sign in to 1Password, then `gh auth login`
- `eas login`, when you first use EAS Build
- Activate Lunar Pro in the Lunar app
- Sign in to Cursor / Claude / Codex / T3
- OAuth for Figma / Linear / PostHog when first used
- Host-only secrets in `~/.zshrc.local`
- SSH key for GitHub if you clone via SSH before 1Password/gh is ready  
  (HTTPS clone works too: `git clone https://github.com/danalexilewis/dotfiles-osx.git`)

## Design rules

- **Do not modify global configuration through an app UI unless the change is represented in this repository.**
- **No project-specific MCP may be installed globally.** Global MCPs stay rare (Chrome DevTools, Figma, agentmemory). Everything else lives in the project’s `.cursor/mcp.json`.
- **Never commit secrets.** Use `${env:NAME}` in MCP configs. Per-machine values go in `~/.zshrc.local` and `~/.gitconfig`.

## Brewfile (apps)

Installed by `./install-apps` (App Store apps first, then `brew bundle`):

| Kind      | Packages                                                                                                   |
| --------- | ---------------------------------------------------------------------------------------------------------- |
| CLI       | `gh`, `git-lfs`, `vite-plus`, `postgresql@16`, `ncdu`, `mole`, `mas`, Watchman, CocoaPods                   |
| Core      | Cursor, Ghostty, Amethyst, Lunar, T3 Code, Claude, Claude Code (`claude`), Codex (`codex`), 1Password + CLI |
| Everyday  | Zen, Obsidian, AFFiNE, Figma, Linear, Discord, CleanShot, Loom, Screen Studio, Zoom, Whisper Transcription |
| App Store | 1Blocker, Xcode                                                                                            |
| Expo      | Zulu JDK 17, Android Studio, Android command-line tools, Android SDK 36, `eas`                             |

`./install-apps` signs in to the App Store and installs those apps before `brew bundle`. After that it points `xcode-select` at Xcode, accepts the license, and downloads the iOS simulator platform. The Cursor app cask does not install the agent CLI, so the script installs `agent` when `~/.local/bin/agent` is missing. `claude` and `codex` come from the `claude-code` and `codex` casks; the script installs either cask again if that command is not on `PATH`.

Intentionally **not** included: Docker, Warp, tmux, worktrunk, Go, pgAdmin, Flameshot, PostgreSQL 14, Raycast, Signal.

## Layout

| Path                     | Linked to                                       |
| ------------------------ | ----------------------------------------------- |
| `zsh/zshrc`              | `~/.zshrc`                                      |
| `zsh/zshenv`             | `~/.zshenv`                                     |
| `bash/bashrc`            | `~/.bashrc`                                     |
| `git/config`             | `~/.config/git/config`                          |
| `git/ignore`             | `~/.config/git/ignore`                          |
| `cursor/*`               | Cursor User dir + `~/.cursor/mcp.json` + skills |
| `t3/*`                   | `~/.t3/userdata/`                               |
| `codex/config.toml`      | `~/.codex/config.toml`                          |
| `vite-plus/config.json`  | `~/.config/vite-plus/config.json`               |
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty`              |
| `amethyst/amethyst.yml`  | `~/.config/amethyst/amethyst.yml`               |

`links.conf` is the source of truth. `./install` backs up existing targets under `~/.dotfiles-backup/<timestamp>/` then symlinks. Re-run after `git pull`.

## Per-machine (not in Git)

- `~/.gitconfig` — CodeRabbit `machineId` and anything from `git config --global`
- `~/.zshrc.local` — host-specific env / secrets for the shell
- Lunar Pro license (activate in the Lunar app; up to 5 Macs)
- `~/.npmrc`, SSH keys, `gh` auth

## Node / package managers

Vite+ (`vp env`) manages Node and package-manager shims. Project pins use `.node-version`, `devEngines`, `engines.node`, or `.nvmrc`. Bootstrap sets `vp env default lts`.

## Pi

When you start using pi, copy `pi/settings.json.example` to `pi/settings.json`, uncomment the line in `links.conf`, and re-run `./install`. Never commit `auth.json`, sessions, or trust state.

## Eddy project MCPs

Project-specific servers belong in the Eddy repos:

- `~/repos/eddy/app/.cursor/mcp.json` — PostHog (OAuth), Sentry, Chakra UI, Linear
- `~/repos/eddy/eddy.works/.cursor/mcp.json` — PostHog (OAuth), Mux, Linear

## Scripts

- `./bootstrap` — one-shot new machine (apps + omz + install + vp default + doctor)
- `./install-apps` — App Store apps, Xcode, `brew bundle`, Cursor agent / Claude Code / Codex CLIs, Expo toolchain
- `./install` — symlink everything (`--dry-run`, `--extensions`)
- `./doctor` — check links, overrides, secret patterns, list global MCPs
- `.githooks/pre-commit` — blocks obvious token strings (enabled via `core.hooksPath` on install)
