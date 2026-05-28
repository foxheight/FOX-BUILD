// FILE HEADER
// WHY THIS FILE: Define custom RBAC roles implementing Zero Trust least-privilege access
// ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate + Layer 1 Zero Trust Security
// PRINCIPLE: No permanent Global Administrator. All roles time-limited, MFA-required, auditable.
// SCALING ALGORITHM: IF user_requests_access → THEN check_role_constraints → IF valid THEN grant_time_limited_access
// DEPENDENCIES: Management groups created, Azure RBAC tenant permissions
// TESTS: tests/unit/test_rbac.py, tests/security/test_zero_trust_posture.py

targetScope = 'tenant'

param managementGroupId string

// Fox Height Infrastructure Administrator
resource infraAdminRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid('foxheight-infrastructure-admin', resourceGroup().id)
  properties: {
    roleName: 'Fox Height Infrastructure Administrator'
    description: 'Limited administrator role for infrastructure management. Time-limited, MFA-required, auditable.'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Resources/subscriptions/resourceGroups/write'
          'Microsoft.Compute/*/read'
          'Microsoft.Compute/virtualMachines/write'
          'Microsoft.Network/*/read'
          'Microsoft.Network/virtualNetworks/write'
          'Microsoft.Network/networkSecurityGroups/write'
          'Microsoft.Storage/*/read'
          'Microsoft.Storage/storageAccounts/write'
        ]
        notActions: [
          'Microsoft.Authorization/*/delete'
          'Microsoft.Authorization/policyAssignments/delete'
        ]
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

// Fox Height Security Auditor
resource securityAuditorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid('foxheight-security-auditor', resourceGroup().id)
  properties: {
    roleName: 'Fox Height Security Auditor'
    description: 'Read-only audit role for security compliance monitoring. No modification rights.'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          '*/read'
          'Microsoft.Authorization/policyDefinitions/read'
          'Microsoft.Authorization/policyAssignments/read'
          'Microsoft.Security/*/read'
          'Microsoft.SecurityInsights/*/read'
        ]
        notActions: [
          'Microsoft.KeyVault/vaults/secrets/read'
        ]
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

// Fox Height Data Classification Officer
resource dataClassificationRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid('foxheight-data-classification', resourceGroup().id)
  properties: {
    roleName: 'Fox Height Data Classification Officer'
    description: 'Role for managing data classification and DPA 2019 compliance.'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.Purview/*/read'
          'Microsoft.Purview/accounts/write'
          'Microsoft.Authorization/policyDefinitions/read'
          'Microsoft.Resources/subscriptions/resourceGroups/read'
        ]
        notActions: [
          'Microsoft.Purview/accounts/delete'
        ]
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

output infraAdminRoleId string = infraAdminRole.id
output securityAuditorRoleId string = securityAuditorRole.id
output dataClassificationRoleId string = dataClassificationRole.id
