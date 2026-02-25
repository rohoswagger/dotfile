#!/bin/bash
# setup.sh — bootstrap a fresh VPS

set -e

echo "=========================================="
echo "  rohoswagger machine setup script"
echo ""
echo "  Shell"
echo "    - git, zsh, Oh My Zsh, zshrc, Neovim"
echo ""
echo "  Python"
echo "    - uv, httpie"
echo ""
echo "  JavaScript"
echo "    - nvm, Node (LTS), bun"
echo ""
echo "  Go"
echo "    - k9s"
echo ""
echo "  AI"
echo "    - Claude Code, GitHub MCP, Playwright MCP"
echo "=========================================="
echo ""
printf "Proceed? [y/N] " && read REPLY < /dev/tty
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi
echo ""

# -----------------------------------------------
# Shell
# -----------------------------------------------

echo "==> Installing git and zsh..."
apt-get update -qq && apt-get install -y git zsh

echo "==> Setting zsh as default shell..."
chsh -s "$(which zsh)"

echo "==> Generating SSH key..."
ssh-keygen -t ed25519 -C "rohod04@gmail.com" -f ~/.ssh/id_ed25519 -N ""
echo ""
echo "Add this public key to GitHub (https://github.com/settings/keys) before continuing:"
echo ""
cat ~/.ssh/id_ed25519.pub
echo ""
printf "Press enter once you've added the key to GitHub..." && read REPLY < /dev/tty

echo "==> Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "==> Copying .zshrc from dotfile repo..."
curl -fsSL https://raw.githubusercontent.com/rohoswagger/dotfile/main/.zshrc -o ~/.zshrc

echo "==> Installing Neovim (latest)..."
NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
tar -xzf nvim-linux-x86_64.tar.gz
install -m 755 nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm -rf nvim-linux-x86_64 nvim-linux-x86_64.tar.gz

# -----------------------------------------------
# Python
# -----------------------------------------------

echo "==> Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "==> Installing httpie..."
apt-get install -y httpie

# -----------------------------------------------
# JavaScript
# -----------------------------------------------

echo "==> Installing nvm..."
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

echo "==> Installing Node (LTS)..."
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

echo "==> Installing bun..."
curl -fsSL https://bun.sh/install | bash

# -----------------------------------------------
# Go
# -----------------------------------------------

echo "==> Installing k9s..."
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -LO "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
tar -xzf k9s_Linux_amd64.tar.gz k9s
install -m 755 k9s /usr/local/bin/k9s
rm -rf k9s k9s_Linux_amd64.tar.gz

# -----------------------------------------------
# AI
# -----------------------------------------------

if ! command -v claude &>/dev/null; then
    echo "==> Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "==> Claude Code already installed, skipping."
fi

echo "==> Installing CLAUDE.md for agent awareness..."
mkdir -p ~/.claude
curl -fsSL https://raw.githubusercontent.com/rohoswagger/dotfile/main/CLAUDE.md -o ~/.claude/CLAUDE.md

echo "==> Configuring MCP servers..."
printf "Enter GitHub personal access token (leave blank to skip): " && read GITHUB_TOKEN < /dev/tty
if [[ -n "$GITHUB_TOKEN" ]]; then
    claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN -- npx -y @modelcontextprotocol/server-github
else
    echo "Skipping GitHub MCP."
fi
claude mcp add playwright -- npx -y @playwright/mcp

echo ""
echo "Done! Switching to zsh..."
exec zsh
