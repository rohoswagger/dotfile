# dotfile

Personalized machine setup for a fresh Linux VPS.

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
- **Neovim** (latest release)
- **k9s** (Kubernetes CLI)
- **uv** (Python package manager)
- **Claude Code**

After the script completes, run `source ~/.zshrc` or open a new shell.

## Repo structure

```
.zshrc        # general aliases and shell config
setup.sh      # one-shot machine bootstrap script
```
