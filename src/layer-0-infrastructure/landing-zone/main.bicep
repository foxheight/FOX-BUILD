// ╔═════════════════════════════════════════════════════════════════════════════╗
// ║  Fox Height LTD — Layer 0: Sovereign Infrastructure Substrate               ║
// ║  File: main.bicep (Master Orchestrator)                                     ║
// ║  Layer: 0 (Infrastructure Foundation)                                       ║
// ║  Purpose: Tenant-scoped orchestration of Landing Zone components            ║
// ║  Principle: Deterministic infrastructure provisioning. Same input,          ║
// ║            same output, every time. No configuration drift.                 ║
// ║  Scaling Algorithm:                                                         ║
// ║    IF deploy_infrastructure                                                 ║
// ║    THEN validate_prerequisites() && deploy_management_groups()             ║
// ║    THEN deploy_policies() && deploy_rbac()                                 ║
// ║    THEN deploy_networking() && verify_compliance()                         ║
// ║  Dependencies: Azure CLI, Bicep CLI, Tenant Admin permissions              ║
// ║  Tests: See tests/unit/test_infrastructure.py                              ║
// ╚═════════════════════════════════════════════════════════════════════════════╝

targetScope = 'tenant'

// ─────────────────────────────────────────────────────────────────────────────
// METADATA
// ─────────────────────────────────────────────────────────────────────────────

metadata {
  description: 'Fox Height LTD — Azure Landing Zone (Layer 0)'
  author: 'Samson Abuya Mobisa'
  company: 'Fox Height LTD'
  headquarters: 'Nairobi, Kenya'
  version: '1.0.0'
  lastUpdated: '2026-06-02'
  compliance: 'Kenya DPA 2019'
}

// ─────────────────────────────────────────────────────────────────────────────
// PARAMETERS
// ─────────────────────────────────────────────────────────────────────────────

@description('Root management group name')
param rootManagementGroupName string = 'foxheight-root'

@description('Organization name for naming conventions')
param organizationName string = 'foxheight'

@description('Environment tag')
param environment string = 'production'

@description('Cost center for billing')
param costCenter string = 'FOX-CC-001'

@description('Azure region for resource deployment')
@allowed([
  'southafricanorth'
  'southafricawest'
])
param primaryRegion string = 'southafricanorth'

@description('Enable Kenya DPA 2019 enforcement')
param enableDpaCompliance bool = true

// ─────────────────────────────────────────────────────────────────────────────
// VARIABLES
// ─────────────────────────────────────────────────────────────────────────────

var timestamp = utcNow('u')
var deploymentId = uniqueString(tenant().tenantId, rootManagementGroupName)
var commonTags = {
  organization: organizationName
  environment: environment
  layer: 'layer-0-infrastructure'
  managed_by: 'bicep'
  deployment_date: timestamp
  cost_center: costCenter
  compliance_framework: 'kenya-dpa-2019'
}

// ─────────────────────────────────────────────────────────────────────────────
// MANAGEMENT GROUPS
// ─────────────────────────────────────────────────────────────────────────────

// Root Management Group — Top of governance hierarchy
resource foxHeightRoot 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: rootManagementGroupName
  properties: {
    displayName: 'Fox Height LTD — Root'
    details: {
      parent: {}  // Tenant root (top level)
    }
  }
}

// Production Management Group — Production workloads
resource productionMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${organizationName}-production'
  properties: {
    displayName: 'Fox Height — Production'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
  dependsOn: [
    foxHeightRoot
  ]
}

// Staging Management Group — Pre-production testing
resource stagingMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${organizationName}-staging'
  properties: {
    displayName: 'Fox Height — Staging'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
  dependsOn: [
    foxHeightRoot
  ]
}

// Development Management Group — Development environments
resource developmentMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${organizationName}-development'
  properties: {
    displayName: 'Fox Height — Development'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
  dependsOn: [
    foxHeightRoot
  ]
}

// Clients Management Group — Client-specific environments
resource clientsMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${organizationName}-clients'
  properties: {
    displayName: 'Fox Height — Client Environments'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
  dependsOn: [
    foxHeightRoot
  ]
}

// Governance Management Group — Shared governance services
resource governanceMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${organizationName}-governance'
  properties: {
    displayName: 'Fox Height — Governance'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
  dependsOn: [
    foxHeightRoot
  ]
}

// ─────────────────────────────────────────────────────────────────────────────
// OUTPUTS
// ─────────────────────────────────────────────────────────────────────────────

@description('Root management group resource ID')
output rootManagementGroupId string = foxHeightRoot.id

@description('Root management group name')
output rootManagementGroupName string = foxHeightRoot.name

@description('Production management group ID')
output productionManagementGroupId string = productionMg.id

@description('Staging management group ID')
output stagingManagementGroupId string = stagingMg.id

@description('Development management group ID')
output developmentManagementGroupId string = developmentMg.id

@description('Clients management group ID')
output clientsManagementGroupId string = clientsMg.id

@description('Governance management group ID')
output governanceManagementGroupId string = governanceMg.id

@description('Deployment timestamp')
output deploymentTimestamp string = timestamp

@description('Common tags applied to all resources')
output commonTags object = commonTags
