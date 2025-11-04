#!/bin/bash
# list-worktrees.sh - Display all active worktrees with their status
# Part of MI6: Agent Organization for Developers
# https://github.com/imboard-ai/mi6

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Helper functions
info() {
  echo -e "${BLUE}$1${NC}"
}

success() {
  echo -e "${GREEN}$1${NC}"
}

warning() {
  echo -e "${YELLOW}$1${NC}"
}

# Parse command line options
FILTER_FEATURE=""
DIRTY_ONLY=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --dirty)
      DIRTY_ONLY=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [options] [feature-name]"
      echo ""
      echo "Options:"
      echo "  --dirty          Show only worktrees with uncommitted changes"
      echo "  feature-name     Filter to specific feature"
      echo ""
      echo "Examples:"
      echo "  $0                    # List all worktrees"
      echo "  $0 dashboard-v3       # Show only dashboard-v3"
      echo "  $0 --dirty            # Show worktrees with uncommitted changes"
      exit 0
      ;;
    *)
      FILTER_FEATURE="$1"
      shift
      ;;
  esac
done

# Main script
main() {
  echo "🕵️  MI6 Worktree Status"
  echo "======================"
  echo ""

  # Check if .worktrees directory exists
  if [ ! -d ".worktrees" ]; then
    warning "No .worktrees directory found"
    echo ""
    echo "Create worktrees with:"
    echo "  \$MI6_PATH/scripts/worktree/create-feature-worktree.sh <feature-name>"
    exit 0
  fi

  # Find all worktree features
  FEATURES=$(find .worktrees -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort)

  if [ -z "$FEATURES" ]; then
    warning "No worktrees found in .worktrees/"
    exit 0
  fi

  # Filter if specified
  if [ -n "$FILTER_FEATURE" ]; then
    FEATURES=$(echo "$FEATURES" | grep "$FILTER_FEATURE" || true)
    if [ -z "$FEATURES" ]; then
      warning "No worktrees matching '$FILTER_FEATURE'"
      exit 0
    fi
  fi

  # List each feature
  while IFS= read -r feature; do
    FEATURE_PATH=".worktrees/$feature"

    # Find repos in this feature
    REPOS=$(find "$FEATURE_PATH" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort)

    if [ -z "$REPOS" ]; then
      continue
    fi

    # Check if any repo has changes (for --dirty filter)
    if [ "$DIRTY_ONLY" = true ]; then
      HAS_CHANGES=false
      while IFS= read -r repo; do
        REPO_PATH="$FEATURE_PATH/$repo"
        if [ -d "$REPO_PATH/.git" ] || [ -f "$REPO_PATH/.git" ]; then
          if ! git -C "$REPO_PATH" diff --quiet 2>/dev/null || \
             ! git -C "$REPO_PATH" diff --cached --quiet 2>/dev/null || \
             [ -n "$(git -C "$REPO_PATH" ls-files --others --exclude-standard 2>/dev/null)" ]; then
            HAS_CHANGES=true
            break
          fi
        fi
      done <<< "$REPOS"

      if [ "$HAS_CHANGES" = false ]; then
        continue
      fi
    fi

    # Display feature header
    echo -e "${CYAN}📁 $feature${NC}"
    echo ""

    # List each repo in feature
    while IFS= read -r repo; do
      REPO_PATH="$FEATURE_PATH/$repo"

      echo "  📦 $repo"

      # Check if it's a valid git worktree
      if [ ! -d "$REPO_PATH/.git" ] && [ ! -f "$REPO_PATH/.git" ]; then
        echo "     ⚠️  Not a git repository"
        echo ""
        continue
      fi

      # Get branch name
      BRANCH=$(git -C "$REPO_PATH" branch --show-current 2>/dev/null || echo "unknown")
      echo "     🔀 Branch: $BRANCH"

      # Get status (clean/dirty)
      if git -C "$REPO_PATH" diff --quiet 2>/dev/null && \
         git -C "$REPO_PATH" diff --cached --quiet 2>/dev/null && \
         [ -z "$(git -C "$REPO_PATH" ls-files --others --exclude-standard 2>/dev/null)" ]; then
        echo -e "     ${GREEN}✓ Clean${NC}"
      else
        # Count changes
        MODIFIED=$(git -C "$REPO_PATH" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
        STAGED=$(git -C "$REPO_PATH" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
        UNTRACKED=$(git -C "$REPO_PATH" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

        echo -e "     ${YELLOW}⚠  Uncommitted changes${NC}"
        if [ "$MODIFIED" -gt 0 ]; then
          echo "       - $MODIFIED modified"
        fi
        if [ "$STAGED" -gt 0 ]; then
          echo "       - $STAGED staged"
        fi
        if [ "$UNTRACKED" -gt 0 ]; then
          echo "       - $UNTRACKED untracked"
        fi
      fi

      # Get last commit
      LAST_COMMIT=$(git -C "$REPO_PATH" log -1 --oneline 2>/dev/null || echo "no commits")
      echo "     📝 Last: $LAST_COMMIT"

      echo ""
    done <<< "$REPOS"

  done <<< "$FEATURES"

  echo "======================"
  TOTAL=$(echo "$FEATURES" | wc -l | tr -d ' ')
  echo "Total worktrees: $TOTAL"
  echo ""
  echo "💡 Tip: Use --dirty to show only worktrees with uncommitted changes"
}

# Run main
main
