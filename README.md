# dotfile

Personalized machine setup for a fresh Linux VPS.

## Setup

Run this on a fresh machine:

```bash
curl -fsSL https://raw.githubusercontent.com/rohoswagger/dotfile/main/setup.sh | zsh
```

This installs: git, zsh + Oh My Zsh, Neovim, uv, httpie, nvm + Node LTS, bun, k9s, and Claude Code with GitHub and Playwright MCPs.

## Repo structure

```
.zshrc        # shell config and aliases
setup.sh      # one-shot machine bootstrap script
CLAUDE.md     # alias and tools reference
README.md     # this file
```
