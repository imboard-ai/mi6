# [Project Name] AI Guide

**Purpose**: This guide helps AI assistants (Claude, Copilot, Cursor, etc.) understand your project structure, conventions, and workflows.

---

## 📁 Project Structure

### Repository Organization

This project uses a **[multi-repo | mono-repo | single-repo]** structure:

- **`backend/`** - [Brief description, e.g., "Express.js API with TypeScript"]
- **`frontend/`** - [Brief description, e.g., "React + Vite frontend"]
- **`shared/`** - [Brief description, e.g., "Shared TypeScript types and utilities"]

### Documentation Organization

- **`AI_GUIDE.md`** - This file (project guide for AI assistants)
- **`README.md`** - Project overview for humans
- **`core/`** - Core documentation (architecture, security, patterns) - **ALWAYS RELEVANT**
- **`tasks/`** - Task organization (see Task Management section)

---

## 🎯 Task Management

This project uses **MI6 task lifecycle management** for organizing work:

### Task Folders

- **`tasks/planned/`** - Tasks not started yet (hidden from AI context)
- **`tasks/active/`** - **Current work - FOCUS HERE!** (visible to AI)
- **`tasks/stashed/`** - Paused work (hidden from AI context)
- **`tasks/completed/`** - Historical archive (hidden from AI context)

### Task Commands

```bash
# Start a task (planned → active)
npm run task:start <task-name>

# Pause current task (active → stashed)
npm run task:pause <task-name>

# Resume paused task (stashed → active)
npm run task:resume <task-name>

# Complete task (active → completed/YYYY/)
npm run task:complete <task-name>

# List all tasks
npm run task:list
```

### AI Context Rules

**When working on tasks, AI assistants should:**
1. ✅ **Focus on `tasks/active/` only** - these are current priorities
2. ❌ **Ignore `tasks/planned/`** - not started yet, context not relevant
3. ❌ **Ignore `tasks/stashed/`** - paused work, not current focus
4. ❌ **Ignore `tasks/completed/`** - historical reference only

**Always check `tasks/active/` first when starting work!**

---

## 🛠️ Build & Development

### Backend Commands

```bash
cd backend/
npm install
npm run dev           # Start development server
npm run build         # Build for production
npm test              # Run all tests
npm run lint          # Check code style
npm run typecheck     # TypeScript validation
```

### Frontend Commands

```bash
cd frontend/
npm install
npm run dev           # Start development server (usually localhost:5173)
npm run build         # Build for production
npm test              # Run tests (Playwright, Jest, etc.)
npm run lint          # Check code style
npm run typecheck     # TypeScript validation
```

### Shared Package Commands

```bash
cd shared/
npm install
npm run build         # Compile TypeScript
npm run watch         # Watch mode for development
```

---

## 📝 Code Style & Conventions

### Language & Framework

- **Language**: [TypeScript | JavaScript | Python | etc.]
- **Backend Framework**: [Express | NestJS | FastAPI | etc.]
- **Frontend Framework**: [React | Vue | Svelte | etc.]
- **Testing**: [Jest | Playwright | Pytest | etc.]

### Code Style Rules

- **Indentation**: [2 spaces | 4 spaces | tabs]
- **Quotes**: [Single | Double]
- **Semicolons**: [Required | Optional]
- **Line Width**: [80 | 100 | 120] characters
- **Naming Conventions**:
  - Files: [kebab-case | camelCase | PascalCase]
  - Components: [PascalCase | kebab-case]
  - Functions: [camelCase | snake_case]
  - Constants: [UPPER_SNAKE_CASE | UPPER_CASE]

### Import Order

```typescript
// 1. Node built-ins
import fs from 'fs';
import path from 'path';

// 2. React/Framework
import React from 'react';

// 3. Third-party packages
import express from 'express';
import axios from 'axios';

// 4. Type imports
import type { User, Board } from '@org/shared-types';

// 5. App-level imports
import { config } from '@/config';
import { logger } from '@/utils';

// 6. Relative imports
import { Button } from './Button';
import './styles.css';
```

### Code Quality Commands

```bash
# Backend
npm run hygiene      # Run comprehensive quality checks

# Frontend
npm run hygiene      # Run comprehensive quality checks
```

**Always run hygiene checks before committing code!**

---

## 🧪 Testing

### Test Organization

