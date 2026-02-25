# Oh My Zsh — install via: sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# Fix ghostty terminal compatibility
[ "$TERM" = "xterm-ghostty" ] && export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH"

########################################################
# General aliases
########################################################

# Reload shell config
alias refresh="source ~/.zshrc"

# Create a branch prefixed with your name (usage: gbc my-feature)
gbc_function() {
    git checkout -b "roshan/$1"
}

# Delete local branches whose PRs have been merged or closed
delete_merged_branches() {
    for branch in $(git branch | sed 's/\*//'); do
        if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
            continue
        fi
        pr=$(gh pr list --head "$branch" -s closed --json state,number -q '.[] | select(.state=="MERGED" or .state=="CLOSED") | .number')
        if [ ! -z "$pr" ]; then
            echo "Deleting branch $branch as its PR #$pr is merged or closed."
            git branch -d "$branch"
        else
            echo "Branch $branch does not have a merged or closed PR."
        fi
    done
}

# Git
alias gbc="gbc_function"
alias gs="git status"
alias gb="git branch"
alias ga="git add"
alias gaa="git add ."
alias gau="git add -u"                    # stage only tracked files
alias gc="git commit"
alias gca="git commit --amend"
alias gcm="git commit -m"
alias pull="git pull"
alias rebase="git fetch origin && git rebase origin/main --update-refs"
alias fetch="git fetch origin"
alias push="git push -u"
alias gpr="gh pr create --template pull_request_template.md"
alias co="git checkout"
alias pr="gh pr checkout"                 # check out a PR by number
alias stash="git stash"
alias stashpop="git stash pop"
alias stashlist="git stash list"
alias stashdrop="git stash drop"
alias stashclear="git stash clear"
alias log="git log --oneline"
alias cherry="git cherry-pick"
alias sync="git checkout main; git pull; delete_merged_branches"

# Kill whatever process is listening on a given port (usage: killport 3000)
kill_process_on_port() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    local port=$1
    echo "Killing process on port $port..."
    lsof -i tcp:${port} | awk 'NR!=1 {print $2}' | xargs -r kill
    echo "Process on port $port killed (if it was running)."
}

# Show what's listening on a port (usage: fport 3000)
fport() {
    if [ -z "$1" ]; then
        echo "Usage: fport <port>"
        return 1
    fi
    lsof -nP -i ":$1"
}

alias killport="kill_process_on_port"

# Drop into a shell inside a pod (usage: kshell <pod> or kshell -n <namespace> <pod>)
kshell() {
    local namespace=""
    local pod=""
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -n) namespace="$2"; shift 2 ;;
            *)  pod="$1"; shift ;;
        esac
    done
    if [[ -n "$namespace" ]]; then
        kubectl exec -it -n "$namespace" "$pod" -- bash
    else
        kubectl exec -it "$pod" -- bash
    fi
}

# Kubernetes
alias k="kubectl"
alias kc="kubectl"
alias kgp="kubectl get pods"
alias klogs="kubectl logs -f"
alias kd="kubectl describe pod"

########################################################
# Service and job-specific aliases
# You can add additional job-specific aliases under ~/.zsh and link them here
########################################################
# [ -f ~/.zsh/services.zsh ] && source ~/.zsh/services.zsh
