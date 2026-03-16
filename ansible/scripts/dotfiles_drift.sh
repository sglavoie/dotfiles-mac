#!/usr/bin/env bash
#
# dotfiles_drift.sh — Compare packages defined in dotfiles vs what's installed.
# Exit 0 if fully in sync, 1 if any drift detected.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Color support
USE_COLOR=true
if [[ "${1:-}" == "--no-color" ]]; then
    USE_COLOR=false
fi

if $USE_COLOR; then
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    GREEN='' RED='' YELLOW='' BOLD='' RESET=''
fi

DRIFT=0

# Compare defined vs installed lists via comm.
# Args: $1=category name, $2=file with defined list, $3=file with installed list
#        $4=optional file with installed list for "not in dotfiles" direction
#           (useful when $3 is the full list and $4 is leaves-only)
compare_lists() {
    local category="$1" defined="$2" installed="$3"
    local installed_for_extra="${4:-$3}"
    local in_sync missing_from_system missing_from_dotfiles

    in_sync=$(comm -12 "$defined" "$installed")
    missing_from_system=$(comm -23 "$defined" "$installed")
    missing_from_dotfiles=$(comm -13 "$defined" "$installed_for_extra")

    local count_sync count_missing count_extra
    count_sync=$(echo -n "$in_sync" | grep -c '.' || true)
    count_missing=$(echo -n "$missing_from_system" | grep -c '.' || true)
    count_extra=$(echo -n "$missing_from_dotfiles" | grep -c '.' || true)

    echo -e "\n${BOLD}=== $category ===${RESET}"

    if [[ -n "$in_sync" ]]; then
        while IFS= read -r pkg; do
            echo -e "  ${GREEN}+ $pkg (in sync)${RESET}"
        done <<< "$in_sync"
    fi

    if [[ -n "$missing_from_system" ]]; then
        DRIFT=1
        while IFS= read -r pkg; do
            echo -e "  ${RED}- $pkg (not installed)${RESET}"
        done <<< "$missing_from_system"
    fi

    if [[ -n "$missing_from_dotfiles" ]]; then
        DRIFT=1
        while IFS= read -r pkg; do
            echo -e "  ${YELLOW}+ $pkg (not in dotfiles)${RESET}"
        done <<< "$missing_from_dotfiles"
    fi

    # Store counts for summary
    eval "COUNT_SYNC_${category//[^a-zA-Z]/_}=$count_sync"
    eval "COUNT_MISSING_${category//[^a-zA-Z]/_}=$count_missing"
    eval "COUNT_EXTRA_${category//[^a-zA-Z]/_}=$count_extra"
}

# Load ignore list for brew formulae
IGNORE_FILE="$ANSIBLE_DIR/homebrew_ignore.txt"
IGNORE_COUNT=0
if [[ -f "$IGNORE_FILE" ]]; then
    IGNORE_COUNT=$(grep -c '.' "$IGNORE_FILE" || true)
fi

# Temp files for sorted lists
tmp_defined=$(mktemp)
tmp_installed=$(mktemp)
tmp_leaves=$(mktemp)
tmp_ignore=$(mktemp)
trap 'rm -f "$tmp_defined" "$tmp_installed" "$tmp_leaves" "$tmp_ignore"' EXIT

CATEGORIES=()

# --- Brew taps ---
CATEGORIES+=("Brew_taps")
grep -v '^\s*$' "$ANSIBLE_DIR/homebrew_taps.txt" | sort > "$tmp_defined"
brew tap | sort > "$tmp_installed"
compare_lists "Brew taps" "$tmp_defined" "$tmp_installed"

# --- Brew formulae ---
CATEGORIES+=("Brew_formulae")
grep -v '^\s*$' "$ANSIBLE_DIR/homebrew_packages.txt" | sed 's|.*/||' | sort > "$tmp_defined"
brew list --formula | sort > "$tmp_installed"
brew leaves | sed 's|.*/||' | sort > "$tmp_leaves"
# Filter out ignored packages from leaves
if [[ -f "$IGNORE_FILE" ]]; then
    sort "$IGNORE_FILE" > "$tmp_ignore"
    comm -23 "$tmp_leaves" "$tmp_ignore" > "$tmp_leaves.filtered"
    mv "$tmp_leaves.filtered" "$tmp_leaves"
fi
compare_lists "Brew formulae" "$tmp_defined" "$tmp_installed" "$tmp_leaves"
if [[ $IGNORE_COUNT -gt 0 ]]; then
    echo -e "  ${BOLD}($IGNORE_COUNT formulae ignored via homebrew_ignore.txt)${RESET}"
