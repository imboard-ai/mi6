# MI6 Workflows

Documented operational patterns and best practices for development lifecycle.

---

## Overview

Workflows provide **proven patterns** for:
- Task lifecycle management
- Git worktree strategies
- Development processes
- Validation procedures
- Deployment patterns (future)

**Purpose**: Share operational knowledge across projects and teams.

---

## Available Workflows

### Lifecycle Workflows

| Workflow | Purpose | Type |
|----------|---------|------|
| [task-lifecycle.md](./task-lifecycle.md) | Task state management (planned → active → stashed → completed) | Lifecycle |

**Intended usage**:
- Understanding task transitions
- AI context control
- Planning and documentation workflows
- Integration with git commits

---

### Development Workflows

| Workflow | Purpose | Type |
|----------|---------|------|
| [git-worktree.md](./git-worktree.md) | Parallel development with git worktrees | Development |

**Intended usage**:
- Multi-repo feature development
- Parallel work without branch switching
- Hotfix workflows during feature development
- Single-repo and multi-repo patterns

---

### Validation Workflows (Planned)

**Future workflows**:
- Pre-commit validation patterns
- Configuration verification procedures
- Code review checklists
- Performance benchmarking strategies

---

### Deployment Workflows (Planned)

**Future workflows**:
- Multi-repo deployment coordination
- Release management processes
- Environment synchronization
- Rollback procedures

---

## How to Use Workflows

### As Reference Documentation

Read workflows to understand patterns:
```bash
cat $MI6_PATH/workflows/task-lifecycle.md
```

### As Dossier Supplements

Workflows explain **concepts**, dossiers provide **execution**:
- Read workflow to understand strategy
- Use dossier to implement automatically

**Example**:
- Read `git-worktree.md` to understand worktree patterns
- Use `worktree-multi-repo.md` dossier to create worktrees automatically

### As Team Documentation

Share workflows with team:
- Link in project README
- Reference in team wiki
- Use for onboarding new developers

---

## Workflows vs Dossiers vs Scripts

| Type | Purpose | When to Use |
|------|---------|-------------|
| **Workflows** | Explain concepts and patterns | Learning, reference, team alignment |
| **Dossiers** | Intelligent automation via LLM | Complex setup, needs adaptation |
| **Scripts** | Fast deterministic execution | Clear config, CI/CD, speed matters |

**Example - Task Management**:
- **Workflow**: `workflows/task-lifecycle.md` - Read to understand philosophy
- **Script**: `scripts/task-manager/task-manager.js` - Fast execution
- **Dossier**: `dossiers/task-create.md` - Guided task creation

---

## Contributing Workflows

Have a proven pattern to share?

1. Document your workflow following existing format
2. Include examples and best practices
3. Link to related dossiers/scripts
4. Submit PR to MI6 repository

See [CONTRIBUTING.md](../CONTRIBUTING.md)

---

## See Also

- [Dossiers](../dossiers/README.md) - Automated execution
- [Scripts](../scripts/README.md) - Command-line tools
- [Templates](../templates/README.md) - Project scaffolds
- [Main README](../README.md) - MI6 overview

---

**🕵️ MI6 Workflows**
*Proven patterns for agent-driven development*