- **Unit Tests**: `tests/unit/` or `__tests__/`
- **Integration Tests**: `tests/integration/`
- **E2E Tests**: `tests/e2e/` or `tests/`

### Running Tests

```bash
# Backend
npm test                          # All tests
npm run test:specific:<module>    # Specific module tests
npm run test:watch                # Watch mode

# Frontend
npm test                          # All tests
npm run test:specific:<name>      # Specific test file
npm run test:headed               # With browser UI
npm run test:debug                # Debug mode
```

### Test Patterns

[Describe your project's test patterns, mocking strategy, fixtures, etc.]

---

## 🔒 Security Considerations

### Authentication

[Describe your auth system: JWT, OAuth, passwordless, etc.]

### API Security

- [Rate limiting strategy]
- [CORS configuration]
- [Input validation approach]
- [Key security headers]

### Data Protection

- [Database security measures]
- [File upload handling]
- [Sensitive data management]

---

## 🚀 Deployment

### Environments

- **Development**: [localhost setup]
- **Staging**: [staging URL]
- **Production**: [production URL]

### Deployment Commands

```bash
# Backend deployment
npm run deploy

# Frontend deployment
[deployment command]
```

### Environment Variables

[List critical environment variables, their purpose, and where they're configured]

---

## 🌊 Workflows

### Git Worktree Workflow

This project uses **MI6 worktree management** for parallel development:

```bash
# Create feature worktrees for all repos
$MI6_PATH/scripts/worktree/create-feature-worktree.sh feature-name

# Work in worktrees
cd .worktrees/feature-name/backend/
cd .worktrees/feature-name/frontend/

# Clean up when done
$MI6_PATH/scripts/worktree/cleanup-worktree.sh feature-name
```

See `$MI6_PATH/workflows/git-worktree.md` for details.

---

## 🤖 AI Assistant Guidelines

### When Starting Work

1. **Check active tasks**: `ls tasks/active/`
2. **Read relevant task docs**: Focus on current work
3. **Review core docs**: Check `core/` for architecture and patterns
4. **Understand context**: This AI_GUIDE.md + README.md + active tasks

### During Development

- ✅ **Follow code style** rules defined above
- ✅ **Run hygiene checks** before proposing changes
- ✅ **Write tests** for new features
- ✅ **Update documentation** when changing behavior
- ❌ **Don't modify completed tasks** - they're archived
- ❌ **Don't start work on planned tasks** - wait for user to activate them

### Best Practices

- **Ask for clarification** when requirements are ambiguous
- **Propose multiple approaches** when trade-offs exist
- **Explain your reasoning** for architectural decisions
- **Flag potential issues** proactively (security, performance, maintainability)

---

## 📚 Resources

### MI6 Framework

- **Task Lifecycle**: `$MI6_PATH/workflows/task-lifecycle.md`
- **Worktree Guide**: `$MI6_PATH/workflows/git-worktree.md`
- **Environment Setup**: `$MI6_PATH/docs/environment-setup.md`

### Project-Specific

- [Link to architecture docs]
- [Link to API documentation]
- [Link to design system or component library]

---

## 💡 Common Patterns

[Document common patterns in your codebase:]

### Example: API Communication

```typescript
// Service pattern example
export async function getUserData(): Promise<GetUserResponse> {
  try {
    const response = await axiosInstance.get<IApiGetUserReply>('/api/user');
    return { data: response.data };
  } catch (error) {
    const err = error as AxiosError<ApiErrorResponse>;
    return { error: err.response?.data?.message || 'Unknown error' };
  }
}
```

### Example: Component Structure

```typescript
// Component pattern example
interface Props {
  // ...
}

export function Component({ prop1, prop2 }: Props) {
  // ...
}
```

---

## ❓ FAQ for AI Assistants

**Q: Where should I focus when starting work?**
A: Check `tasks/active/` first. These are the current priorities.

**Q: How do I know which files are relevant?**
A: Core docs (`core/`) are always relevant. Task-specific docs are in `tasks/active/`.

**Q: Can I read completed tasks for context?**
A: Only if user explicitly asks. They're hidden by default to reduce noise.

**Q: How do I handle code style?**
A: Follow the rules above, and run `npm run hygiene` to verify.

**Q: Should I suggest architectural changes?**
A: Yes, but explain trade-offs clearly and ask for user input.

---

**Last Updated**: [Date]
**MI6 Version**: v1
**Maintained By**: [Team/Person Name]
