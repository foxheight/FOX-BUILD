# ADR-003: Zero Trust Security Posture and Identity-First Architecture

**Status**: Accepted  
**Date**: 2026-06-01  
**Author**: Samson Abuya Mobisa, CEO & Founder  
**Affects**: All Layers, especially Layer 0-1

---

## Context

Traditional security models assume a trusted network perimeter. Requests from "inside the perimeter" are considered low-risk; requests from "outside" are scrutinized. This model fails in modern cloud environments where:

1. Users work from anywhere (home, office, mobile)
2. Services are distributed across regions and providers
3. Insider threats are common
4. Data breach costs exceed $4M globally

Fox Height must adopt a security model appropriate for cloud-native operations and regulatory requirements of East African financial institutions.

---

## Decision

Fox Height adopts **Zero Trust Security** as the foundational security posture for all infrastructure and applications.

### Core Principles

**1. Verify Every Request**
- No implicit trust based on network location
- Every authentication event is evaluated independently
- Every authorization decision is explicit and logged

**2. Identity is the New Perimeter**
- Microsoft Entra ID (formerly Azure AD) is the single source of truth for identity
- All users, services, and devices authenticate through Entra ID
- No password-based authentication for administrative access

**3. Assume Breach**
- Design assumes credential compromise is possible
- Rapid detection and response systems are mandatory
- Data isolation prevents lateral movement after breach

**4. Microsegmentation**
- Network isolation between client environments
- VNET isolation within Fox Height infrastructure
- No default trust between segments

### Architecture

**Identity Layer**: Microsoft Entra ID + Conditional Access
```
Every authentication event:
  ✓ Verify user identity (MFA required)
  ✓ Evaluate device compliance (only managed devices)
  ✓ Check geographic location (flag impossible travel)
  ✓ Assess risk (anomalous behavior detection)
  → If all checks pass: Grant token
  → If any check fails: Block and alert
```

**Privileged Access Management**: Privileged Identity Management (PIM)
```
Administrative roles:
  • No permanent assignment (zero standing privileges)
  • Request-based temporary elevation (max 4 hours)
  • Justification required
  • Multi-factor authentication required
  • Approval workflow for sensitive roles
  • Automatic expiration and de-escalation
```

**Detection & Response**: Microsoft Sentinel
```
Continuous monitoring of:
  • Impossible travel (user in Nairobi then New York in 30 min)
  • Bulk permission changes (detect privilege escalation)
  • Anonymous access attempts
  • Policy violations
  • Suspicious application access patterns
  → Automated incident response (block user, disable token)
```

**Threat Protection**: Microsoft Defender for Cloud
```
Real-time security posture management:
  • Continuous resource compliance scanning
  • Vulnerability assessment
  • Advanced threat protection
  • Secure score feedback and remediation guidance
```

### Implementation

**Layer 0 (Infrastructure)**:
- Management groups enforce Conditional Access policy assignment
- Network security groups (NSGs) microsegment traffic
- No public endpoints for administrative access

**Layer 1 (Zero Trust Mesh)**:
- Entra ID mandatory for all authentication
- PIM for all administrative roles
- Sentinel monitoring active 24/7
- Defender for Cloud continuous assessment

**Layer 3+ (Applications)**:
- Service principals (managed identities) authenticated to Entra ID
- No hardcoded credentials in code or configuration
- Token-based authentication for all service-to-service communication

---

## Consequences

### Positive

✅ **Credential compromise containment**: Breached credentials have limited blast radius  
✅ **Insider threat mitigation**: Every action is logged and auditable  
✅ **Regulatory alignment**: Zero Trust satisfies Kenya DPA 2019 requirements  
✅ **Continuous compliance**: Posture assessment is automated, not manual  
✅ **Rapid incident response**: Automated detection and blocking reduces MTTR  

### Negative

⚠️ **User friction**: MFA and Conditional Access can slow legitimate workflows  
⚠️ **Operational complexity**: Monitoring and alerting require skilled security staff  
⚠️ **Learning curve**: Teams must unlearn perimeter-based security thinking  

### Mitigations

- **User enablement**: Clear documentation and training for MFA and Conditional Access
- **Gradual rollout**: Phased enforcement of policies (report-only mode first)
- **Automated monitoring**: Sentinel playbooks automate response, reducing manual investigation
- **Security operations center**: Fox Height Security team operates 24/7

---

## Validation

This ADR is validated through:

1. **Phase 1 deployment**: Conditional Access policies deployed and enforced
2. **Phase 2 completion**: Sentinel analytics rules active, detecting anomalies
3. **Security audits**: Third-party assessment confirms Zero Trust posture
4. **Incident response drills**: Automated response tested and verified

---

## References

- [Microsoft Zero Trust Security Model](https://learn.microsoft.com/en-us/security/zero-trust/)
- [Conditional Access Policies](https://learn.microsoft.com/en-us/azure/active-directory/conditional-access/overview)
- [Privileged Identity Management](https://learn.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-configure)
- [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/overview)
- [Kenya DPA 2019 Security Requirements](https://www.dpp.go.ke/documents/)
