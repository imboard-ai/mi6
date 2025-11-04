# Dossier: Task Creation

**Purpose**: Create a well-structured task document following MI6 patterns.

**When to use**: Starting new work that needs documentation and tracking.

---

## Objective

Generate a comprehensive task document that:
- Follows MI6 task template structure
- Captures goals, requirements, and acceptance criteria
- Is placed in the correct folder (planned/ by default)
- Can be immediately started with `npm run task:start`

---

## Prerequisites

- ✅ MI6 project initialized (task structure exists)
- ✅ User has idea of what task is about

**Validation**:
```bash
ls -d tasks/{planned,active,stashed,completed}
```

---

## Context to Gather

### 1. Task Information from User

**Ask or infer**:
- **Task name**: Short, descriptive (e.g., "DASHBOARD_REDESIGN")
- **Goal**: What this task accomplishes
- **Context**: Why this task exists
- **Requirements**: What needs to be done
- **Acceptance criteria**: How to know it's complete

### 2. Project Context

**Review**:
- Existing tasks for naming patterns
- `AI_GUIDE.md` for project conventions
- `.ai-project.json` for tech stack

---

## Actions to Perform

### Step 1: Generate Task Name

**Format**: `UPPER_SNAKE_CASE.md`

**Examples**:
- `DASHBOARD_REDESIGN.md`
- `API_RATE_LIMITING.md`
- `BUG_LOGIN_TIMEOUT.md`

**Rules**:
- Descriptive but concise
- No spaces (use underscores)
- ALL CAPS for consistency

### Step 2: Create Task Document

**Generate file** in `tasks/planned/`:

```markdown
# [Task Name]

## Status
- Started: [Leave blank - filled when starting]
- Completed: [Leave blank - filled when completing]

## Goal
[Clear one-sentence description of what this accomplishes]

## Context
[Why this task exists, background information]

## Requirements
- Requirement 1
- Requirement 2
- Requirement 3

## Implementation Plan
1. Step 1
2. Step 2
3. Step 3

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Details

### Architecture Changes
[Any architectural decisions or changes]

### API Changes
[New or modified endpoints, if applicable]

### Database Changes
[Schema updates, migrations, if applicable]

## Testing Plan
- Unit tests: [What to test]
- Integration tests: [What to test]
- E2E tests: [What to test]

## Deployment Notes
[Special deployment considerations, if any]

## Related Tasks
- [Link to related tasks or dependencies]

## Notes
[Additional context, learnings will be added during implementation]
```

### Step 3: Inform User

```
✅ Task created: tasks/planned/[TASK_NAME].md

📝 Next steps:
   1. Review and edit the task document
   2. Start working: npm run task:start [TASK_NAME]

💡 The task will then be visible to AI assistants
```

---

## Example

**User input**:
> "Create a task for implementing dark mode in the application"

**Generated task**: `tasks/planned/DARK_MODE_IMPLEMENTATION.md`

```markdown
# Dark Mode Implementation

## Status
- Started:
- Completed:

## Goal
Add dark mode toggle to application with theme persistence

## Context
Users have requested dark mode for better viewing in low-light environments.
This will improve accessibility and user experience.

## Requirements
- Theme toggle in settings/header
- Persist user preference (localStorage or backend)
- Support all pages and components
- Smooth theme transitions
- No UI glitches during switch

## Implementation Plan
1. Set up theme context/provider
2. Create theme toggle component
3. Define dark mode color palette
4. Update all components to use theme variables
5. Add persistence layer
6. Test all pages in both modes

## Acceptance Criteria
- [ ] Toggle switch works in UI
- [ ] Theme persists across sessions
- [ ] All pages support dark mode
- [ ] No visual glitches or layout issues
- [ ] Smooth transitions between themes
- [ ] Tests passing

## Technical Details

### Architecture Changes
- Add ThemeContext to app root
- Use CSS variables or styled-components for theming

### API Changes
- Optional: Add user preference endpoint if storing on backend

## Testing Plan
- Unit tests: Theme context, toggle component
- E2E tests: Toggle dark mode, verify persistence, check all pages

## Notes
[To be filled during implementation]
```

---

## Validation

```bash
# Check file exists
ls tasks/planned/[TASK_NAME].md

# Check content is valid markdown
cat tasks/planned/[TASK_NAME].md
```

---

## Related Dossiers

- [project-init.md](./project-init.md) - Set up task structure first

## Related Workflows

- [Task Lifecycle](../workflows/task-lifecycle.md) - How to use tasks

---

**🕵️ MI6 Task Creation Dossier**
*Consistent, comprehensive task documentation*
