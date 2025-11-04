#!/bin/bash
# cleanup-worktree.sh - Safely remove worktrees when feature work is complete
# Part of MI6: Agent Organization for Developers
# https://github.com/imboard-ai/mi6

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Helper functions
error() {
  echo -e "${RED}❌ Error: $1${NC}" >&2
  exit 1
}

success() {
  echo -e "${GREEN}✓ $1${NC}"
}

warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

# Parse options
DELETE_BRANCHES=false
FORCE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --delete-branches)
      DELETE_BRANCHES=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [options] <feature-name>"
      echo ""
      echo "Options:"
      echo "  --delete-branches    Also delete feature branches from repos"
      echo "  --force              Skip uncommitted changes check (DANGEROUS)"
      echo ""
      echo "Examples:"
      echo "  $0 dashboard-v3                      # Remove worktrees only"
      echo "  $0 dashboard-v3 --delete-branches    # Remove worktrees and branches"
      echo "  $0 old-feature --force               # Force remove (skip checks)"
      exit 0
      ;;
    *)
      FEATURE_NAME="$1"
      shift
      ;;
  esac
done

# Check feature name provided
if [ -z "$FEATURE_NAME" ]; then
  error "Feature name required

Usage: $0 <feature-name>

Example:
  $0 dashboard-redesign"
fi

WORKTREE_BASE=".worktrees/$FEATURE_NAME"

# Main script
main() {
  echo "🕵️  MI6 Worktree Cleanup"
  echo "========================"
  echo ""

  info "Feature: $FEATURE_NAME"
  info "Location: $WORKTREE_BASE"
  echo ""

  # Check if worktree exists
  if [ ! -d "$WORKTREE_BASE" ]; then
    error "Worktree not found: $WORKTREE_BASE

Available worktrees:
$(ls -d .worktrees/*/ 2>/dev/null | xargs -n1 basename 2>/dev/null || echo '  (none)')"
  fi

  # Find all repos in worktree
  REPOS=$(find "$WORKTREE_BASE" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort)

  if [ -z "$REPOS" ]; then
    warning "No repositories found in worktree"
    echo ""
    info "Removing empty worktree directory..."
    rm -rf "$WORKTREE_BASE"
    success "Removed: $WORKTREE_BASE"
    exit 0
  fi

  # Check for uncommitted changes (unless --force)
  if [ "$FORCE" = false ]; then
    info "Checking for uncommitted changes..."
    echo ""

    HAS_CHANGES=false
    while IFS= read -r repo; do
      REPO_PATH="$WORKTREE_BASE/$repo"

      if [ ! -d "$REPO_PATH/.git" ] && [ ! -f "$REPO_PATH/.git" ]; then
        continue
      fi

      # Check for uncommitted work
      if ! git -C "$REPO_PATH" diff --quiet 2>/dev/null || \
         ! git -C "$REPO_PATH" diff --cached --quiet 2>/dev/null || \
         [ -n "$(git -C "$REPO_PATH" ls-files --others --exclude-standard 2>/dev/null)" ]; then

        warning "Uncommitted changes in $repo:"
        git -C "$REPO_PATH" status --short | sed 's/^/    /'
        echo ""
        HAS_CHANGES=true
      fi
    done <<< "$REPOS"

    if [ "$HAS_CHANGES" = true ]; then
      echo -e "${RED}❌ Cleanup aborted - uncommitted changes detected${NC}"
      echo ""
      echo "Options:"
      echo "  1. Commit your changes first"
      echo "  2. Stash your changes: git stash"
      echo "  3. Force remove anyway: $0 $FEATURE_NAME --force (DATA LOSS!)"
      exit 1
    fi

    success "All repos clean"
    echo ""
  fi

  # Confirmation prompt
  echo "About to remove:"
  echo "  📂 $WORKTREE_BASE/"
  while IFS= read -r repo; do
    echo "     - $repo/"
  done <<< "$REPOS"

  if [ "$DELETE_BRANCHES" = true ]; then
    echo ""
    warning "Will also DELETE branches:"
    while IFS= read -r repo; do
      echo "     - $FEATURE_NAME (in $repo)"
    done <<< "$REPOS"
  fi

  echo ""
  read -p "Continue? (y/N) " -n 1 -r
  echo ""

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled"
    exit 0
  fi

  # Remove worktree directory
  info "Removing worktree directory..."
  rm -rf "$WORKTREE_BASE"
  success "Removed: $WORKTREE_BASE/"
  echo ""

  # Prune git references
  info "Pruning git worktree references..."
  echo ""

  # Find original repos from .ai-project.json or scan
  if [ -f ".ai-project.json" ]; then
    # Parse repos from config
    if command -v jq &> /dev/null; then
      REPO_PATHS=$(jq -r '.repos[]?.path' .ai-project.json | sed 's#^./##')
    elif command -v node &> /dev/null; then
      REPO_PATHS=$(node -e "
        const config = JSON.parse(require('fs').readFileSync('.ai-project.json', 'utf8'));
        if (config.repos) {
          config.repos.forEach(r => console.log(r.path.replace(/^\.\//, '')));
        }
      ")
    else
      # Fallback: scan for .git directories
      REPO_PATHS=$(find . -maxdepth 2 -name ".git" -type d | sed 's#/.git##' | sed 's#^./##')
    fi
  else
    # No config, scan for repos
    REPO_PATHS=$(find . -maxdepth 2 -name ".git" -type d | sed 's#/.git##' | sed 's#^./##')
  fi

  # Prune each repo
  while IFS= read -r repo_path; do
    if [ -n "$repo_path" ] && [ -d "$repo_path/.git" ]; then
      echo "  📦 $(basename "$repo_path")"
      git -C "$repo_path" worktree prune 2>/dev/null || true
      success "    Pruned"
    fi
  done <<< "$REPO_PATHS"

  echo ""

  # Delete branches if requested
  if [ "$DELETE_BRANCHES" = true ]; then
    info "Deleting feature branches..."
    echo ""

    while IFS= read -r repo_path; do
      if [ -n "$repo_path" ] && [ -d "$repo_path/.git" ]; then
        REPO_NAME=$(basename "$repo_path")
        echo "  📦 $REPO_NAME"

        # Check if branch exists
        if git -C "$repo_path" show-ref --verify --quiet "refs/heads/$FEATURE_NAME"; then
          # Try to delete
          if git -C "$repo_path" branch -d "$FEATURE_NAME" 2>/dev/null; then
            success "    Deleted branch: $FEATURE_NAME"
          else
            # Try force delete
            warning "    Branch not fully merged"
            if git -C "$repo_path" branch -D "$FEATURE_NAME" 2>/dev/null; then
              warning "    Force deleted: $FEATURE_NAME"
            else
              warning "    Failed to delete branch"
            fi
          fi
        else
          echo "    (branch not found)"
        fi
      fi
    done <<< "$REPO_PATHS"

    echo ""
  fi

  # Summary
  echo "========================="
  success "Cleanup complete!"
  echo ""

  if [ "$DELETE_BRANCHES" = false ]; then
    info "Note: Feature branches were kept"
    echo "  Delete manually: git branch -D $FEATURE_NAME"
    echo ""
  fi
}

# Run main
main
