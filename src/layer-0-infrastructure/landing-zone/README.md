# Layer 0 — Sovereign Infrastructure Substrate

## Overview

This directory contains the Azure Landing Zone infrastructure-as-code for Fox Height LTD's sovereign cloud foundation.

### What is Layer 0?

Layer 0 is the physical and logical foundation of the Intelligence Continuum. It establishes:

- **Management Group Hierarchy**: Organisational governance tree with policy cascade
- **Policy Enforcement**: Kenya DPA 2019 compliance, encryption, data residency
- **Network Topology**: Hub-and-spoke architecture with zero-trust networking
- **RBAC Taxonomy**: Role-based access control hierarchy
- **Monitoring Foundation**: Centralized logging, alerts, audit trails

### Key Principles

- **Deterministic**: Same input always produces same output
- **Immutable**: Infrastructure state is defined and version-controlled
- **Compliant**: DPA 2019 enforcement at infrastructure level
- **Auditable**: Every change is logged and traceable

## Files

### `main.bicep`
Master orchestration template that deploys:
- Management groups
- Policies
- Resource groups
- Networking (hub-and-spoke)
- Key Vault
- Storage
- Monitoring (App Insights, Log Analytics)

### `management-groups.bicep`
Defines the management group hierarchy:
```
foxheight-root
├── foxheight-production
│   ├── foxheight-dev
│   ├── foxheight-staging
│   └── foxheight-prod-workloads
└── foxheight-clients
```

### `policies.bicep`
Azure Policy definitions for:
- Kenya DPA 2019 data residency
- HTTPS enforcement
- TLS 1.2+ requirements
- Public blob access prevention
- Resource tagging

## Deployment

### Prerequisites

- Azure CLI or PowerShell
- Tenant-level Management Group Contributor role
- Subscription Owner role

### Deploy via PowerShell

```powershell
.\deploy.ps1 `
    -Environment prod `
    -SubscriptionId "00000000-0000-0000-0000-000000000000" `
    -TenantId "00000000-0000-0000-0000-000000000000"
```

### Deploy via Azure CLI

```bash
az deployment tenant create \
    --name "fox-height-landing-zone" \
    --location southafricanorth \
    --template-file main.bicep \
    --parameters environment=prod primaryRegion=southafricanorth secondaryRegion=southafricawest
```

## Compliance Verification

After deployment, verify compliance:

```powershell
# Check policy compliance
Get-AzPolicyState -ResourceGroupName "foxheight-core-prod" | Where-Object {$_.ComplianceState -eq 'NonCompliant'}

# Verify all resources are in approved regions
Get-AzResource | Where-Object {$_.Location -notin @('southafricanorth', 'southafricawest')} | Select-Object Name, Location
```

## Testing

Unit tests are located in `tests/unit/test_infrastructure_deployment.py`

```bash
pytest tests/unit/test_infrastructure_deployment.py -v
```

## Governance

This layer establishes the constitutional foundation for all Fox Height infrastructure. Changes must:

1. Maintain Kenya DPA 2019 compliance
2. Pass all policy evaluations
3. Be reviewed by Security team
4. Include updated ADRs
5. Pass all tests
