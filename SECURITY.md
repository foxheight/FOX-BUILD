# FOX-BUILD Security Policy

## Reporting Security Vulnerabilities

**Please do not open public issues for security vulnerabilities.**

Security vulnerabilities should be reported privately to the Fox Height security team.

**Email**: security@foxheight.com

**Include**:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)

We will acknowledge your report within 24 hours and provide a timeline for resolution.

## Security Principles

Fox Height's security posture is built on the following principles:

### 1. Zero Trust Architecture

- Identity is the new perimeter
- Every access is verified
- Every action is logged
- No permanent elevated access
- MFA mandatory for all users

### 2. Data Sovereignty

- All client data in approved Azure regions
- Encryption at rest and in transit
- Data classification mandatory
- Kenya DPA 2019 compliance enforced
- Audit trails for all access

### 3. Infrastructure as Code

- All infrastructure version-controlled
- All policies peer-reviewed
- No manual changes (no snowflake servers)
- Automated deployment and validation
- Immutable infrastructure where possible

### 4. Secure by Default

- Security is not a feature, it is the foundation
- Every system defaults to the most secure configuration
- Opt-out of security requires explicit justification and approval
- All defaults are enforced by policy

### 5. Transparency

- All security decisions documented
- All policies version-controlled
- All vulnerabilities publicly disclosed (after fix)
- Regular security audits and reports

## Security Requirements for Contributors

Every pull request must:

### Code Security

- ✅ No hardcoded secrets or credentials
- ✅ No plaintext passwords in code
- ✅ No API keys in repositories
- ✅ Proper input validation and sanitization
- ✅ Secure coding practices for your language

### Dependency Security

- ✅ No unpatched known vulnerabilities
- ✅ Dependency versions pinned in lock files
- ✅ Regular dependency updates and patches
- ✅ Security advisory monitoring

### Encryption

- ✅ Encryption in transit (TLS 1.3 minimum)
- ✅ Encryption at rest (TDE, CMK, or equivalent)
- ✅ Key management in Azure Key Vault
- ✅ No custom cryptography

### Authentication & Authorization

- ✅ All authentication via Entra ID
- ✅ No local accounts
- ✅ MFA enforced
- ✅ PIM for privileged access
- ✅ RBAC properly configured

### Logging & Audit

- ✅ All security events logged
- ✅ Logs sent to Azure Monitor/Sentinel
- ✅ Immutable audit trails
- ✅ Logs retained per compliance requirements

### Data Protection

- ✅ Kenya DPA 2019 compliance
- ✅ Data classification applied
- ✅ Sensitivity labels enforced
- ✅ Data residency respected
- ✅ Data ownership documented

## Automated Security Scanning

All pull requests undergo automated security scanning:

### SAST (Static Analysis)

- **Trivy**: Container and dependency scanning
- **Bandit**: Python security linting
- **Ruff**: Python code quality
- **Semgrep**: Generic security patterns

### DAST (Dynamic Analysis)

- **Defender for Cloud**: Azure resource scanning
- **Sentinel**: Log analysis and threat detection
- **Penetration Testing**: Quarterly (external)

### Dependency Scanning

- **Dependabot**: Automated dependency updates
- **NVD**: National Vulnerability Database
- **GitHub Security Advisories**: Advisory monitoring

## Security Review Process

For security-sensitive changes:

1. **Notify maintainers** in PR description
2. **Provide justification** for security design decisions
3. **Include threat model** (what are we protecting against?)
4. **Document assumptions** (what must be true for this to be secure?)
5. **Wait for security review** before merging

## Incident Response

If a security vulnerability is discovered:

1. **Immediately notify** security@foxheight.com
2. **Do not discuss publicly** (no public issues, slack, twitter, etc.)
3. **Provide reproduction steps** and potential impact
4. **Wait for confirmation** and timeline
5. **Do not patch without approval** (coordinated disclosure)

## Compliance

Fox Height maintains compliance with:

- **Kenya Data Protection Act 2019** (DPA 2019)
- **Azure Security Benchmark**
- **NIST Cybersecurity Framework**
- **ISO 27001** (planned)

## Security Contacts

- **Security Issues**: security@foxheight.com
- **Responsible Disclosure**: Follow instructions above
- **General Security Questions**: Open an issue on GitHub

## Bug Bounty Program

Fox Height may offer a bug bounty program in the future. Check [foxheight.com](https://foxheight.com) for details.

---

**FOX HEIGHT LTD — FROM NAIROBI. BUILT FOR AFRICA.**
