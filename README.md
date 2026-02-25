# dotfile

Personalized machine setup for a fresh Linux VPS.

## Setup

1. Install Claude Code:
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

2. Run Claude and tell it to set up the machine:
```
setup my machine using https://github.com/rohoswagger/dotfile
```

Claude will handle the rest.

## For AI agents

You are setting up a new machine for rohoswagger. Run the setup script to install all required tools and apply the dotfiles:

```bash
curl -fsSL https://raw.githubusercontent.com/rohoswagger/dotfile/main/setup.sh | zsh
```

This will install:
- **git**
- **Oh My Zsh** with the robbyrussell theme
- **.zshrc** pulled directly from this repo
- **nvm** + Node LTS
- **bun**
- **Neovim** (latest release)
- **k9s** (Kubernetes CLI)
- **uv** (Python package manager)
- **httpie**
- **Claude Code** + GitHub MCP + Playwright MCP

The script will automatically apply the shell config on completion.

## Repo structure

```
.zshrc        # general aliases and shell config
setup.sh      # one-shot machine bootstrap script
CLAUDE.md     # agent-facing alias and tools reference
README.md     # this file
```
