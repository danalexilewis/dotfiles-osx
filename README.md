# dotfiles-osx

Curated macOS config for Cursor, T3 Code, Codex, Ghostty, Amethyst, zsh, and Vite+.
Runtime state (caches, OAuth tokens, conversation DBs) stays out of Git.

## Bootstrap (new Mac)

1. Install your apps yourself (Cursor, Ghostty, Amethyst, Homebrew tools, etc.).
2. Clone and link:

```bash
git clone git@github.com:danalexilewis/dotfiles-osx.git ~/repos/dotfiles-osx
~/repos/dotfiles-osx/install
```

3. Optional: install Cursor extensions from the list:

```bash
~/repos/dotfiles-osx/install --extensions
```

4. Verify:

```bash
~/repos/dotfiles-osx/doctor
```

## Design rules

- **Do not modify global configuration through an app UI unless the change is represented in this repository.**
- **No project-specific MCP may be installed globally.** Global MCPs stay rare (Chrome DevTools, Figma, agentmemory). Everything else lives in the project’s `.cursor/mcp.json`.
- **Never commit secrets.** Use `${env:NAME}` in MCP configs. Per-machine values go in `~/.zshrc.local` and `~/.gitconfig`.

## Layout

| Path | Linked to |
| --- | --- |
| `zsh/zshrc` | `~/.zshrc` |
| `zsh/zshenv` | `~/.zshenv` |
| `bash/bashrc` | `~/.bashrc` |
| `git/config` | `~/.config/git/config` |
| `git/ignore` | `~/.config/git/ignore` |
| `cursor/*` | Cursor User dir + `~/.cursor/mcp.json` + skills |
| `t3/*` | `~/.t3/userdata/` |
| `codex/config.toml` | `~/.codex/config.toml` |
| `vite-plus/config.json` | `~/.config/vite-plus/config.json` |
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` |
| `amethyst/amethyst.yml` | `~/.config/amethyst/amethyst.yml` |

`links.conf` is the source of truth. `./install` backs up existing targets under `~/.dotfiles-backup/<timestamp>/` then symlinks. Re-run after `git pull`.

## Per-machine (not in Git)

- `~/.gitconfig` — CodeRabbit `machineId` and anything from `git config --global`
- `~/.zshrc.local` — host-specific env / secrets for the shell
- Lunar Pro license (activate in the Lunar app; up to 5 Macs)
- `~/.npmrc`, SSH keys, `gh` auth

## Node / package managers

Vite+ (`vp env`) manages Node and package-manager shims. Project pins use `.node-version`, `devEngines`, `engines.node`, or `.nvmrc`.

Set a global default once:

```bash
vp env default lts
```

If you still have the old `n` / Homebrew Node stack:

```bash
sudo n uninstall && sudo rm -rf /usr/local/n
brew uninstall n node@22 pnpm
```

Keep Homebrew `node` if the `vite-plus` formula depends on it; shims still win on PATH.

## Pi

When you start using pi, copy `pi/settings.json.example` to `pi/settings.json`, uncomment the line in `links.conf`, and re-run `./install`. Never commit `auth.json`, sessions, or trust state.

## Eddy project MCPs

Project-specific servers belong in the Eddy repos (created on this machine, left for you to commit there if you want):

- `~/repos/eddy/app/.cursor/mcp.json` — PostHog (OAuth), Sentry, Chakra UI, Linear
- `~/repos/eddy/eddy.works/.cursor/mcp.json` — PostHog (OAuth), Mux, Linear

## Scripts

- `./install` — symlink everything (`--dry-run`, `--extensions`)
- `./doctor` — check links, overrides, secret patterns, list global MCPs
- `.githooks/pre-commit` — blocks obvious token strings (enabled via `core.hooksPath` on install)
