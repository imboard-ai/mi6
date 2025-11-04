# 🕵️‍♂️ MI6 — The Agent Organization for Developers

**MI6** is an **open meta-framework for agent-driven development**, built and maintained by [ImBoard.ai](https://imboard.ai).

It provides a reusable foundation for coordinating **human and AI agents** across multi-repository environments — enabling structure, context control, and automation in modern development workflows.

---

## 🚀 Overview

Traditional development frameworks manage **code**.  
**MI6** manages the **intelligence around code** — the tasks, prompts, workflows, and context that allow both humans and AI agents to collaborate effectively.

### ✳️ Core Ideas

- **Agent-driven workflows** — structure how humans and AI coding assistants (Claude, Cursor, Copilot, etc.) operate together.
- **Context hygiene** — keep AI tools focused by defining what’s in-scope via `.aicontextignore` and metadata files.
- **Reusable infrastructure** — scripts, templates, and validation workflows shared across all your projects.
- **Multi-repo orchestration** — connect backend, frontend, docs, and automation repos cleanly.
- **Task lifecycle clarity** — standardize how work moves from `planned → active → stashed → completed`.

---

## 🧩 Repository Structure

```bash
mi6/
├── scripts/         # Reusable shell / Node utilities for setup, worktrees, and validation
├── workflows/       # Shared operational blueprints (e.g., task lifecycle, release flow)
├── prompts/         # Agent prompt templates for coding, reviews, debugging
├── templates/       # Project scaffolds (.ai-project.json, AI_GUIDE.md, etc.)
└── docs/            # Guides, best practices, and design philosophy
```

Each directory is designed to be cloned, copied, or imported into your own repos.

---

## 🧠 Why MI6 Exists

> “The future of software isn’t just code — it’s collaboration between humans and intelligent agents.”

Teams are already using AI tools for code generation, documentation, and planning — but without structure, the results are chaotic.  
MI6 introduces **a layer of discipline**: a standardized way to manage context, share agent prompts, and coordinate automation across multiple projects.

---

## ⚙️ Quick Start

MI6 supports two user profiles:

### 🛠️ MI6-Operator (Contributors)

**For those developing MI6 itself:**

```bash
# Clone the repository
git clone https://github.com/imboard-ai/mi6.git ~/projects/mi6

# Run environment setup
cd ~/projects/mi6/scripts/admin
./setup-env.sh

# Reload your shell
source ~/.bashrc  # or ~/.zshrc

# Verify setup
./verify-setup.sh

# Start contributing!
```

### 👤 MI6-Citizen (Users)

**For those using MI6 in their projects:**

**Option A - Local Installation** (recommended):
```bash
# Clone and setup
git clone https://github.com/imboard-ai/mi6.git ~/projects/mi6
cd ~/projects/mi6/scripts/admin && ./setup-env.sh
source ~/.bashrc  # or ~/.zshrc

# Use MI6 resources
cp $MI6_PATH/templates/AI_GUIDE.md my-project/
cp $MI6_PATH/templates/.ai-project.json my-project/
```

**Option B - Direct GitHub Reference** (no local clone):
```bash
# Download templates on-demand
curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/templates/AI_GUIDE.md > AI_GUIDE.md

# Use scripts directly
curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/scripts/task-manager/task-manager.js | node -
```

📚 **Detailed setup guide**: [docs/environment-setup.md](./docs/environment-setup.md)

---

## 🤖 Agentic Automation (Dossiers)

MI6 leverages the fact that users have access to LLM agents. Instead of complex scripts, MI6 provides **dossiers** - intelligent instruction sets that AI agents execute.

### What Are Dossiers?

Dossiers are structured markdown files that tell LLM agents (Claude, GPT-4, Cursor, Copilot) exactly how to automate complex tasks intelligently.

**Example**:
```
"Use the MI6 project-init dossier to set up this directory"
```

The AI agent reads `$MI6_PATH/dossiers/project-init.md` and:
- Detects your project structure (single/multi/mono repo)
- Identifies tech stack (Node.js, Python, Go, etc.)
- Copies and customizes all templates
- Sets up task management
- Initializes everything perfectly

### Available Dossiers

| Dossier | Purpose |
|---------|---------|
| **project-init.md** | Initialize new MI6 project (replaces complex setup wizard) |
| **worktree-multi-repo.md** | Create linked worktrees across multiple repos |
| **task-create.md** | Generate structured task documents |

📚 **Learn more**: [dossiers/README.md](./dossiers/README.md)

### Why Dossiers?

- ✅ **Adaptive**: LLMs understand your project context
- ✅ **Simpler**: Markdown instructions vs complex shell scripts
- ✅ **Powerful**: Handles edge cases through intelligence
- ✅ **Extensible**: Anyone can write dossiers

---

## 🗺️ Roadmap

| Milestone | Status | Description |
|------------|--------|-------------|
| Core repo structure & license | ✅ Done | Public release under BSL 1.1 |
| Environment setup system | ✅ Done | MI6_PATH configuration with auto-detection |
| Template system | ✅ Done | Complete templates for multi-repo, mono-repo, and single-repo projects |
| Task lifecycle management | ✅ Done | Automated task transitions with git integration |
| Workflow documentation | ✅ Done | Task lifecycle and git worktree patterns |
| Validation scripts | ✅ Done | Git performance benchmarking |
| **Agentic Dossier System** | ✅ Done | LLM-powered automation for project setup, worktrees, and tasks |
| Worktree cleanup dossier | 🧩 Planned | Automated worktree cleanup guidance |
| Config optimization dossier | 🧩 Planned | Intelligent .ai-project.json improvements |
| Integration examples | 🧩 Planned | Real-world examples with Claude, Cursor, and Copilot |
| Community dossiers | 🧩 Planned | User-contributed automation patterns |

---

## 🛡️ License

This repository is licensed under the **Business Source License 1.1 (BSL 1.1)**.  
You may freely use and modify MI6 for personal, educational, and internal use.  
**Offering MI6 as a hosted or managed service is prohibited before the Change Date.**

**Change Date:** 2028-10-01  
**Change License:** [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

See the [LICENSE](./LICENSE) file for full terms.

---

## 💬 Contributing

Contributions, feedback, and ideas are welcome!  
Please open issues or pull requests to improve the structure, add workflows, or propose new agent patterns.  
By contributing, you agree that your contributions fall under the same BSL → Apache 2.0 transition.

---

## 🧭 About ImBoard.ai

[ImBoard.ai](https://imboard.ai) helps startup boards and executives organize board meetings, dashboards, and documents in one AI-powered workspace.  
MI6 is part of ImBoard’s commitment to open infrastructure for AI-driven collaboration.

---

### 🧠 Motto

> “Agents need structure. MI6 provides it.”

---

© 2025 ImBoard.ai — Released under the Business Source License 1.1.