fi

# --- Brew casks ---
CATEGORIES+=("Brew_casks")
grep -v '^\s*$' "$ANSIBLE_DIR/homebrew_casks.txt" | grep -v '^font-' | sort > "$tmp_defined"
brew list --cask | grep -v '^font-' | sort > "$tmp_installed"
compare_lists "Brew casks" "$tmp_defined" "$tmp_installed"

# --- Brew fonts ---
CATEGORIES+=("Brew_fonts")
grep '^font-' "$ANSIBLE_DIR/homebrew_casks.txt" | sort > "$tmp_defined"
brew list --cask | grep '^font-' | sort > "$tmp_installed"
compare_lists "Brew fonts" "$tmp_defined" "$tmp_installed"

# --- NPM global packages ---
CATEGORIES+=("NPM_packages")
printf '%s\n' \
    "@google/gemini-cli" \
    "@mermaid-js/mermaid-cli" \
    "eslint" \
    "generator-office" \
    "markdownlint-cli" \
    "pyright" \
    "ts-node" \
    "typescript" \
    "typescript-language-server" \
    "yo" \
    | sort > "$tmp_defined"
npm list -g --depth=0 --parseable 2>/dev/null \
    | tail -n +2 \
    | sed 's|.*/node_modules/||' \
    | sort > "$tmp_installed"
compare_lists "NPM packages" "$tmp_defined" "$tmp_installed"

# --- Pipx packages ---
CATEGORIES+=("Pipx_packages")
printf '%s\n' \
    "git-filter-repo" \
    | sort > "$tmp_defined"
pipx list --short 2>/dev/null \
    | awk '{print $1}' \
    | sort > "$tmp_installed"
compare_lists "Pipx packages" "$tmp_defined" "$tmp_installed"

# --- Go tools ---
CATEGORIES+=("Go_tools")
printf '%s\n' \
    "air" \
    "cobra-cli" \
    "deadcode" \
    "dlv" \
    "errcheck" \
    "goda" \
    "goimports" \
    "golangci-lint" \
    "golines" \
    "golint" \
    "gopls" \
    "gotestsum" \
    "gotime" \
    "govulncheck" \
    "ineffassign" \
    "LogScanner" \
    "modgraphviz" \
    "pkgsite" \
    "protoc-gen-go" \
    "scc" \
    "shadow" \
    "skate" \
    "staticcheck" \
    "tour" \
    "vhs" \
    | sort > "$tmp_defined"
GOBIN="${GOBIN:-${GOPATH:-$HOME/.go}/bin}"
ls "$GOBIN" 2>/dev/null \
    | grep -v '^\.' \
    | grep -v '^go[0-9]' \
    | grep -v '^pkg$' \
    | sort > "$tmp_installed"
compare_lists "Go tools" "$tmp_defined" "$tmp_installed"

# --- VS Code extensions ---
CATEGORIES+=("VS_Code_extensions")
grep -v '^\s*$' "$ANSIBLE_DIR/vscode_extensions.txt" | sort > "$tmp_defined"
code --list-extensions 2>/dev/null | sort > "$tmp_installed"
compare_lists "VS Code extensions" "$tmp_defined" "$tmp_installed"

# --- Applications ---
CATEGORIES+=("Applications")
APPS_FILE="$ANSIBLE_DIR/applications.txt"
if [[ -f "$APPS_FILE" ]]; then
    grep -v '^\s*$' "$APPS_FILE" | sort > "$tmp_defined"
    ls /Applications/ 2>/dev/null \
        | sed 's/\.app$//' \
        | sort > "$tmp_installed"
    compare_lists "Applications" "$tmp_defined" "$tmp_installed"
fi

# --- Summary table ---
echo -e "\n${BOLD}=== Summary ===${RESET}"
printf "%-20s %8s %12s %14s\n" "Category" "In sync" "Not installed" "Not in dotfiles"
printf "%-20s %8s %12s %14s\n" "--------" "-------" "-------------" "---------------"

for cat in "${CATEGORIES[@]}"; do
    sync_var="COUNT_SYNC_${cat}"
    missing_var="COUNT_MISSING_${cat}"
    extra_var="COUNT_EXTRA_${cat}"
    label="${cat//_/ }"
    printf "%-20s %8s %12s %14s\n" "$label" "${!sync_var}" "${!missing_var}" "${!extra_var}"
done

echo ""
if [[ $DRIFT -eq 0 ]]; then
    echo -e "${GREEN}All in sync!${RESET}"
else
    echo -e "${YELLOW}Drift detected.${RESET}"
fi

exit $DRIFT
