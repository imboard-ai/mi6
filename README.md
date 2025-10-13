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

```bash
# Clone the MI6 framework
git clone https://github.com/imboard-ai/mi6.git

# Add environment variable for reuse
export MI6_PATH="$HOME/projects/mi6"

# Copy base templates into a new project
cp -R $MI6_PATH/templates/. my-new-project/

# Explore available workflows
ls $MI6_PATH/workflows
```

Use these assets to scaffold consistent, agent-friendly repos — or integrate MI6 scripts directly into your own toolchain.

---

## 🗺️ Roadmap

| Milestone | Status | Description |
|------------|--------|-------------|
| Core repo structure & license | ✅ Done | Public release under BSL 1.1 |
| Template system | 🚧 In progress | Configurable `.ai-project.json` scaffolds |
| CLI utilities | 🧩 Planned | Lightweight Node CLI for agent workflow automation |
| Integration examples | 🧩 Planned | Examples with Claude, Cursor, and Copilot |
| Community templates | 🧩 Planned | Shared workflows and prompt libraries |

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
