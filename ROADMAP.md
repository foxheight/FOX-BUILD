# Fox Height LTD — ROADMAP

**The Intelligence Continuum Build Sequence**

## PHASE 0: FOUNDATION DOCUMENTATION (Week 1)

**IF**: Repository does not exist with complete documentation
**THEN**: No code is written until it does
**WHY**: Architecture without documentation creates unmaintainable systems. Documentation is not overhead. It is the foundation.

### Deliverables

- ✅ Create github.com/foxheight/FOX-BUILD repository
- ✅ Write README.md (complete, not placeholder)
- ✅ Write VISION.md
- ✅ Write ARCHITECTURE.md
- ✅ Write ROADMAP.md
- ✅ Create directory structure
- ✅ Create ADR-001-language-choices.md
- ✅ Create CONTRIBUTING.md
- ✅ Create SECURITY.md
- ✅ Configure .github/workflows/ci.yml

**GATE**: All documentation reviewed and approved before Phase 1 begins.

---

## PHASE 1: SOVEREIGN INFRASTRUCTURE (Weeks 2-4)

**IF**: Phase 0 gate passed
**THEN**: Build Layer 0 — Azure Landing Zone
**LANGUAGE**: Bicep (Infrastructure as Code)

### Deliverables

- Management group hierarchy (foxheight-root, production, clients)
- Kenya DPA 2019 data residency policy
- Resource naming and tagging standards
- Network topology (hub-and-spoke)
- Role-based access control (RBAC) taxonomy
- Deploy and validate

**SUCCESS CRITERIA**:
- Infrastructure deployed
- Policy compliance score 90%+
- Zero resources outside approved regions
- ADR-002-azure-first.md completed

**GATE**: Infrastructure deployed, policies enforced, compliance verified.

---

## PHASE 2: ZERO TRUST SECURITY MESH (Weeks 5-7)

**IF**: Phase 1 gate passed
**THEN**: Build Layer 1 — Security Posture
**LANGUAGE**: PowerShell (automation), KQL (Sentinel analytics)

### Deliverables

- Microsoft Entra ID configuration
- Conditional Access policies
- Privileged Identity Management (PIM) setup
- Microsoft Sentinel analytics rules (10+)
- Microsoft Defender for Cloud configuration
- Microsoft Purview sensitivity labels
- Deploy and validate

**SUCCESS CRITERIA**:
- All users authenticated via Entra
- MFA enabled for all users
- Zero permanent admin accounts
- PIM enforced for privileged roles
- Sentinel running with analytics rules
- Defender for Cloud score 70%+
- ADR-003-zero-trust-posture.md completed

**GATE**: Secure Score 70%+. Security posture operational.

---

## PHASE 3: RAG INTELLIGENCE PIPELINE (Weeks 8-11)

**IF**: Phase 2 gate passed
**THEN**: Build Layer 4 — Cognitive Services (RAG core)
**LANGUAGE**: Python (primary), Jupyter Notebooks (evaluation)

### Deliverables

- RAG pipeline core (embeddings, retrieval, generation)
- Document ingestion and chunking
- Azure AI Search vector index
- Alignment evaluator (hallucination detection)
- Azure OpenAI integration
- Test data and evaluation notebooks
- Deploy and validate

**SUCCESS CRITERIA**:
- RAG pipeline ingests test documents
- Queries return grounded responses
- Evaluator catches injected hallucinations
- Alignment evaluation passing 95%+
- ADR-004-rag-architecture.md completed
- All code covered by unit tests

**GATE**: RAG pipeline production-ready. Alignment evaluator operational.

---

## PHASE 4: FOXOS CONSTITUTIONAL ENGINE (Weeks 12-16)

**IF**: Phase 3 gate passed AND alignment evaluator production-ready
**THEN**: Begin Layer 5 — FoxOS foundation
**LANGUAGE**: C++ (performance-critical core), Python (evaluation), Rust (memory-safe components)

### Deliverables

- Constitutional constraint engine (C++)
- Alignment monitoring framework (Python)
- Human override protocol (Rust)
- Interpretability and reasoning trace (Python)
- Formal verification report
- Test suite (unit, integration, alignment)
- Deploy and validate

**SUCCESS CRITERIA**:
- Constitutional engine unit tests 100%
- No false positives on permitted actions
- No false negatives on prohibited actions
- Override protocol latency < 100ms
- Alignment monitoring framework operational
- Formal verification completed
- ADR-005-foxos-principles.md completed

**GATE**: Constitutional engine proven. FoxOS foundation ready.

---

## PHASE 5: OMNIGEN GLOBAL SCALING (Months 6-12)

**IF**: Phases 0-4 gates all passed AND at least 3 production clients running on infrastructure
**THEN**: Begin Layer 6 — OMNIGEN scaling architecture
**LANGUAGE**: Terraform, Go, Python

### Deliverables

- Multi-region Terraform templates
- API gateway (Go)
- Federated governance framework
- Cost monitoring and optimization
- Health monitoring and alerting
- Deployment orchestration (Python)
- Test multi-region deployment

**SUCCESS CRITERIA**:
- All previous phases proven in production
- Multi-region templates created and tested
- API gateway operational
- Federated governance framework implemented
- 3+ production clients actively using infrastructure
- Cost monitoring and optimization in place

**GATE**: Global scaling architecture proven. Ready for EMEA expansion.

---

## GOVERNING RULES

### Build Sequence Discipline

**IF** a step cannot be completed without something from a previous step
**THEN** stop, complete the previous step, then return

- NEVER skip a step to reach a later one
- NEVER write placeholder code with a TODO comment
- NEVER commit a test file that does not run and pass
- NEVER commit without a meaningful commit message

### Commit Message Format

```
[LAYER-X] Brief description of what this commit does and why

Optional: Detailed explanation of the change, rationale, and testing
```

### Example

```
[LAYER-0] Add Kenya DPA 2019 data residency policy

This policy prevents resource deployment outside approved Azure regions.
Compliance is enforced by infrastructure, not by manual process.

Tested: Verified policy blocks resources in non-approved regions.
Justification: Kenya DPA 2019 requires data residency in approved jurisdictions.
```

---

## Documentation Standards

Every file in the repository must have:

1. **FILE HEADER** — Why does this file exist?
2. **ARCHITECTURE LINK** — Which layer does this belong to?
3. **PRINCIPLE** — What governing principle does this implement?
4. **SCALING ALGORITHM** — What is the IF→THEN→NEXT logic?
5. **DEPENDENCIES** — What does this file need to function?
6. **TESTS** — Where are the tests for this file?

---

## Success Criteria Summary

| Phase | Status | Duration | Deliverable |
|-------|--------|----------|-------------|
| Phase 0 | ✅ Complete | Week 1 | Foundation documentation |
| Phase 1 | ⏳ Pending | Weeks 2-4 | Layer 0 infrastructure |
| Phase 2 | ⏳ Pending | Weeks 5-7 | Layer 1 security |
| Phase 3 | ⏳ Pending | Weeks 8-11 | Layer 4 cognitive services |
| Phase 4 | ⏳ Pending | Weeks 12-16 | Layer 5 FoxOS |
| Phase 5 | ⏳ Pending | Months 6-12 | Layer 6 scaling |

---

**FOX HEIGHT LTD — FROM NAIROBI. BUILT FOR AFRICA.**
