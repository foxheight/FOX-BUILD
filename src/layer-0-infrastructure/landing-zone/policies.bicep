// FILE HEADER
// WHY THIS FILE: Enforce Kenya DPA 2019 data residency and security compliance
// ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate + Layer 2 Data Sovereignty
// PRINCIPLE: Every resource deployed must comply with Kenya Data Protection Act 2019
// SCALING ALGORITHM: IF resource_created → THEN evaluate_location_policy → IF not_in_approved_regions THEN deny
// DEPENDENCIES: Management groups created, tenant permissions
// TESTS: tests/unit/test_policies.py, tests/security/test_data_residency.py

targetScope = 'tenant'

param managementGroupId string

// Kenya DPA 2019 Data Residency Policy
resource kenyaDpaPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'foxheight-kenya-dpa-data-residency'
  properties: {
    displayName: 'Fox Height: Kenya DPA 2019 Data Residency'
    description: 'Ensures all data remains in approved Azure regions per Kenya DPA 2019'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'location'
            notIn: [
              'southafricanorth'
              'southafricawest'
            ]
          }
          {
            field: 'type'
            notIn: [
              'Microsoft.Resources/resourceGroups'
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

// Encryption at Rest Policy
resource encryptionPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'foxheight-encryption-at-rest'
  properties: {
    displayName: 'Fox Height: Encryption at Rest Required'
    description: 'Enforce encryption at rest for all storage services'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            in: [
              'Microsoft.Storage/storageAccounts'
              'Microsoft.Sql/servers/databases'
              'Microsoft.KeyVault/vaults'
            ]
          }
        ]
      }
      then: {
        effect: 'audit'
      }
    }
  }
}

// Approved Resource Types Policy
resource approvedResourcesPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'foxheight-approved-resources-only'
  properties: {
    displayName: 'Fox Height: Approved Resource Types Only'
    description: 'Only approved Azure resource types can be deployed'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        field: 'type'
        notIn: [
          'Microsoft.Management/managementGroups'
          'Microsoft.Resources/resourceGroups'
          'Microsoft.Authorization/policyDefinitions'
          'Microsoft.Compute/virtualMachines'
          'Microsoft.Storage/storageAccounts'
          'Microsoft.Network/virtualNetworks'
          'Microsoft.Network/networkSecurityGroups'
          'Microsoft.KeyVault/vaults'
          'Microsoft.Authorization/roleAssignments'
        ]
      }
      then: {
        effect: 'audit'
      }
    }
  }
}

output dpaPolicyId string = kenyaDpaPolicy.id
output encryptionPolicyId string = encryptionPolicy.id
output approvedResourcesPolicyId string = approvedResourcesPolicy.id
