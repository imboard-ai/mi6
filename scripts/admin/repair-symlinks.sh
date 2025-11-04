#!/bin/bash
# repair-symlinks.sh - Fix broken symlinks in MI6-managed projects
# Part of MI6: Agent Organization for Developers
# https://github.com/imboard-ai/mi6

set -e

echo "🕵️  MI6 Symlink Repair Tool"
echo "==========================="
echo ""

# Check if MI6_PATH is set
if [ -z "$MI6_PATH" ]; then
  echo "❌ Error: MI6_PATH not set"
  echo ""
  echo "Run setup first: \$MI6_PATH/scripts/admin/setup-env.sh"
  exit 1
fi

# Get the project directory (current directory)
PROJECT_DIR="$(pwd)"

echo "Checking for broken symlinks in: $PROJECT_DIR"
echo ""

# Find broken symlinks
BROKEN_LINKS=$(find "$PROJECT_DIR" -maxdepth 3 -type l ! -exec test -e {} \; -print 2>/dev/null || true)

if [ -z "$BROKEN_LINKS" ]; then
  echo "✅ No broken symlinks found!"
  exit 0
fi

echo "Found broken symlinks:"
echo "$BROKEN_LINKS"
echo ""

# Count broken links
LINK_COUNT=$(echo "$BROKEN_LINKS" | wc -l)
echo "Total broken symlinks: $LINK_COUNT"
echo ""

read -p "Do you want to remove these broken symlinks? (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "$BROKEN_LINKS" | while read -r link; do
    if [ -n "$link" ]; then
      echo "  Removing: $link"
      rm "$link"
    fi
  done
  echo ""
  echo "✅ Broken symlinks removed"
else
  echo "No changes made"
fi

echo ""
echo "Note: Consider using MI6_PATH environment variable instead of symlinks"
echo "See: \$MI6_PATH/docs/environment-setup.md"
