# Fox Height LTD — FOX-BUILD

**Strategic Architecture | Global Scaling | AGI Foundation**

> East Africa will not wait for the world to bring intelligence to it. Fox Height LTD is building, from Nairobi, the sovereign infrastructure upon which East African organisations will define and deploy their own artificial intelligence.

---

## Table of Contents

1. [Mission](#mission)
2. [The Intelligence Continuum](#the-intelligence-continuum)
3. [Quick Start](#quick-start)
4. [Architecture](#architecture)
5. [Documentation](#documentation)
6. [Contributing](#contributing)
7. [Security](#security)

---

## Mission

**Fox Height LTD** is East Africa's cloud and AI infrastructure company. We are headquartered in Westlands, Nairobi, and we build technology that East African organisations control — not technology that controls them.

Our work is organised around seven layers of the **Intelligence Continuum**: from sovereign infrastructure and zero trust security, through data governance and intelligent automation, to cognitive services integration and, at the frontier, **FoxOS** — our developing framework for aligned, controllable AGI deployment.

### What We Do (Today)

- Manage Azure environments with Zero Trust security posture
- Migrate on-premise systems to the cloud with Kenya DPA 2019 compliance
- Deploy Microsoft 365 across organisations with enterprise-grade governance
- Build AI agents that process documents and automate workflows
- Configure security systems that detect threats before they cause harm
- Price in Kenyan Shillings. Operate in East Africa Time. Serve East Africa first.

### What We're Building (Tomorrow)

**FoxOS**: A sovereign AGI orchestration layer that ensures artificial general intelligence, as it grows in capability, remains permanently aligned to the values and interests of the humans and institutions it serves in East Africa.

From a single sovereign Azure subscription in Nairobi, Fox Height is constructing the Intelligence Continuum — a layered, self-correcting architecture that begins with cloud governance and terminates at the responsible frontier of aligned AGI. We do not chase speed. We engineer permanence. We do not deploy features. We deploy infrastructure that learns, adapts, and remains unconditionally aligned with the humans it serves.

**The arc of our technology bends toward sovereignty. Always.**

---

## The Intelligence Continuum

Fox Height's architecture is organised as seven interdependent layers:

```
╔════════════════════════════════════════════════════════════════════════════╗
║ LAYER 6: OMNIGEN Scaling Architecture                                      ║
║          (Global EMEA replication, federated governance)                   ║
╠════════════════════════════════════════════════════════════════════════════╣
║ LAYER 5: FoxOS — Sovereign AGI Orchestration                               ║
║          (Constitutional constraints, alignment monitoring)                ║
╠════════════════════════════════════════════════════════════════════════════╣
║ LAYER 4: Cognitive Services Integration                                    ║
║          (Azure OpenAI, Document Intelligence, AI Search)                  ║
╠════════════════════════════════════════════════════════════════════════════╣
║ LAYER 3: Intelligent Automation                                            ║
║          (Logic Apps, Functions, RAG pipelines, agents)                    ║
╠════════════════════════════════════════════════════════════════════════════╣
║ LAYER 2: Data Sovereignty Engine                                           ║
║          (DPA 2019 compliance, encryption, residency)                      ║
╠════════════════════════════════════════════════════════════════════════════╣
║ LAYER 1: Zero Trust Security Mesh                                          ║
║          (Entra ID, Sentinel, PIM, Defender for Cloud)                     ║
╠════════════════════════════════════════════════════════════════════════════╣
║ LAYER 0: Sovereign Infrastructure Substrate                                ║
║          (Azure Landing Zone, management groups, policies)                 ║
╚════════════════════════════════════════════════════════════════════════════╝
```

Each layer is a distinct problem domain. Each layer is a prerequisite for the next. Each layer, once activated, strengthens all layers below it through recursive feedback loops. **No layer skips. No layer is optional. No layer is complete without documentation.**

---

## Quick Start

### For New Team Members

1. **Read this file** (you are here)
2. **Read [VISION.md](./VISION.md)** — understand the North Star
3. **Read [ARCHITECTURE.md](./ARCHITECTURE.md)** — understand the seven layers
4. **Read [ROADMAP.md](./ROADMAP.md)** — understand the build sequence
5. **Explore [docs/adr/](./docs/adr/)** — see architectural decisions
6. **Review [CONTRIBUTING.md](./CONTRIBUTING.md)** — before submitting anything

### For Contributors

```bash
# Clone the repository
git clone https://github.com/foxheight/FOX-BUILD.git
cd FOX-BUILD

# Read the contributing guidelines
cat CONTRIBUTING.md

# Set up your development environment (Linux/Mac)
bash scripts/setup.sh

# Set up your development environment (Windows)
PowerShell scripts/setup.ps1

# Validate your setup
python scripts/validate-all.py
```

### For Code Review

Every pull request must:

- ✅ Have a clear description of **why** this change exists
- ✅ Reference the relevant ADR or architectural principle
- ✅ Include tests that pass locally
- ✅ Pass all GitHub Actions checks (linting, tests, security scans)
- ✅ Have documentation headers in every file
- ✅ Explain the scaling algorithm (IF → THEN → NEXT logic)

---

## Architecture

### Layer 0: Sovereign Infrastructure Substrate

**Languages**: Bicep (Infrastructure as Code), PowerShell (automation)

The physical and logical foundation. Azure Landing Zone deployed with Well-Architected Framework compliance. Management groups, subscription hierarchy, policy assignments, RBAC taxonomy, and network topology established before any workload is deployed.

**Principle**: Deterministic infrastructure provisioning. Same input, same output, every time. No configuration drift. No snowflake servers.

### Layer 1: Zero Trust Security Mesh

**Languages**: PowerShell (policy), KQL (Sentinel queries), JSON (policies)

Perimeter is dead. Identity is the new perimeter. Microsoft Entra ID as the identity plane. Conditional Access policies enforced at every authentication event. Privileged Identity Management for all administrative roles.

**Principle**: Zero trust is not a product you buy. It is an architectural posture you build decision by decision, policy by policy, role by role.

### Layer 2: Data Sovereignty Engine

**Languages**: Python (data classification pipelines), C# (Azure Functions)

Every byte of client data has a documented jurisdiction. Azure Policy enforces data residency at subscription level. Kenya Data Protection Act 2019 compliance is a first-class architectural constraint, not a checkbox.

**Principle**: Data sovereignty is not privacy compliance. It is the assertion that East African organisations own their intelligence.

### Layer 3: Intelligent Automation

**Languages**: Python (RAG, LangChain), C# (Azure Functions), JavaScript (Copilot Studio), YAML (Logic Apps)

Azure Logic Apps and Azure Functions orchestrate business workflows. Retrieval Augmented Generation (RAG) pipelines ground AI outputs in verified, organisation-specific document corpora. Every AI action is logged, auditable, and reversible.

**Principle**: Automation that cannot explain itself should not run. Every agent action must be traceable to a document, a policy, or a human decision.

### Layer 4: Cognitive Services Integration

**Languages**: Python (ML pipelines, Azure ML SDK), C# (cognitive SDK), Jupyter Notebooks (research)

Azure OpenAI Service as the primary LLM inference endpoint. Azure AI Search as the vector store. Every model deployed undergoes evaluation against bias, hallucination, safety, and performance benchmarks before client-facing deployment.

**Principle**: Cognitive services are not magic. They are probabilistic systems with known failure modes. Engineer for the failure modes.

### Layer 5: FoxOS — Sovereign AGI Orchestration

**Languages**: C++ (performance-critical core), Python (alignment evaluation), Rust (memory-safe components)

A framework, being built brick by brick, that will govern how Fox Height's clients interact with artificial general intelligence systems when those systems arrive. Constitutional constraints that AI systems cannot violate. Human override mechanisms at every decision node.

**Principle**: An AGI system that cannot be stopped by a human with a laptop is not aligned. It is dangerous.

### Layer 6: OMNIGEN Scaling Architecture

**Languages**: Terraform (multi-cloud IaC), Go (API gateways), Python (orchestration), Kubernetes (orchestration)

When Fox Height's systems are mature and proven in the East African context, OMNIGEN defines the protocol for replication across EMEA emerging markets. Multi-region deployment patterns. Federated governance across jurisdictions.

**Principle**: What works in Nairobi must work in Lagos, Accra, Kampala, and Cairo with only configuration changes — not architectural changes.

---

## Documentation

### Core Documentation

- **[VISION.md](./VISION.md)** — Vision Statement, Mission Statement, Code Vision Arc, Core Values
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** — Detailed technical documentation of all seven layers
- **[ROADMAP.md](./ROADMAP.md)** — Phase-by-phase build sequence with gates and success criteria
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** — How to contribute, code standards, review process
- **[SECURITY.md](./SECURITY.md)** — Security policy, vulnerability reporting, Zero Trust posture

### Architectural Decision Records (ADRs)

All significant architectural decisions are documented in [docs/adr/](./docs/adr/):

- **ADR-001**: Language choices and why
- **ADR-002**: Azure-first strategy
- **ADR-003**: Zero Trust security posture
- **ADR-004**: RAG architecture and design
- **ADR-005**: FoxOS constitutional principles

### Layer-Specific Documentation

Each layer has detailed documentation in [docs/intelligence-continuum/](./docs/intelligence-continuum/):

- Layer 0: Infrastructure as Code patterns
- Layer 1: Security architecture and automation
- Layer 2: Data governance and compliance
- Layer 3: Automation and workflow design
- Layer 4: Cognitive services and RAG pipelines
- Layer 5: FoxOS design and principles
- Layer 6: Global scaling and federation

### Compliance Documentation

Regulatory alignment in [docs/compliance/](./docs/compliance/):

- Kenya Data Protection Act 2019 compliance framework
- Azure Policy catalogue and assignments
- Audit trail specification and implementation

---

## Repository Structure

```
FOX-BUILD/
├── README.md                    ← You are here
├── VISION.md                    ← Vision, Mission, North Star
├── ARCHITECTURE.md              ← Seven-layer technical docs
├── ROADMAP.md                   ← Phase-by-phase build sequence
├── CONTRIBUTING.md              ← Code standards and review process
├── SECURITY.md                  ← Security policy and vulnerability reporting
│
├── docs/                        ← All documentation
│   ├── adr/                     ← Architectural Decision Records
│   ├── intelligence-continuum/  ← Layer-by-layer technical docs
│   ├── foxos/                   ← FoxOS design documents
│   ├── compliance/              ← Regulatory alignment
│   └── research/                ← Fox Height research papers
│
├── src/                         ← All source code
│   ├── layer-0-infrastructure/  ← Bicep + PowerShell
│   ├── layer-1-security/        ← PowerShell + KQL
│   ├── layer-2-data/            ← Python + C#
│   ├── layer-3-automation/      ← Python + C# + JavaScript
│   ├── layer-4-cognitive/       ← Python + Jupyter
│   ├── layer-5-foxos/           ← C++ + Python + Rust
│   └── layer-6-omnigen/         ← Terraform + Go + Python
│
├── tests/                       ← All tests
│   ├── unit/                    ← Unit tests
│   ├── integration/             ← Integration tests
│   ├── security/                ← Security tests
│   └── alignment/               ← AGI alignment evaluations
│
├── scripts/                     ← Utility scripts
│   ├── setup.ps1                ← Windows setup
│   ├── setup.sh                 ← Linux/Mac setup
│   └── validate-all.py          ← Full system validation
│
└── .github/
    ├── workflows/
    │   ├── ci.yml               ← Continuous Integration
    │   ├── security-scan.yml    ← Automated security scanning
    │   └── deploy.yml           ← Deployment pipeline
    └── ISSUE_TEMPLATE/
        ├── bug_report.md
        └── feature_request.md
```

---

## Contributing

Fox Height welcomes contributions from engineers, architects, and security specialists who share our vision of African technological sovereignty.

### Before You Start

1. **Read [CONTRIBUTING.md](./CONTRIBUTING.md)**
2. **Read [SECURITY.md](./SECURITY.md)**
3. **Review relevant ADRs in [docs/adr/](./docs/adr/)**
4. **Understand the layer** you're working in

### Development Workflow

1. Create a feature branch: `git checkout -b feature/description`
2. Make your changes
3. Add tests (100% of code must be tested)
4. Run validation: `python scripts/validate-all.py`
5. Commit with meaningful message: `[LAYER-X] Description of what and why`
6. Push and create a pull request
7. Wait for review and address feedback

### Code Standards

- **Documentation**: Every file has a header explaining WHY it exists
- **Testing**: Every feature has passing tests
- **Security**: Every change passes security scanning
- **Compliance**: Every change respects Kenya DPA 2019
- **No TODOs**: If it's in the repo, it works. If it doesn't work, it doesn't ship.

---

## Security

Fox Height takes security seriously. Security vulnerabilities should be reported privately.

**Please do not open public issues for security vulnerabilities.**

Instead, email security details to the Fox Height security team (details in [SECURITY.md](./SECURITY.md)).

---

## Brand Identity

**Company**: Fox Height LTD
**Founder & CEO**: Samson Abuya Mobisa
**Headquarters**: Eden Square, 7th Floor, Chiromo Road, Westlands, Nairobi, Kenya
**Domain**: foxheight.com
**Brand Colours**: Teal #00F5C8 | Navy #0A1325
**Brand Fonts**: Sora (headings) | DM Sans (body) | JetBrains Mono (code)

---

## License

Fox Height LTD — FOX-BUILD is proprietary software. All rights reserved.

For licensing inquiries, contact Fox Height LTD.

---

## Governance Statement

This repository is the technical foundation of Fox Height LTD's mission to build East Africa's sovereign intelligence infrastructure. Every file in it represents a commitment — to clients whose data it governs, to regulators whose laws it enforces, and to the future it is building toward.

**Build it as if it will be the most important thing you have ever built. Because for the people it will serve, it will be.**

**Begin with Phase 0. Document before you code. Test before you ship. The Intelligence Continuum starts here. Build it to last.**

---

**FOX HEIGHT LTD — FROM NAIROBI. BUILT FOR AFRICA.**
