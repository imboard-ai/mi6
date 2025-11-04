# Contributing to MI6

Thank you for your interest in contributing to MI6! This guide will help you get started.

---

## For MI6-Operators (Contributors)

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/imboard-ai/mi6.git ~/projects/mi6
cd ~/projects/mi6

# 2. Run environment setup
cd scripts/admin
./setup-env.sh

# 3. Reload your shell
source ~/.bashrc  # or ~/.zshrc

# 4. Verify setup
./verify-setup.sh
```

### Development Workflow

1. **Work directly on main** (you're a maintainer)
2. **Make changes** to scripts, templates, or docs
3. **Test your changes** (see Testing section)
4. **Commit with descriptive messages**
5. **Push to main**

### Commit Message Format

Use clear, descriptive commit messages:

```
Brief description (50 chars or less)

Longer explanation if needed. What changed and why.

🕵️ Generated with Claude Code (https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**For major phases**, use structured format:

```
Phase N: Feature Name

Brief description of the phase

📋 Components Added:
- Component 1 - Description
- Component 2 - Description

✨ Key Features:
- Feature 1
- Feature 2

🕵️ Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## What to Contribute

### Priority Areas

1. **Templates**: New project templates or improvements to existing ones
2. **Scripts**: Automation scripts (worktree management, validation, etc.)
3. **Workflows**: Documentation of proven development patterns
4. **Prompts**: AI assistant prompt templates
5. **Documentation**: Guides, tutorials, examples

### Ideas Welcome

- New template patterns (monorepo, microservices, etc.)
- Language-specific templates (Python, Go, Rust, etc.)
- IDE integrations (VS Code, Cursor, etc.)
- CI/CD workflow templates
- Testing pattern documentation
- Security best practices

---

## Guidelines

### Code Quality

- **Shell scripts**: Follow bash best practices, include error handling
- **JavaScript**: Node.js 14+, no external dependencies if possible
- **Documentation**: Clear, comprehensive, with examples
- **Templates**: Well-commented, easy to customize

### Testing

Before committing:

```bash
# Test setup scripts
./scripts/admin/setup-env.sh
./scripts/admin/verify-setup.sh

# Test task manager (in a test project)
cd /tmp/test-project
mkdir -p scripts tasks/{planned,active,stashed,completed}
cp $MI6_PATH/scripts/task-manager/task-manager.js scripts/
echo "# Test" > tasks/planned/TEST.md
node scripts/task-manager.js start TEST
node scripts/task-manager.js list
node scripts/task-manager.js complete TEST

# Test benchmark script
./scripts/validation/benchmark-git-ops.sh
```

### Documentation

- Update README.md if adding major features
- Add comprehensive README for new script directories
- Include usage examples
- Document edge cases and limitations

---

## Project Structure

```
mi6/
├── scripts/           # Executable scripts
│   ├── admin/        # Setup and maintenance
│   ├── task-manager/ # Task lifecycle management
│   ├── worktree/     # Git worktree automation (planned)
│   └── validation/   # Performance and validation
├── workflows/         # Process documentation
├── prompts/           # AI prompt templates (planned)
├── templates/         # Project scaffolding
├── docs/              # Guides and documentation
└── examples/          # Example projects (planned)
```

---

## Backwards Compatibility

MI6 uses semantic versioning in `.ai-project.json`:

```json
{
  "mi6": {
    "version": "v1"
  }
}
```

When making breaking changes:
1. Increment version (v1 → v2)
2. Document migration path
3. Support previous version for at least one release
4. Add deprecation warnings before removing features

---

## License

By contributing, you agree that your contributions will be licensed under the same Business Source License 1.1, transitioning to Apache 2.0 on 2028-10-01.

---

## Questions?

- Open an issue on GitHub
- Check existing documentation
- Review examples in the repository

---

## Recognition

Contributors will be:
- Listed in project documentation
- Credited in release notes
- Mentioned in relevant commits

Thank you for helping make MI6 better! 🕵️
