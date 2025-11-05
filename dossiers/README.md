# MI6 Dossiers: Implementation

**Dossiers** are intelligent instruction sets that leverage LLM agents to automate complex workflows. MI6 implements the [Dossier Standard](https://github.com/imboard-ai/dossier) for agentic automation.

---

## What Are Dossiers?

> **New to dossiers?** See the [Dossier Project](https://github.com/imboard-ai/dossier) for a comprehensive introduction to the dossier concept, specification, and universal examples.

MI6 uses dossiers to automate complex workflows like project initialization, worktree management, and task creation. Instead of brittle scripts, we provide clear instructions that LLM agents follow intelligently.

---

## 🔗 Dossier Standard

MI6 implements the **[Dossier Standard](https://github.com/imboard-ai/dossier)**, which provides:

- **[Specification](https://github.com/imboard-ai/dossier/blob/main/SPECIFICATION.md)** - Formal dossier standard
- **[Protocol](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md)** - Execution guidelines & self-improvement system
- **[Templates](https://github.com/imboard-ai/dossier/tree/main/templates)** - Standard dossier templates
- **[Examples](https://github.com/imboard-ai/dossier/tree/main/examples)** - Universal examples (ML, DevOps, Database, Frontend)

**MI6 follows Protocol v1.0** - All MI6 dossiers reference the standard protocol for consistent execution.

---

## How to Use MI6 Dossiers

### Method 1: Natural Language (Easiest)

Just tell your AI assistant:

```
"Use the MI6 project-init dossier to set up this directory"
```

The AI knows to look in `$MI6_PATH/dossiers/` and follow the instructions.

### Method 2: Explicit Reference

```
"Follow the instructions in $MI6_PATH/dossiers/project-init.md
to initialize this project"
```

### Method 3: Copy-Paste (Always Works)

1. Open dossier file: `cat $MI6_PATH/dossiers/project-init.md`
2. Copy content
3. Paste into AI chat
4. AI executes the instructions

---

## Available MI6 Dossiers

### Citizen Journey Dossiers

**For new projects (greenfield)**:
| Dossier | Purpose | When to Use |
|---------|---------|-------------|
| **greenfield-start.md** | Start brand new project from zero | Absolute beginning - no directory yet |
| **project-init.md** | Initialize MI6 structure | After directory/repos created |
| **dependency-install.md** | Install all dependencies | After MI6 initialization |
| **first-dev-session.md** | First productive dev session | Ready to start coding |

**For existing projects (brownfield)**:
| Dossier | Purpose | When to Use |
|---------|---------|-------------|
| **brownfield-adoption.md** | Add MI6 to existing project safely | Have existing code, want MI6 benefits |
| **project-uninstall.md** | Remove MI6 if adoption fails | MI6 didn't work out, need clean removal |

### Feature Dossiers

| Dossier | Purpose | When to Use |
|---------|---------|-------------|
| **worktree-multi-repo.md** | Set up multi-repo worktrees | Working on features across multiple repos |
| **worktree-cleanup.md** | Remove worktrees safely | Completing/abandoning feature work |
| **task-create.md** | Create new task document | Starting new work that needs documentation |

### Complete Catalog

See [REGISTRY.md](./REGISTRY.md) for the complete dossier catalog with relationships, outputs, and navigation maps.

---

## Dossiers vs Scripts

MI6 uses **both** dossiers and traditional scripts - each for what they do best:

### Use Dossiers When:
- ✅ Context awareness needed (detect project structure)
- ✅ Decisions required (which templates to use)
- ✅ Adaptation needed (handle unexpected setups)
- ✅ User guidance helpful (explain choices)

### Use Scripts When:
- ✅ Inputs are clear and deterministic
- ✅ Fast execution matters
- ✅ No decisions needed
- ✅ Same operation every time

### Examples

| Task | Approach | Why |
|------|----------|-----|
| Set MI6_PATH | Script ✅ | Simple, deterministic |
| **Initialize project** | **Dossier** ✅ | Needs to understand project |
| Benchmark git | Script ✅ | Fixed commands |
| **Create worktrees** | **Dossier** ✅ | Needs repo detection |
| Validate config | Script ✅ | Schema checking |
| **Generate config** | **Dossier** ✅ | Needs intelligence |

---

## Creating Custom MI6 Dossiers

### 1. Use the Standard Template

Start with the dossier template from the [Dossier Project](https://github.com/imboard-ai/dossier/blob/main/templates/dossier-template.md):

```bash
# Download template
curl -o $MI6_PATH/dossiers/my-custom-dossier.md \
  https://raw.githubusercontent.com/imboard-ai/dossier/main/templates/dossier-template.md

# Or use local template if available
cp $MI6_PATH/dossiers/templates/dossier-template.md \
   $MI6_PATH/dossiers/my-custom-dossier.md
```

### 2. Follow the Dossier Standard

Fill in all sections following the [Dossier Specification](https://github.com/imboard-ai/dossier/blob/main/SPECIFICATION.md). Be specific and clear. The LLM will follow your instructions literally.

### 3. Reference the Protocol

Include protocol reference in your dossier metadata:

```markdown
**Protocol Version**: 1.0 ([Dossier Protocol](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md))
```

### 4. Test with an LLM

Try your dossier with an AI assistant. Refine based on results.

### 5. Contribute Back

Share useful dossiers! See [CONTRIBUTING.md](../CONTRIBUTING.md).

---

## Best Practices

See the [Dossier Project Best Practices](https://github.com/imboard-ai/dossier#best-practices) for comprehensive guidelines.

**MI6-Specific Additions**:

### ✅ Do:
- **Use $MI6_PATH**: Reference MI6 environment variable in paths
- **Check REGISTRY.md**: Ensure your dossier doesn't duplicate existing ones
- **Follow MI6 conventions**: Use MI6's task structure, .ai-project.json, etc.
- **Test in both greenfield and brownfield**: Ensure dossier works for both scenarios

### ❌ Don't:
- **Hardcode MI6 paths**: Always use `$MI6_PATH`
- **Skip REGISTRY.md update**: Add your dossier to the registry
- **Ignore existing dossiers**: Check if functionality already exists

---

## Examples

### Example 1: Quick Project Setup

```
User: "I have a Node.js backend and React frontend.
       Use MI6 project-init to set this up."

AI: (Follows project-init.md dossier)
    ✓ Detected: Multi-repo structure
    ✓ Found: backend/ (Node.js), frontend/ (React)
    ✓ Created: .ai-project.json with 2 repos
    ✓ Copied: All templates
    ✓ Customized: AI_GUIDE.md with npm commands
    ✓ Set up: .aicontextignore for Node/React
    ✓ Created: Task structure
    ✓ Initialized: Git repository

    "Project initialized! Ready to use MI6."
```

### Example 2: Worktree Setup

```
User: "Create worktrees for feature-x using the worktree dossier"

AI: (Follows worktree-multi-repo.md dossier)
    ✓ Read: .ai-project.json (found 2 repos)
    ✓ Created: .worktrees/feature-x/backend/ on branch feature-x
    ✓ Created: .worktrees/feature-x/frontend/ on branch feature-x
    ✓ Verified: Both branches created successfully

    "Worktrees ready! Work in .worktrees/feature-x/"
```

### Example 3: Task Creation

```
User: "Use task-create dossier to make a task for
       implementing dark mode"

AI: (Follows task-create.md dossier)
    ✓ Generated: DARK_MODE_IMPLEMENTATION.md
    ✓ Added: Requirements and acceptance criteria
    ✓ Created: In tasks/planned/
    ✓ Suggested: Next step is 'npm run task:start DARK_MODE'

    "Task created! Start with: npm run task:start DARK_MODE"
```

---

## Why This Works

### 1. **Adaptive Intelligence**
LLMs can understand your project's unique structure and adapt dossier instructions accordingly.

### 2. **Less Code to Maintain**
Dossiers are markdown files with instructions, not complex error-prone scripts.

### 3. **Better Error Handling**
LLMs can troubleshoot and retry intelligently rather than crashing on unexpected input.

### 4. **User Trust**
Users see what the AI is doing and can guide the process, unlike opaque scripts.

### 5. **Community Extensible**
Anyone can write a dossier - no shell scripting expertise required.

### 6. **Universal Standard**
MI6 implements a universal standard that works across projects and domains.

---

## Troubleshooting

### "The AI didn't follow the dossier correctly"

**Causes**:
- Dossier instructions too vague
- Missing context about project structure
- Edge case not documented

**Solutions**:
- Make instructions more explicit
- Add examples of expected output
- Update dossier with troubleshooting section

---

### "Dossier works with Claude but not GPT-4"

**Cause**: LLM-specific assumptions

**Solution**: Make dossier more explicit:
- Avoid relying on tool-specific features
- Be very clear about file paths
- Include step-by-step validation

---

### "I don't have access to an LLM"

If you don't have an LLM agent:
- Use traditional MI6 scripts (setup-env.sh, task-manager.js, etc.)
- Dossiers are optional enhancements, not requirements
- Many tasks can be done manually following docs

---

## See Also

### Dossier Standard
- **[Dossier Project](https://github.com/imboard-ai/dossier)** - Universal LLM automation standard
- **[Specification](https://github.com/imboard-ai/dossier/blob/main/SPECIFICATION.md)** - Formal standard
- **[Protocol](https://github.com/imboard-ai/dossier/blob/main/PROTOCOL.md)** - Execution guidelines
- **[Universal Examples](https://github.com/imboard-ai/dossier/tree/main/examples)** - ML, DevOps, Database, Frontend

### MI6 Documentation
- **[REGISTRY.md](./REGISTRY.md)** - Complete MI6 dossier catalog
- **[Dossier System Guide](../docs/dossier-system.md)** - Comprehensive MI6 documentation
- **[CONTRIBUTING.md](../CONTRIBUTING.md)** - Contribute dossiers
- **[MI6 Workflows](../workflows/)** - Traditional documentation

---

## Philosophy

> "Agents need structure. Dossiers provide it."

Dossiers embody this philosophy - they give AI agents clear structure and guidance, enabling them to intelligently automate complex workflows that would be brittle to script.

**MI6's implementation** provides:
- **Proven workflows** - Battle-tested dossiers for common MI6 tasks
- **Universal standard** - Based on the open Dossier Standard
- **Continuous improvement** - Self-improving through protocol
- **Community extensible** - Anyone can contribute new dossiers

---

**🕵️ MI6 Dossiers**
*Implementation of the [Dossier Standard](https://github.com/imboard-ai/dossier)*
*Simpler than scripts. More powerful than manual.*
