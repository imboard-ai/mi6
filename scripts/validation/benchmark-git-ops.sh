#!/bin/bash
# benchmark-git-ops.sh - Monitor git repository performance
# Part of MI6: Agent Organization for Developers
# https://github.com/imboard-ai/mi6

set -e

echo "📊 Git Performance Benchmark"
echo "=============================="
echo ""

# Check if in git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "❌ Not a git repository"
  exit 1
fi

echo "Repository: $(basename "$(git rev-parse --show-toplevel)")"
echo "Branch: $(git branch --show-current)"
echo ""

# Benchmark git status
echo "⏱️  Benchmarking git operations..."
echo ""

echo -n "git status: "
{ time git status > /dev/null 2>&1; } 2>&1 | grep real | awk '{print $2}'

echo -n "git log (last 100): "
{ time git log -100 --oneline > /dev/null 2>&1; } 2>&1 | grep real | awk '{print $2}'

echo -n "git grep 'TODO': "
{ time git grep 'TODO' > /dev/null 2>&1; } 2>&1 | grep real | awk '{print $2}' || echo "N/A (no matches)"

echo ""
echo "📦 Repository Size:"
echo ""

# Repo size
if [ -d ".git" ]; then
  echo "  .git directory: $(du -sh .git | awk '{print $1}')"
fi

# File count
file_count=$(git ls-files | wc -l)
echo "  Tracked files: $file_count"

# Object count
object_count=$(git count-objects -v | grep "^count:" | awk '{print $2}')
echo "  Loose objects: $object_count"

# Pack size
pack_size=$(git count-objects -v | grep "^size-pack:" | awk '{print $2}')
if [ "$pack_size" -gt 0 ]; then
  pack_size_mb=$((pack_size / 1024))
  echo "  Pack size: ${pack_size_mb} MB"
fi

echo ""
echo "⚠️  Consider archiving if:"
echo "  - git status > 2 seconds"
echo "  - .git directory > 500MB"
echo "  - Tracked files > 5000"
echo "  - Pack size > 100MB"
echo ""

# Check thresholds
needs_optimization=false

# Extract time in seconds (works with real time output)
status_time=$(git status 2>&1 | grep -oE 'real.*' | awk '{print $2}' || echo "0m0.0s")
# Convert to seconds (simplified - assumes format like "0m1.5s")
# status_seconds=$(echo "$status_time" | sed 's/m/*60+/;s/s//' | bc)

# Simple check: if git status output is slow
if [ -d ".git/objects/pack" ]; then
  pack_count=$(find .git/objects/pack -name "*.pack" 2>/dev/null | wc -l)
  if [ "$pack_count" -gt 20 ]; then
    echo "⚠️  Many pack files detected ($pack_count). Consider: git gc"
    needs_optimization=true
  fi
fi

if [ "$file_count" -gt 5000 ]; then
  echo "⚠️  Large number of tracked files ($file_count)"
  needs_optimization=true
fi

if [ "$needs_optimization" = true ]; then
  echo ""
  echo "💡 Optimization suggestions:"
  echo "  - Run: git gc --aggressive"
  echo "  - Archive old files to separate repo"
  echo "  - Use .gitignore for large files"
fi

echo ""
echo "✅ Benchmark complete"
