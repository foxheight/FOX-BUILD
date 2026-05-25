# ADR-001: Language Choices for Intelligence Continuum

## Status: Accepted

## Context

Fox Height's Intelligence Continuum spans seven layers with diverse technical requirements:

- **Layer 0**: Infrastructure provisioning and policy automation
- **Layer 1**: Security automation and log analysis
- **Layer 2**: Data classification and validation
- **Layer 3**: Workflow orchestration and automation
- **Layer 4**: Machine learning and cognitive services
- **Layer 5**: Performance-critical constraints and memory safety
- **Layer 6**: Multi-region infrastructure and API gateways

Choosing the right language for each layer is critical for maintainability, performance, and sovereignty (not relying on external dependencies for core concerns).

## Decision

We adopt the following language composition:

### Layer 0: Sovereign Infrastructure Substrate

- **Bicep** for Infrastructure as Code
  - Native Azure IaC language
  - Declarative syntax
  - Version-controlled, peer-reviewed deployments
  - ARM-native compilation

- **PowerShell** for automation
  - Native Azure management language
  - Idiomatic for Azure operations
  - Scripting and orchestration
  - Ad-hoc operations and validation

### Layer 1: Zero Trust Security Mesh

- **PowerShell** for policy configuration and deployment
  - Conditional Access policies
  - Privileged Identity Management
  - Sensitivity labels and DLP rules

- **KQL** (Kusto Query Language) for security analytics
  - Sentinel rules and queries
  - Hunting queries
  - Incident investigation

- **JSON** for policy definitions
  - Azure Policy definitions
  - Role-based access control (RBAC) templates

### Layer 2: Data Sovereignty Engine

- **Python** for data classification pipelines
  - Data classification logic
  - DPA 2019 validation
  - Integration with Azure services

- **C#** for Azure Functions
  - Data processing and transformation
  - Integration with Azure Cosmos DB, Blob Storage

### Layer 3: Intelligent Automation Layer

- **Python** for RAG pipelines and agent orchestration
  - LangChain framework
  - Azure OpenAI SDK integration
  - Document processing

- **C#** for Azure Functions
  - Custom business logic
  - Webhook handling
  - Integration with enterprise systems

- **JavaScript** for Copilot Studio extensions
  - Custom Copilot plugins
  - Front-end logic

- **YAML** for Logic App and workflow definitions
  - Declarative workflow definitions
  - Version control friendly

### Layer 4: Cognitive Services Integration

- **Python** for ML pipelines and evaluation
  - Azure Machine Learning SDK
  - Model training and fine-tuning
  - Responsible AI evaluation
  - Alignment testing

- **C#** for cognitive services SDK integration
  - Document Intelligence
  - Azure OpenAI integration
  - Production inference endpoints

- **Jupyter Notebooks** for research and experimentation
  - Exploratory data analysis
  - Model evaluation
  - Documentation of findings

### Layer 5: FoxOS — Sovereign AGI Orchestration

- **C++** for constitutional engine
  - Performance-critical decision-making
  - Deterministic, low-latency evaluation
  - No garbage collection pauses
  - Immutable constraint sets

- **Python** for alignment monitoring and evaluation
  - Behavioral evaluation of AI systems
  - Drift detection
  - Metrics collection and analysis

- **Rust** for override protocol
  - Memory safety without garbage collection
  - Critical security-sensitive code
  - Zero undefined behavior
  - High confidence in correctness

### Layer 6: OMNIGEN Scaling Architecture

- **Terraform** for multi-cloud IaC
  - Multi-region deployment
  - Federated governance
  - Cloud-agnostic templates

- **Go** for API gateways
  - High-performance request routing
  - Minimal resource footprint
  - Concurrency-native
  - Cross-platform binary compilation

- **Python** for orchestration
  - Deployment automation
  - Health checking and monitoring
  - Cost optimization

- **Kubernetes** YAML for container orchestration (optional)
  - Multi-region container orchestration
  - Service mesh configuration
  - Auto-scaling policies

