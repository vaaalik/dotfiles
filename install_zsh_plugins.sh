set -euo pipefail

# ── Colors ─────────────────────────────────────────────
GREEN=$(tput setaf 2)   # success
YELLOW=$(tput setaf 3)  # action/info
RED=$(tput setaf 1)     # error
RESET=$(tput sgr0)

# ── Where Oh-My-Zsh keeps custom plugins ───────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# repo_url → local-folder map
declare -A plugins=(
  [fast-syntax-highlighting]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
  [fzf-tab]="https://github.com/Aloxaf/fzf-tab.git"
)

printf "${YELLOW}Installing / updating Zsh plugins…${RESET}\n"

for name in "${!plugins[@]}"; do
  dest="$ZSH_CUSTOM/$name"
  repo="${plugins[$name]}"

  if [[ -d "$dest/.git" ]]; then
    printf "${YELLOW}↻  Updating %s…${RESET}\n" "$name"
    if git -C "$dest" pull --quiet; then
      printf "${GREEN}✓  %s updated${RESET}\n" "$name"
    else
      printf "${RED}✗  Failed to update %s${RESET}\n" "$name"
    fi
  else
    printf "${YELLOW}+  Installing %s…${RESET}\n" "$name"
    if git clone --quiet "$repo" "$dest"; then
      printf "${GREEN}✓  %s installed${RESET}\n" "$name"
    else
      printf "${RED}✗  Failed to install %s${RESET}\n" "$name"
    fi
  fi
done
