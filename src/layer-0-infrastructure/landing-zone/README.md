# Layer 0: Sovereign Infrastructure Substrate

## Overview

Layer 0 is the foundational infrastructure layer of Fox Height's Intelligence Continuum. It establishes the governance structure, compliance framework, and baseline security posture for all workloads deployed across Fox Height's Azure tenant.

## Architecture

### Management Group Hierarchy

```
foxheight-root (Tenant Root)
├── foxheight-production      (Production workloads)
├── foxheight-staging         (Pre-production testing)
├── foxheight-development     (Development environments)
├── foxheight-clients         (Client-specific environments)
└── foxheight-governance      (Shared governance services)
```

### Files

- **main.bicep** — Master orchestrator (tenant scope)
- **policies.bicep** — Kenya DPA 2019 compliance policies
- **rbac.bicep** — Custom RBAC roles and assignments
- **networking.bicep** — Hub-and-spoke network topology

## Kenya DPA 2019 Compliance

All resources deployed through Layer 0 are governed by Kenya Data Protection Act 2019:

- **Data Residency**: All data must remain in approved South African regions (southafricanorth, southafricawest)
- **Encryption**: All storage and databases require encryption at rest
- **Access Control**: Role-based access with audit logging
- **Data Classification**: Purview-based classification and labeling

## Deployment

### Prerequisites

```bash
# Install Azure CLI
az --version

# Install Bicep CLI
az bicep install

# Authenticate to Azure
az login

# Set context to target tenant
az account set --subscription <subscription-id>
```

### Deploy Layer 0

```powershell
# Validate Bicep templates
./scripts/deploy.ps1 -ManagementGroupId <mgid> -ValidateOnly

# Deploy to tenant
./scripts/deploy.ps1 -ManagementGroupId <mgid>

# Validate post-deployment
./scripts/validate.ps1 -ManagementGroupId <mgid>
```

## Testing

```bash
# Run unit tests
pytest tests/unit/test_infrastructure.py -v

# Run integration tests
pytest tests/integration/test_layer0_deployment.py -v

# Run security tests
pytest tests/security/test_zero_trust_posture.py -v
```

## Compliance Verification

```bash
# Check policy compliance
az policy assignment list --scope /providers/Microsoft.Management/managementGroups/foxheight-root

# View compliance score
az policy assignment show --name foxheight-kenya-dpa-data-residency
```

## Troubleshooting

### Management Group Creation Fails

- Verify tenant admin permissions
- Check that management group names are globally unique
- Ensure Bicep CLI is up to date

### Policy Assignment Fails

- Verify policy definition is registered
- Check policy scope matches target management group
- Review policy syntax for errors

### Network Deployment Issues

- Ensure hub vnet does not conflict with existing networks
- Verify spoke subscription has network contributor role
- Check NSG rules for default-deny configuration

## Next Steps

**Phase 1 Gate Criteria** (All must pass):
- ✅ Management groups deployed and hierarchically correct
- ✅ Kenya DPA 2019 policy enforced with 'deny' effect
- ✅ All tests passing (80%+ coverage)
- ✅ Zero resources outside approved regions
- ✅ RBAC taxonomy established
- ✅ ADR-002 (Azure-first) written

**Phase 2: Zero Trust Security Mesh** (Layer 1)
- Microsoft Entra ID conditional access
- Privileged Identity Management (PIM)
- Microsoft Sentinel rules
- Microsoft Defender for Cloud