## Rationale

### Why Bicep over Terraform for Layer 0?

- **Sovereignty**: Bicep is native to Azure, reducing dependency on external tooling
- **Idiomatic**: Developers familiar with ARM templates find Bicep natural
- **Integration**: Direct compilation to ARM JSON
- **Determinism**: Same input always produces same output

### Why PowerShell for automation?

- **Native**: Microsoft's official management language for Azure
- **Richness**: Complete access to Azure management APIs
- **Consistency**: Already in use across Azure teams
- **Ecosystem**: Extensive module library

### Why Python for data and ML?

- **Industry Standard**: Python dominates data science and ML
- **Azure Integration**: Official Azure SDKs are Python-native
- **Ecosystem**: LangChain, pandas, scikit-learn, PyTorch
- **Readability**: Code is self-documenting

### Why C++ for constitutional engine?

- **Performance**: Deterministic, low-latency decision-making
- **Control**: Full control over memory and execution
- **Safety Critical**: Immutable constraint sets, no runtime modification
- **Confidence**: Type system and compile-time guarantees

### Why Rust for override protocol?

- **Memory Safety**: No buffer overflows, use-after-free, or race conditions
- **Security**: Zero-cost abstractions with strong safety guarantees
- **Critical**: Override mechanisms must be bulletproof
- **Confidence**: Rust's borrow checker provides high assurance

### Why Go for API gateways?

- **Performance**: Lightweight, fast startup, minimal resource footprint
- **Concurrency**: Goroutines make concurrent request handling trivial
- **Deployment**: Single binary, no runtime dependencies
- **Monitoring**: Built-in profiling and metrics

## Consequences

### Positive

- ✅ **Right tool for right job**: Each layer uses the language best suited to its problem
- ✅ **Sovereignty**: Minimal external dependencies for core concerns
- ✅ **Performance**: Optimized for specific use cases (C++ for latency, Go for throughput)
- ✅ **Safety**: Rust guarantees eliminate entire classes of vulnerabilities
- ✅ **Maintainability**: Clear separation of concerns by language
- ✅ **Team expertise**: Leverages existing Azure and Python ecosystem expertise

### Negative

- ⚠️ **Skill diversity**: Team must maintain competency in multiple languages
- ⚠️ **Build complexity**: Multiple build systems (CMake, cargo, go build, etc.)
- ⚠️ **Onboarding**: New team members must learn multiple language ecosystems
- ⚠️ **Interop**: Multiple languages require careful API design at boundaries

### Mitigations

- **Training**: Comprehensive onboarding for each language
- **Documentation**: Every file explains its purpose and design
- **Standards**: Consistent code style and review process across languages
- **Abstraction**: Clear API boundaries between language layers
- **Testing**: Comprehensive tests for all language integration points

## Alternatives Considered

### Alternative 1: Monolingual Python

**Rejected**:
- Layer 0 (infrastructure) requires Bicep for Azure-native semantics
- Layer 5 (constitutional engine) requires C++ for determinism
- Layer 6 (API gateway) would be suboptimal in Python (lower throughput)

### Alternative 2: Microsoft C# everywhere

**Rejected**:
- Python is superior for ML/data science
- Go is superior for API gateways
- Rust is superior for security-critical code
- Would lock us into .NET ecosystem

### Alternative 3: All compiled languages (C++, Rust, Go)

**Rejected**:
- Python is essential for ML and data science
- Rapid development and experimentation require Python
- Production scripts and orchestration are better in Python

## References

- [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview)
- [PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)
- [Python Azure SDKs](https://learn.microsoft.com/en-us/azure/developer/python/)
- [Go Documentation](https://golang.org/doc/)
- [Rust Book](https://doc.rust-lang.org/book/)
- [C++ Reference](https://en.cppreference.com/)

---

**FOX HEIGHT LTD — FROM NAIROBI. BUILT FOR AFRICA.**
