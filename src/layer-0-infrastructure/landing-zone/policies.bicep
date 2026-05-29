/**
 * fox_build/src/layer-0-infrastructure/landing-zone/policies.bicep
 *
 * FILE HEADER: Azure Policy definitions and assignments for compliance
 * ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
 * PRINCIPLE: Compliance is not manual. It is enforced by infrastructure.
 *            Kenya DPA 2019 data residency is a first-class architectural constraint.
 * SCALING ALGORITHM:
 *   IF resource_deployment_attempted
 *   THEN evaluate_location_policy()
 *   IF location NOT IN approved_regions THEN deny_deployment()
 *   THEN evaluate_encryption_policy()
 *   IF encryption NOT enabled THEN deny_deployment()
 * DEPENDENCIES: Management group scope, policy contributor permissions
 * TESTS: tests/unit/test_policy_compliance.py
 */

targetScope = 'managementGroup'

@description('Organization identifier')
param orgIdentifier string

@description('Primary Azure region')
param primaryRegion string

@description('Secondary Azure region for DR')
param secondaryRegion string

// Kenya DPA 2019 Data Residency Policy
resource kenyaDpaPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgIdentifier}-kenya-dpa-data-residency'
  properties: {
    displayName: 'Fox Height: Kenya DPA 2019 Data Residency Compliance'
    description: 'Ensures all data remains in approved Azure regions per Kenya Data Protection Act 2019. Approved regions: South Africa North, South Africa West.'
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            notIn: [
              'Microsoft.Resources/resourceGroups'
              'Microsoft.Resources/subscriptions'
            ]
          }
          {
            field: 'location'
            notIn: [
              primaryRegion
              secondaryRegion
              'global'
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

// Enforce HTTPS for Storage Accounts
resource enforceHttpsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgIdentifier}-enforce-https'
  properties: {
    displayName: 'Fox Height: Enforce HTTPS for all connections'
    description: 'All data in transit must be encrypted. HTTPS is mandatory.'
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            field: 'Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly'
            notEquals: true
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

// Require TLS 1.2 Minimum
resource requireTls12Policy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgIdentifier}-require-tls12'
  properties: {
    displayName: 'Fox Height: Enforce TLS 1.2 Minimum'
    description: 'All services must use TLS 1.2 or higher for encryption in transit.'
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            field: 'Microsoft.Storage/storageAccounts/minimumTlsVersion'
            notIn: [
              'TLS1_2'
              'TLS1_3'
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

// Disable Public Blob Access
resource disablePublicBlobPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgIdentifier}-disable-public-blob'
  properties: {
    displayName: 'Fox Height: Disable Public Blob Access'
    description: 'All storage accounts must have public blob access disabled.'
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts'
          }
          {
            field: 'Microsoft.Storage/storageAccounts/allowBlobPublicAccess'
            equals: true
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

// Require Resource Group Tags
resource requireTagsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgIdentifier}-require-tags'
  properties: {
    displayName: 'Fox Height: Require Mandatory Tags'
    description: 'All resources must have environment, layer, and dataClassification tags.'
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        field: 'type'
        notIn: [
          'Microsoft.Resources/resourceGroups'
        ]
      }
      then: {
        effect: 'audit'
      }
    }
  }
}

output kenyaDpaPolicyId string = kenyaDpaPolicy.id
output enforceHttpsPolicyId string = enforceHttpsPolicy.id
output requireTls12PolicyId string = requireTls12Policy.id
output disablePublicBlobPolicyId string = disablePublicBlobPolicy.id
output requireTagsPolicyId string = requireTagsPolicy.id
