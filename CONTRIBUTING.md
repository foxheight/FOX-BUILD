# Contributing to FOX-BUILD

Fox Height welcomes contributions from engineers, architects, and security specialists who share our vision of African technological sovereignty.

## Before You Start

1. **Read [VISION.md](./VISION.md)** — Understand the North Star
2. **Read [ARCHITECTURE.md](./ARCHITECTURE.md)** — Understand the seven layers
3. **Read [SECURITY.md](./SECURITY.md)** — Understand security requirements
4. **Review relevant ADRs** in [docs/adr/](./docs/adr/)
5. **Understand the layer** you are working in

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/description
```

Branch names should be descriptive: `feature/layer-0-bicep-policies`, `fix/rag-evaluator-hallucination`, etc.

### 2. Make Your Changes

- **Add documentation** to every file explaining WHY it exists
- **Write tests** (minimum 80% code coverage)
- **Follow code style** guidelines for your language
- **Reference ADRs** that justify your design decisions

### 3. Add Tests

**Every feature must have passing tests.**

```bash
# Python
pytest tests/unit/ --cov=src --cov-fail-under=80

# PowerShell (when applicable)
Pester tests/

# C++ (when applicable)
cmake build && ctest
```

### 4. Run Validation

```bash
python scripts/validate-all.py
```

This script checks:
- ✅ Documentation completeness
- ✅ Code linting and style
- ✅ Type checking (where applicable)
- ✅ All tests passing
- ✅ Security scanning
- ✅ Code coverage

### 5. Commit with Meaningful Message

```bash
git commit -m "[LAYER-X] Description of what and why"
```

**Example**:
```
[LAYER-4] Implement hallucination detector for RAG evaluator

Adds semantic similarity comparison between generated responses
and retrieved documents. Scores responses on 0.0-1.0 scale where
0.0 = fully grounded and 1.0 = fully fabricated.

Fails responses scoring above 0.3 (configurable threshold).
Includes unit tests with 95% coverage and integration test
with injected hallucinations.
```

### 6. Push and Create Pull Request

```bash
git push origin feature/description
```

Then create a pull request on GitHub with:
- Clear title: `[LAYER-X] Brief description`
- Detailed description of changes
- Reference to related ADR or architectural principle
- Test results (pass/fail)
- Any known limitations or future work

### 7. Wait for Review

All PRs require:
- ✅ Code review (1+ maintainer approval)
- ✅ All CI/CD checks passing
- ✅ Documentation complete
- ✅ Tests passing
- ✅ Security review (for security-related changes)

## Code Standards

### Documentation

Every file must have a header explaining:

```python
"""
why_this_file_exists.py

WHY THIS FILE:
Explain the purpose and responsibility of this file.

ARCHITECTURE LAYER:
Which layer does this belong to? (Layer 0-6)

PRINCIPLE:
What governing principle does this implement?

SCALING ALGORITHM:
IF condition THEN action THEN next_action

DEPENDENCIES:
What external dependencies does this have?

TESTS:
Where are the tests for this file?
see tests/unit/test_why_this_file_exists.py
"""
```

### Testing

- **Unit Tests**: Test individual functions/classes
- **Integration Tests**: Test module interactions
- **Security Tests**: Test for security vulnerabilities
- **Alignment Tests** (Layers 3-5): Test AI alignment properties

**Test File Naming**:
- `tests/unit/test_module_name.py`
- `tests/integration/test_module_integration.py`
- `tests/security/test_module_security.py`
- `tests/alignment/test_module_alignment.py`

### No TODOs

**NEVER commit code with TODO comments.**

If it is in the repository, it works. If it does not work, it does not ship.

If you cannot complete a feature:
- Do not commit placeholder code
- Close the PR
- Open an issue describing what needs to be done
- Come back when you can complete it

### Security

Every change must:
- ✅ Pass security scanning (Trivy, bandit, etc.)
- ✅ Not introduce new vulnerabilities
- ✅ Respect Zero Trust principles
- ✅ Comply with Kenya DPA 2019
- ✅ Not expose secrets or credentials
- ✅ Include security tests where applicable

### Compliance

Every change must:
- ✅ Respect Kenya Data Protection Act 2019
- ✅ Document data flows and classifications
- ✅ Enforce data residency policies
- ✅ Include audit trails where applicable
- ✅ Not bypass encryption requirements

## Code Style

### Python

- **Formatter**: Black
- **Linter**: Ruff
- **Type Checker**: Mypy

```bash
black src/
ruff check src/
mypy src/
```

### PowerShell

- **Style**: Microsoft.PowerShell.ScriptAnalyzer
- **Format**: PascalCase for functions and variables

```powershell
Invoke-ScriptAnalyzer -Path src/ -Recurse
```

### Bicep

- **Format**: Azure Bicep format (2 spaces)
- **Naming**: camelCase for variables and functions

```bash
bicep format --file src/layer-0-infrastructure/main.bicep
```

### C++

- **Standard**: C++17 or later
- **Style**: Google C++ Style Guide
- **Build**: CMake

### Rust

- **Style**: Rust 2021 edition
- **Formatter**: rustfmt
- **Linter**: clippy

## Architectural Decision Records (ADRs)

For significant architectural decisions, create an ADR:

```markdown
# ADR-XXX: [Decision Title]

## Status: [Proposed | Accepted | Deprecated | Superseded]

## Context
What is the situation that required this decision?

## Decision
What did we decide?

## Rationale
Why did we make this decision over the alternatives?

## Consequences
What are the positive and negative consequences?

## Alternatives Considered
What other options did we evaluate?
```

Place in [docs/adr/](./docs/adr/) with naming: `ADR-NNN-title.md`

## Getting Help

- **Questions about architecture**: See [ARCHITECTURE.md](./ARCHITECTURE.md)
- **Questions about vision**: See [VISION.md](./VISION.md)
- **Security concerns**: See [SECURITY.md](./SECURITY.md)
- **Process questions**: Create an issue on GitHub

## Code of Conduct

Fox Height is committed to fostering an inclusive and respectful environment.

- Treat all contributors with respect
- Welcome diverse perspectives
- Focus on technical merit
- No harassment or discrimination
- Escalate conflicts to maintainers

---

**FOX HEIGHT LTD — FROM NAIROBI. BUILT FOR AFRICA.**
