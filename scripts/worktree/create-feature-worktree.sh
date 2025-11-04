#!/bin/bash
# create-feature-worktree.sh - Create linked worktrees across multiple repos
# Part of MI6: Agent Organization for Developers
# https://github.com/imboard-ai/mi6

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check prerequisites
check_prerequisites() {
  # Check if .ai-project.json exists
  if [ ! -f ".ai-project.json" ]; then
    error ".ai-project.json not found in current directory

Run this script from your project root, or initialize with:
  Use MI6 project-init dossier first"
  fi

  # Check if JSON is valid and has repos
  if ! cat .ai-project.json | python3 -c "import json, sys; json.load(sys.stdin)" 2>/dev/null && \
     ! cat .ai-project.json | node -e "JSON.parse(require('fs').readFileSync('/dev/stdin', 'utf8'))" 2>/dev/null; then
    error ".ai-project.json is not valid JSON"
  fi
}

# Parse repos from .ai-project.json
parse_repos() {
  # Try jq first (cleanest)
  if command -v jq &> /dev/null; then
    jq -r '.repos[]? | "\(.name):\(.path)"' .ai-project.json
  # Try node
  elif command -v node &> /dev/null; then
    node -e "
      const config = JSON.parse(require('fs').readFileSync('.ai-project.json', 'utf8'));
      if (config.repos) {
        config.repos.forEach(r => console.log(r.name + ':' + r.path));
      }
    "
  # Try python
  elif command -v python3 &> /dev/null; then
    python3 -c "
import json
with open('.ai-project.json') as f:
    config = json.load(f)
    for repo in config.get('repos', []):
        print(f\"{repo['name']}:{repo['path']}\")
    "
  else
    error "No JSON parser found (need jq, node, or python3)"
  fi
}

# Main script
main() {
  echo "🕵️  MI6 Worktree Creation"
  echo "========================="
  echo ""

  # Check for feature name argument
  if [ -z "$1" ]; then
    error "Feature name required

Usage: $0 <feature-name>

Example:
  $0 dashboard-redesign
  $0 feature-auth-v2"
  fi

  FEATURE_NAME="$1"
  WORKTREE_BASE=".worktrees/$FEATURE_NAME"

  info "Feature: $FEATURE_NAME"
  info "Worktree location: $WORKTREE_BASE"
  echo ""

  # Prerequisites
  info "Checking prerequisites..."
  check_prerequisites
  success "Configuration valid"
  echo ""

  # Parse repos
  info "Reading repository configuration..."
  REPOS=$(parse_repos)

  if [ -z "$REPOS" ]; then
    error "No repos found in .ai-project.json

Make sure your .ai-project.json has a 'repos' array:
  {
    \"repos\": [
      {\"name\": \"backend\", \"path\": \"./backend\"},
      {\"name\": \"frontend\", \"path\": \"./frontend\"}
    ]
  }"
  fi

  REPO_COUNT=$(echo "$REPOS" | wc -l)
  success "Found $REPO_COUNT repositories"
  echo ""

  # Create worktree base directory
  info "Creating worktree structure..."
  mkdir -p "$WORKTREE_BASE"
  success "Created: $WORKTREE_BASE/"
  echo ""

  # Create worktree for each repo
  info "Creating worktrees for each repository..."
  echo ""

  ERRORS=0
  while IFS=: read -r repo_name repo_path; do
    echo "  📦 $repo_name"

    # Resolve path (remove leading ./)
    repo_path="${repo_path#./}"

    # Check if repo exists
    if [ ! -d "$repo_path" ]; then
      warning "  Repository not found: $repo_path (skipping)"
      ((ERRORS++))
      continue
    fi

    # Check if it's a git repo
    if [ ! -d "$repo_path/.git" ]; then
      warning "  Not a git repository: $repo_path (skipping)"
      ((ERRORS++))
      continue
    fi

    # Create worktree
    WORKTREE_PATH="$WORKTREE_BASE/$repo_name"

    # Check if branch already exists
    if git -C "$repo_path" show-ref --verify --quiet "refs/heads/$FEATURE_NAME"; then
      warning "  Branch '$FEATURE_NAME' already exists in $repo_name"
      echo "    Creating worktree with existing branch..."

      if git -C "$repo_path" worktree add "../$WORKTREE_PATH" "$FEATURE_NAME" 2>/dev/null; then
        success "  Created worktree (existing branch)"
      else
        warning "  Failed to create worktree (may already exist)"
        ((ERRORS++))
      fi
    else
      # Create new branch
      if git -C "$repo_path" worktree add "../$WORKTREE_PATH" -b "$FEATURE_NAME" 2>/dev/null; then
        success "  Created worktree with new branch"
      else
        warning "  Failed to create worktree"
        ((ERRORS++))
      fi
    fi

    echo ""
  done <<< "$REPOS"

  # Summary
  echo "========================="
  if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Worktrees created successfully!${NC}"
  else
    echo -e "${YELLOW}⚠️  Completed with $ERRORS warnings${NC}"
  fi
  echo ""

  # Show next steps
  echo "📂 Location: $WORKTREE_BASE/"
  echo ""
  echo "🔀 Next steps:"
  echo "  cd $WORKTREE_BASE/<repo-name>"
  echo "  # Make your changes"
  echo "  git add . && git commit -m \"Your changes\""
  echo ""
  echo "🧹 When done:"
  echo "  \$MI6_PATH/scripts/worktree/cleanup-worktree.sh $FEATURE_NAME"
  echo ""
}

# Run main function
main "$@"
