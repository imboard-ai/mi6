# MI6 Scripts

Shell and Node.js automation tools for fast, deterministic operations.

---

## Overview

Scripts provide **command-line automation** for operations where:
- ✅ Configuration is complete and correct
- ✅ Fast execution is important
- ✅ CI/CD or headless environments
- ✅ No LLM access available
- ✅ Repeated operations (same command many times)

**Alternative**: Use [dossiers](../dossiers/) for intelligent, context-aware automation when setup is unclear or needs adaptation.

---

## Directory Structure

```
scripts/
├── admin/          # Setup and maintenance utilities
├── task-manager/   # Task lifecycle automation
├── worktree/       # Git worktree management
└── validation/     # Performance monitoring and validation
```

---

## Quick Reference

### Admin Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-env.sh` | Configure MI6_PATH environment variable | `./setup-env.sh` |
| `verify-setup.sh` | Validate MI6 installation | `./verify-setup.sh` |
| `repair-symlinks.sh` | Fix broken symlinks | `./repair-symlinks.sh` |

📚 [Details](./admin/README.md)

---

### Task Manager Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `task-manager.js` | Task lifecycle automation | `npm run task:start TASK_NAME` |

**Commands**: start, pause, resume, complete, list

📚 [Details](./task-manager/README.md)

---

### Worktree Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `create-feature-worktree.sh` | Create linked worktrees | `./create-feature-worktree.sh feature-name` |
| `list-worktrees.sh` | Show all active worktrees | `./list-worktrees.sh [--dirty]` |
| `cleanup-worktree.sh` | Remove worktrees safely | `./cleanup-worktree.sh feature-name` |

📚 [Details](./worktree/README.md)

---

### Validation Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `benchmark-git-ops.sh` | Monitor git performance | `./benchmark-git-ops.sh` |

📚 [Details](./validation/)

---

## When to Use Scripts vs Dossiers

| Scenario | Use Script | Use Dossier |
|----------|------------|-------------|
| Configuration is complete | ✅ Script | Either |
| Need fast execution | ✅ Script | Script slower |
| CI/CD pipeline | ✅ Script | May not have LLM |
| Setup unclear | ❌ Script may fail | ✅ Dossier adapts |
| Edge cases expected | ❌ Script may not handle | ✅ Dossier intelligent |
| Want guidance | ❌ Script just executes | ✅ Dossier explains |

**Recommendation**: Try scripts first (faster). If they fail or you're unsure, use corresponding dossier.

---

## Common Workflows

### Project Setup
```bash
# 1. Install MI6
$MI6_PATH/scripts/admin/setup-env.sh
source ~/.bashrc

# 2. Verify
$MI6_PATH/scripts/admin/verify-setup.sh
```

### Task Management
```bash
# Create task in tasks/planned/, then:
npm run task:start MY_TASK
npm run task:list
npm run task:complete MY_TASK
```

### Worktree Development
```bash
# Create worktrees
$MI6_PATH/scripts/worktree/create-feature-worktree.sh my-feature

# Check status
$MI6_PATH/scripts/worktree/list-worktrees.sh

# Clean up when done
$MI6_PATH/scripts/worktree/cleanup-worktree.sh my-feature
```

---

## See Also

- [Dossiers](../dossiers/README.md) - LLM-guided intelligent automation
- [Workflows](../workflows/README.md) - Operational patterns documentation
- [Templates](../templates/README.md) - Project scaffolding
- [Main README](../README.md) - MI6 overview

---

**🕵️ MI6 Scripts**
*Fast, deterministic automation for agent-driven development*
