# Fox Height LTD — ARCHITECTURE

**The Intelligence Continuum: Seven Layers to Sovereign AI**

The Intelligence Continuum is Fox Height's master architecture — a seven-layer hierarchical system in which each layer is a prerequisite for the next.

## LAYER 0: Sovereign Infrastructure Substrate

**Languages**: Bicep (Infrastructure as Code), PowerShell (automation)

The physical and logical foundation. Azure Landing Zone deployed with Well-Architected Framework compliance. Management groups, subscription hierarchy, policy assignments, RBAC taxonomy, and network topology established before any workload is deployed.

**Principle**: Deterministic infrastructure provisioning. Same input, same output, every time.

---

## LAYER 1: Zero Trust Security Mesh

**Languages**: PowerShell (policy), KQL (Sentinel queries), JSON (policies)

Perimeter is dead. Identity is the new perimeter. Microsoft Entra ID as the identity plane. Conditional Access policies enforced at every authentication event. Privileged Identity Management for all administrative roles.

**Principle**: Zero trust is not a product you buy. It is an architectural posture you build decision by decision, policy by policy, role by role.

---

## LAYER 2: Data Sovereignty Engine

**Languages**: Python (data classification pipelines), C# (Azure Functions)

Every byte of client data has a documented jurisdiction. Azure Policy enforces data residency at subscription level. Kenya Data Protection Act 2019 compliance is a first-class architectural constraint.

**Principle**: Data sovereignty is not privacy compliance. It is the assertion that East African organisations own their intelligence.

---

## LAYER 3: Intelligent Automation Layer

**Languages**: Python (RAG, LangChain), C# (Azure Functions), JavaScript (Copilot Studio), YAML (Logic Apps)

Azure Logic Apps and Azure Functions orchestrate business workflows. Retrieval Augmented Generation (RAG) pipelines ground AI outputs in verified, organisation-specific document corpora.

**Principle**: Automation that cannot explain itself should not run. Every agent action must be traceable to a document, a policy, or a human decision.

---

## LAYER 4: Cognitive Services Integration

**Languages**: Python (ML pipelines, Azure ML SDK), C# (cognitive SDK), Jupyter Notebooks (research)

Azure OpenAI Service as the primary LLM inference endpoint. Azure AI Search as the vector store. Every model deployed undergoes evaluation against bias, hallucination, safety, and performance benchmarks.

**Principle**: Cognitive services are not magic. They are probabilistic systems with known failure modes. Engineer for the failure modes.

---

## LAYER 5: FoxOS — Sovereign AGI Orchestration

**Languages**: C++ (performance-critical core), Python (alignment evaluation), Rust (memory-safe components)

A framework, being built brick by brick, that will govern how Fox Height's clients interact with artificial general intelligence systems when those systems arrive.

**Principle**: An AGI system that cannot be stopped by a human with a laptop is not aligned. It is dangerous.

---

## LAYER 6: OMNIGEN Scaling Architecture

**Languages**: Terraform (multi-cloud IaC), Go (API gateways), Python (orchestration), Kubernetes (orchestration)

When Fox Height's systems are mature and proven in the East African context, OMNIGEN defines the protocol for replication across EMEA emerging markets.

**Principle**: What works in Nairobi must work in Lagos, Accra, Kampala, and Cairo with only configuration changes — not architectural changes.

---

## Cross-Layer Principles

### Documentation First

Every file has a documentation header explaining why it exists, which layer it belongs to, and what principle it implements.

### Testing Required

Unit tests, integration tests, security tests, and alignment tests. Minimum 80% code coverage.

### No TODOs

If it is in the repository, it works. If it does not work, it does not ship.

### Kenya DPA 2019 Compliance

Every layer must respect Kenya Data Protection Act 2019. This is not a feature. This is the foundation.

### Transparency

Every decision documented. Every trade-off explained. Every alternative considered.

---

**FOX HEIGHT LTD — FROM NAIROBI. BUILT FOR AFRICA.**
