#!/bin/bash
# setup-env.sh - Configure MI6_PATH environment variable for shell
# Part of MI6: Agent Organization for Developers
# https://github.com/imboard-ai/mi6

set -e

echo "🕵️  MI6 Environment Setup"
echo "=========================="
echo ""

# Detect shell type
SHELL_RC=""
SHELL_NAME=""

if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
  SHELL_NAME="zsh"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_RC="$HOME/.bashrc"
  SHELL_NAME="bash"
else
  echo "❌ Error: Unsupported shell. This script supports bash and zsh only."
  exit 1
fi

echo "✓ Detected shell: $SHELL_NAME"
echo "✓ Configuration file: $SHELL_RC"
echo ""

# Detect MI6 directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MI6_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "✓ MI6 directory detected: $MI6_DIR"
echo ""

# Check if MI6_PATH is already set
if grep -q "export MI6_PATH=" "$SHELL_RC" 2>/dev/null; then
  echo "⚠️  MI6_PATH is already configured in $SHELL_RC"
  echo ""
  echo "Current configuration:"
  grep "MI6_PATH" "$SHELL_RC"
  echo ""
  read -p "Do you want to update it? (y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled. No changes made."
    exit 0
  fi
  # Remove old configuration
  sed -i.bak '/export MI6_PATH=/d' "$SHELL_RC"
  echo "✓ Removed old MI6_PATH configuration"
fi

# Add MI6_PATH to shell config
echo "" >> "$SHELL_RC"
echo "# MI6 Agent Organization Framework" >> "$SHELL_RC"
echo "export MI6_PATH=\"$MI6_DIR\"" >> "$SHELL_RC"

echo "✅ Successfully added MI6_PATH to $SHELL_RC"
echo ""
echo "Next steps:"
echo "1. Reload your shell configuration:"
echo "   source $SHELL_RC"
echo ""
echo "2. Verify MI6_PATH is set:"
echo "   echo \$MI6_PATH"
echo ""
echo "3. Explore MI6 resources:"
echo "   ls \$MI6_PATH/workflows"
echo "   ls \$MI6_PATH/templates"
echo "   ls \$MI6_PATH/scripts"
echo ""
echo "🎉 Setup complete! MI6 is ready to use."
