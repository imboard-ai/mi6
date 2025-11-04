#!/bin/bash
# verify-setup.sh - Verify MI6 environment is configured correctly
# Part of MI6: Agent Organization for Developers
# https://github.com/imboard-ai/mi6

set -e

echo "🕵️  MI6 Setup Verification"
echo "=========================="
echo ""

# Check if MI6_PATH is set
if [ -z "$MI6_PATH" ]; then
  echo "❌ MI6_PATH is not set"
  echo ""
  echo "Please run the setup script first:"
  echo "  $HOME/projects/mi6/scripts/admin/setup-env.sh"
  echo ""
  echo "Then reload your shell:"
  echo "  source ~/.bashrc  # or ~/.zshrc"
  exit 1
fi

echo "✓ MI6_PATH is set: $MI6_PATH"
echo ""

# Check if MI6_PATH directory exists
if [ ! -d "$MI6_PATH" ]; then
  echo "❌ MI6_PATH directory does not exist: $MI6_PATH"
  echo ""
  echo "Please verify the path is correct or re-run setup."
  exit 1
fi

echo "✓ MI6_PATH directory exists"
echo ""

# Check for key directories
MISSING_DIRS=()

for dir in scripts workflows templates prompts docs; do
  if [ ! -d "$MI6_PATH/$dir" ]; then
    MISSING_DIRS+=("$dir")
  fi
done

if [ ${#MISSING_DIRS[@]} -gt 0 ]; then
  echo "⚠️  Warning: Some expected directories are missing:"
  for dir in "${MISSING_DIRS[@]}"; do
    echo "  - $dir/"
  done
  echo ""
  echo "This might be normal if you're using an older version of MI6."
  echo ""
else
  echo "✓ All core directories present"
  echo ""
fi

# Check for key files
echo "Directory structure:"
ls -la "$MI6_PATH" | grep "^d" | awk '{print "  " $NF}' | grep -v "^\.$" | grep -v "^\.\.$"
echo ""

# Check git status if this is a git repo
if [ -d "$MI6_PATH/.git" ]; then
  echo "Git information:"
  cd "$MI6_PATH"
  echo "  Branch: $(git branch --show-current)"
  echo "  Remote: $(git remote get-url origin 2>/dev/null || echo 'No remote')"
  echo "  Last commit: $(git log -1 --oneline 2>/dev/null || echo 'No commits')"
  echo ""
fi

echo "✅ MI6 environment verification complete!"
echo ""
echo "You can now use MI6 resources:"
echo "  ls \$MI6_PATH/workflows"
echo "  ls \$MI6_PATH/templates"
echo "  ls \$MI6_PATH/scripts"
