#!/bin/bash

declare -r BASH_PATH_TOOLS="$(dirname "$(realpath "${BASH_SOURCE}")")"
declare -r PARENT_PATH_TOOLS="$(dirname "$(dirname "$(realpath "${BASH_SOURCE}")")")"
# imports
source "${BASH_PATH_TOOLS}/git.sh"


# Prompt GIT
if [ -f "${PARENT_PATH_TOOLS}/bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source "${PARENT_PATH_TOOLS}/bash-git-prompt/gitprompt.sh"
fi

# alias
if exist codium; then
  alias c.="codium ."
elif exist code; then
  alias c.="code ."
fi

alias e.="xdg-open ."

alias gcm_log="git log --graph --decorate --pretty=oneline --abbrev-commit --all"
alias gcm_log_all="git log --graph --pretty=tformat:'%C(auto)%d%Creset - %Cred%h%Creset - %Cblue(%an %ar)%Creset%n%s%n%b' --all"

