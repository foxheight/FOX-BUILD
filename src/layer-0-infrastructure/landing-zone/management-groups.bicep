/**
 * fox_build/src/layer-0-infrastructure/landing-zone/management-groups.bicep
 *
 * FILE HEADER: Management group hierarchy definition
 * ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
 * PRINCIPLE: Defines the organisational governance tree. All subscriptions attach to
 *            a management group. Policies cascade from parent to all children.
 * SCALING ALGORITHM:
 *   IF governance_structure_needed
 *   THEN create_root_management_group()
 *   THEN create_production_management_group(parent=root)
 *   THEN create_clients_management_group(parent=root)
 *   THEN attach_policies_at_each_level()
 * DEPENDENCIES: Tenant-level permissions (Management Group Contributor)
 * TESTS: tests/unit/test_management_groups.py
 */

targetScope = 'tenant'

@description('Organization identifier')
param orgIdentifier string

@description('Environment')
param environment string

// Root Management Group
resource rootMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${orgIdentifier}-root'
  properties: {
    displayName: 'Fox Height LTD — Root'
    details: {
      parent: null
    }
  }
}

// Production Management Group
resource productionMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${orgIdentifier}-production'
  properties: {
    displayName: 'Fox Height — Production'
    details: {
      parent: {
        id: rootMg.id
      }
    }
  }
}

// Clients Management Group
resource clientsMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${orgIdentifier}-clients'
  properties: {
    displayName: 'Fox Height — Client Environments'
    details: {
      parent: {
        id: rootMg.id
      }
    }
  }
}

// Development Management Group (under production)
resource devMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${orgIdentifier}-dev'
  properties: {
    displayName: 'Fox Height — Development'
    details: {
      parent: {
        id: productionMg.id
      }
    }
  }
}

// Staging Management Group (under production)
resource stagingMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${orgIdentifier}-staging'
  properties: {
    displayName: 'Fox Height — Staging'
    details: {
      parent: {
        id: productionMg.id
      }
    }
  }
}

// Production Workloads Management Group (under production)
resource prodWorkloadsMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: '${orgIdentifier}-prod-workloads'
  properties: {
    displayName: 'Fox Height — Production Workloads'
    details: {
      parent: {
        id: productionMg.id
      }
    }
  }
}

output rootManagementGroupId string = rootMg.id
output productionManagementGroupId string = productionMg.id
output clientsManagementGroupId string = clientsMg.id
output devManagementGroupId string = devMg.id
output stagingManagementGroupId string = stagingMg.id
output prodWorkloadsManagementGroupId string = prodWorkloadsMg.id
