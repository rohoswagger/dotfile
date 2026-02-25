#!/bin/bash
# setup.sh — bootstrap a fresh VPS
# Run as root: curl -fsSL .../setup.sh -o ~/setup.sh && bash ~/setup.sh

set -e

export TERM="${TERM:-xterm}"
[[ "$TERM" == "xterm-ghostty" ]] && export TERM="xterm-256color"

USERNAME="rohoswagger"
SCRIPT_URL="https://raw.githubusercontent.com/rohoswagger/dotfile/main/setup.sh"

# -----------------------------------------------
# User-phase: runs as the new user via --user-setup
# -----------------------------------------------
if [[ "${1}" == "--user-setup" ]]; then
    cd ~

    echo "==> Generating SSH key..."
    ssh-keygen -t ed25519 -C "rohod04@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    echo ""
    echo "Add this public key to GitHub (https://github.com/settings/keys) before continuing:"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    printf "Press enter once you've added the key to GitHub..." && read REPLY

    echo "==> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo "==> Copying .zshrc from dotfile repo..."
    curl -fsSL https://raw.githubusercontent.com/rohoswagger/dotfile/main/.zshrc -o ~/.zshrc

    echo "==> Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    echo "==> Installing nvm..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

    echo "==> Installing Node (LTS)..."
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts

    echo "==> Installing bun..."
    curl -fsSL https://bun.sh/install | bash

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
    printf "Enter GitHub personal access token (leave blank to skip): " && read GITHUB_TOKEN
    if [[ -n "$GITHUB_TOKEN" ]]; then
        claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN -- npx -y @modelcontextprotocol/server-github
    else
        echo "Skipping GitHub MCP (no token provided)."
    fi
    claude mcp add playwright -- npx -y @playwright/mcp

    echo ""
    echo "=========================================="
    echo "  Done! Log in as $USERNAME:"
    echo "    ssh $USERNAME@<host>"
    echo "=========================================="
    exit 0
fi

# -----------------------------------------------
# Root-phase: must run as root
# -----------------------------------------------
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Error: run this script as root."
    exit 1
fi

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
printf "Proceed? [y/N] " && read REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi
echo ""

# --- System packages ---
echo "==> Installing system packages..."
apt-get update -qq && apt-get install -y git zsh httpie sudo curl unzip

# --- Create user ---
echo "==> Creating user $USERNAME..."
if id "$USERNAME" &>/dev/null; then
    echo "    User $USERNAME already exists, skipping."
else
    useradd -m -s "$(which zsh)" "$USERNAME"
    echo "$USERNAME:$USERNAME" | chpasswd
    usermod -aG sudo "$USERNAME"
    echo "    Created user $USERNAME with sudo access."
fi

# --- Global binaries ---
echo "==> Installing Neovim (latest)..."
NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
tar -xzf nvim-linux-x86_64.tar.gz
install -m 755 nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
rm -rf nvim-linux-x86_64 nvim-linux-x86_64.tar.gz

echo "==> Installing k9s..."
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
curl -LO "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
tar -xzf k9s_Linux_amd64.tar.gz k9s
install -m 755 k9s /usr/local/bin/k9s
rm -rf k9s k9s_Linux_amd64.tar.gz

# --- Switch to user for home-directory setup ---
echo "==> Switching to $USERNAME for user-level setup..."
SCRIPT_PATH="/home/$USERNAME/setup.sh"
curl -fsSL "$SCRIPT_URL" -o "$SCRIPT_PATH"
chown "$USERNAME:$USERNAME" "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"
su - "$USERNAME" -c "bash $SCRIPT_PATH --user-setup"
rm -f "$SCRIPT_PATH"
