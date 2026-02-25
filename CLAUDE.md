# Machine Setup

This machine has been configured using https://github.com/rohoswagger/dotfile.
Prefer using the aliases below over their full equivalents when running shell commands.

## Installed Tools

| Tool | Purpose |
|------|---------|
| `git` | Version control |
| `oh-my-zsh` | Shell framework |
| `nvim` | Text editor |
| `uv` | Python package manager |
| `httpie` | HTTP client (`http` / `https` commands) |
| `nvm` + `node` | JavaScript runtime |
| `bun` | JavaScript runtime + package manager |
| `k9s` | Kubernetes TUI |
| `claude` | Claude Code CLI |


## Git

| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `gb` | `git branch` |
| `ga` | `git add` |
| `gaa` | `git add .` |
| `gau` | `git add -u` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `pull` | `git pull` |
| `push` | `git push -u` |
| `fetch` | `git fetch origin` |
| `rebase` | `git fetch origin && git rebase origin/main --update-refs` |
| `co` | `git checkout` |
| `log` | `git log --oneline` |
| `stash` | `git stash` |
| `stashpop` | `git stash pop` |
| `cherry` | `git cherry-pick` |
| `sync` | checkout main, pull, delete merged branches |
| `gbc <name>` | create branch as `roshan/<name>` |
| `gpr` | `gh pr create --template pull_request_template.md` |
| `pr` | `gh pr checkout` |

## Process management

| Alias | Command |
|-------|---------|
| `fport <port>` | show what's listening on a port |
| `killport <port>` | kill the process listening on a port |

## Kubernetes

| Alias | Command |
|-------|---------|
| `k` | `kubectl` |
| `kc` | `kubectl` |
| `kgp` | `kubectl get pods` |
| `klogs` | `kubectl logs -f` |
| `kd <pod>` | `kubectl describe pod` |
| `kshell <pod>` | exec into a pod (`-n <namespace>` optional) |

## Misc

| Alias | Command |
|-------|---------|
| `refresh` | `source ~/.zshrc` |
