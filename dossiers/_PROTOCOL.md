# MI6 Dossier Execution Protocol

**Version**: 1.0 (follows [Dossier Standard Protocol v1.0](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md))
**Status**: Stable
**Last Updated**: 2025-11-05

---

## Overview

MI6 dossiers follow the **[Dossier Standard Protocol v1.0](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md)**, which defines standard execution guidelines for all dossiers.

> **📚 Full Protocol**: See the [Dossier Protocol](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md) for comprehensive execution guidelines, self-improvement system, safety guidelines, and validation patterns.

---

## Quick Reference

The Dossier Protocol v1.0 provides:

### 🔄 Self-Improvement Protocol
- Meta-analysis before execution
- Context-aware improvement suggestions
- User-driven enhancements
- Continuous dossier improvement

**[Learn more →](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md#-self-improvement-protocol)**

### 📋 Execution Guidelines
- Transparency and safety principles
- Standard execution flow
- Context gathering best practices
- Decision-making patterns

**[Learn more →](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md#-standard-execution-guidelines)**

### 🎨 Output Standards
- Consistent emoji/icon usage
- Progress reporting formats
- Summary formats

**[Learn more →](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md#-output-format-standards)**

### 💾 Safety Guidelines
- Backup creation
- Destructive operation confirmation
- Uncommitted changes checks
- Rollback instructions

**[Learn more →](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md#-safety-guidelines)**

### ✅ Validation Patterns
- File existence checks
- JSON validation
- Git status validation
- Success criteria formats

**[Learn more →](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md#-validation-patterns)**

---

## MI6-Specific Extensions

The following extensions apply specifically to MI6 dossiers:

### Environment Variables

**Always use MI6 environment variables**:
```bash
$MI6_PATH  # MI6 installation directory
```

**Example**:
```bash
# ✅ Correct
cat $MI6_PATH/dossiers/project-init.md

# ❌ Incorrect
cat /path/to/mi6/dossiers/project-init.md
```

### Configuration Files

**MI6 dossiers interact with**:
- `.ai-project.json` - Project configuration (multi-repo info)
- `AI_GUIDE.md` - Project guidance for LLMs
- `.aicontextignore` - Context filtering
- `tasks/` - Task management structure

**Example validation**:
```bash
# Check for MI6 project configuration
if [ ! -f ".ai-project.json" ]; then
  echo "❌ Not an MI6 project (missing .ai-project.json)"
  echo "💡 Run project-init dossier first"
  exit 1
fi
```

### Dossier Registry

**Update REGISTRY.md when creating new dossiers**:

When you create a new MI6 dossier, add it to [REGISTRY.md](./REGISTRY.md):
1. Add to Quick Reference table
2. Document relationships with other dossiers
3. List outputs produced
4. Add to appropriate journey/workflow

### Output Locations

**Standard MI6 paths**:
```bash
$MI6_PATH/dossiers/           # Dossier definitions
$MI6_PATH/templates/          # File templates
$MI6_PATH/scripts/            # Utility scripts
$MI6_PATH/workflows/          # Documentation

# Project-level paths
.ai-project.json              # Project configuration
AI_GUIDE.md                   # Project AI guide
tasks/                        # Task management
  planned/                    # Planned tasks
  active/                     # Active tasks
  completed/                  # Completed tasks
.worktrees/                   # Feature worktrees
```

### Multi-Repo Awareness

**MI6 dossiers should detect and handle**:
- Single-repo projects
- Multi-repo projects (from .ai-project.json)
- Monorepo projects

**Example context gathering**:
```bash
# Detect project structure
if [ -f ".ai-project.json" ]; then
  # Parse repository count
  repo_count=$(cat .ai-project.json | grep -o '"path"' | wc -l)

  if [ "$repo_count" -gt 1 ]; then
    echo "✓ Multi-repo project detected ($repo_count repos)"
  else
    echo "✓ Single-repo project"
  fi
else
  echo "⚠️  No .ai-project.json found"
  echo "💡 This may not be an MI6 project yet"
fi
```

### Worktree Integration

**For dossiers working with worktrees**:
- Check `.worktrees/` directory structure
- Validate worktree branches match feature name
- Ensure all repos in `.ai-project.json` have corresponding worktrees

**Example**:
```bash
# Validate worktree structure
feature_name="$1"
worktree_dir=".worktrees/$feature_name"

if [ ! -d "$worktree_dir" ]; then
  echo "❌ Worktree directory not found: $worktree_dir"
  exit 1
fi

echo "✓ Worktree directory exists: $worktree_dir"
```

---

## Using This Protocol

### For LLM Agents Executing MI6 Dossiers

When executing MI6 dossiers:

1. **Read the standard protocol**
   - Review [Dossier Protocol v1.0](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md)
   - Follow all standard guidelines

2. **Apply MI6-specific extensions**
   - Use `$MI6_PATH` environment variable
   - Check for `.ai-project.json`
   - Follow MI6 conventions

3. **Perform self-improvement analysis**
   - Analyze dossier quality before execution
   - Suggest improvements based on project context
   - Allow user to accept/skip suggestions

4. **Execute with standard protocol**
   - Gather context thoroughly
   - Show progress clearly
   - Validate results
   - Report outcome

5. **Verify MI6-specific success criteria**
   - Check MI6 configuration files created/updated
   - Validate against MI6 project structure
   - Ensure compatibility with other MI6 dossiers

### For MI6-Operators (Dossier Authors)

When creating MI6 dossiers:

1. **Reference the protocol**
   ```markdown
   **Protocol Version**: 1.0 ([Dossier Protocol](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md))
   ```

2. **Follow standard structure**
   - Use the [dossier template](https://github.com/imboard-ai/dossier/blob/main/templates/dossier-template.md)
   - Include all required sections
   - Add comprehensive examples

3. **Apply MI6 conventions**
   - Use `$MI6_PATH` in all paths
   - Reference `.ai-project.json` when needed
   - Update REGISTRY.md

4. **Test thoroughly**
   - Test in greenfield scenarios
   - Test in brownfield scenarios
   - Test with single and multi-repo projects
   - Verify with multiple LLMs if possible

### For MI6-Citizens (Dossier Users)

When using MI6 dossiers:

1. **Trust the self-improvement system**
   - Review suggestions when offered
   - Accept improvements that help your project
   - Skip when in a hurry (totally fine!)

2. **Provide feedback**
   - Report issues via GitHub
   - Suggest improvements
   - Share successful usage patterns

3. **Use natural language**
   ```
   "Use the project-init dossier to set up MI6"
   "Run the worktree-cleanup dossier for feature-x"
   ```

---

## See Also

### Dossier Standard
- **[Dossier Protocol v1.0](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md)** - Complete protocol specification
- **[Dossier Specification](https://github.com/imboard-ai/dossier/blob/main/SPECIFICATION.md)** - Formal dossier standard
- **[Dossier Project](https://github.com/imboard-ai/dossier)** - Universal automation standard

### MI6 Documentation
- **[Dossiers README](./README.md)** - How to use MI6 dossiers
- **[REGISTRY.md](./REGISTRY.md)** - Complete MI6 dossier catalog
- **[Main README](../README.md)** - MI6 overview
- **[CONTRIBUTING.md](../CONTRIBUTING.md)** - Contribute to MI6

---

## Protocol Versioning

**Current**: MI6 follows Dossier Protocol v1.0

**Compatibility**: All MI6 dossiers specify `Protocol Version: 1.0` in their metadata

**Updates**: When the Dossier Protocol updates:
- Minor updates (1.0 → 1.1): MI6 dossiers automatically benefit
- Major updates (1.x → 2.0): MI6 dossiers must be updated explicitly

---

**🕵️ MI6 Dossier Execution Protocol**

> "Structure your agents. Not your scripts."

*This protocol ensures MI6 dossiers follow the universal [Dossier Standard](https://github.com/imboard-ai/dossier) while maintaining MI6-specific conventions.*
