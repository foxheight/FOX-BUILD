// FILE HEADER
// WHY THIS FILE: Defines the organisational governance tree. All subscriptions attach to management groups.
// Policies applied at the management group cascade to all children.
// ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
// PRINCIPLE: Deterministic infrastructure provisioning. Same input, same output, every time.
// SCALING ALGORITHM: IF new_subscription → THEN attach_to_management_group → THEN apply_inherited_policies
// DEPENDENCIES: Azure Tenant permissions to create management groups
// TESTS: tests/unit/test_management_groups.py

targetScope = 'tenant'

// Root management group
resource foxHeightRoot 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'foxheight-root'
  properties: {
    displayName: 'Fox Height LTD — Root'
  }
}

// Production environment
resource productionGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'foxheight-production'
  properties: {
    displayName: 'Fox Height — Production'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
}

// Client environments
resource clientsGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'foxheight-clients'
  properties: {
    displayName: 'Fox Height — Client Environments'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
}

// Development/staging
resource devGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'foxheight-development'
  properties: {
    displayName: 'Fox Height — Development/Staging'
    details: {
      parent: {
        id: foxHeightRoot.id
      }
    }
  }
}

output rootId string = foxHeightRoot.id
output productionId string = productionGroup.id
output clientsId string = clientsGroup.id
output developmentId string = devGroup.id
