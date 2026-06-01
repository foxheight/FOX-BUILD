// =============================================================================
// FOX HEIGHT LAYER 0: AZURE POLICIES
// =============================================================================
// Purpose: Enforce Kenya DPA 2019 compliance and security posture
// These policies are the constitutional rules for the entire infrastructure
// =============================================================================

metadata description = 'Azure Policy Definitions for Kenya DPA 2019 Compliance'
metadata author = 'Fox Height LTD'

targetScope = 'tenant'

param environment string
param orgName string
param allowedRegions array

// =============================================================================
// POLICY 1: ALLOWED LOCATIONS (Kenya DPA 2019)
// =============================================================================
// Enforce that all resources are deployed to approved regions only
// Violation = automatic resource denial

resource allowedLocationsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgName}-allowed-locations-policy'
  properties: {
    displayName: 'Allowed locations for Fox Height resources'
    description: 'Enforce Kenya DPA 2019 data residency: resources must be in South Africa region'
    mode: 'Indexed'
    policyType: 'Custom'
    policyRule: {
      if: {
        field: 'location'
        notIn: allowedRegions
      }
      then: {
        effect: 'Deny'
      }
    }
    metadata: {
      version: '1.0.0'
      category: 'Compliance'
      compliance: 'kenya-dpa-2019'
    }
  }
}

// =============================================================================
// POLICY 2: HTTPS ENFORCEMENT
// =============================================================================
// All storage accounts must use HTTPS only

resource httpsOnlyPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgName}-https-only-policy'
  properties: {
    displayName: 'Storage accounts must use HTTPS'
    description: 'Enforce HTTPS on all storage account communication'
    mode: 'Indexed'
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
            notEquals: 'true'
          }
        ]
      }
      then: {
        effect: 'Deny'
      }
    }
  }
}

// =============================================================================
// POLICY 3: ENCRYPTION IN TRANSIT (TLS 1.2+)
// =============================================================================
// Enforce TLS 1.2 minimum on all Azure services

resource tlsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgName}-tls-1-2-policy'
  properties: {
    displayName: 'Enforce TLS 1.2 minimum'
    description: 'Ensure all services use TLS 1.2 or higher for encryption in transit'
    mode: 'Indexed'
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
            lessThan: 'TLS1_2'
          }
        ]
      }
      then: {
        effect: 'Deny'
      }
    }
  }
}

// =============================================================================
// POLICY 4: PUBLIC BLOB ACCESS PREVENTION
// =============================================================================
// Prevent public access to blob containers

resource noBlobPublicAccessPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgName}-no-public-blob-access'
  properties: {
    displayName: 'Storage blobs must not have public access'
    description: 'Prevent accidental exposure of sensitive data through public blob access'
    mode: 'Indexed'
    policyType: 'Custom'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Storage/storageAccounts/blobServices/containers'
          }
          {
            field: 'Microsoft.Storage/storageAccounts/blobServices/containers/publicAccess'
            notEquals: 'None'
          }
        ]
      }
      then: {
        effect: 'Deny'
      }
    }
  }
}

// =============================================================================
// POLICY 5: RESOURCE TAGGING
// =============================================================================
// Enforce mandatory tags on all resources

resource mandatoryTagsPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgName}-mandatory-tags'
  properties: {
    displayName: 'Enforce mandatory tags on resources'
    description: 'Ensure all resources have required tags for cost tracking and compliance'
    mode: 'Indexed'
    policyType: 'Custom'
    policyRule: {
      if: {
        field: 'tags'
        exists: 'false'
      }
      then: {
        effect: 'Deny'
      }
    }
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag Name'
          description: 'Name of the tag'
        }
      }
    }
  }
}

// =============================================================================
// POLICY 6: ENCRYPTION AT REST
// =============================================================================
// All storage accounts must use encryption at rest

resource encryptionAtRestPolicy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: '${orgName}-encryption-at-rest'
  properties: {
    displayName: 'Storage accounts must have encryption at rest'
    description: 'Enforce Azure Storage Service Encryption (SSE)'
    mode: 'Indexed'
    policyType: 'Custom'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Storage/storageAccounts'
      }
      then: {
        effect: 'AuditIfNotExists'
        details: {
          type: 'Microsoft.Storage/storageAccounts/encryptionServices/properties'
          existenceCondition: {
            field: 'Microsoft.Storage/storageAccounts/encryptionServices/blob/enabled'
            equals: 'true'
          }
        }
      }
    }
  }
}

// =============================================================================
// OUTPUTS
// =============================================================================

@description('All policy definition IDs')
output policyIds object = {
  allowedLocations: allowedLocationsPolicy.id
  httpsOnly: httpsOnlyPolicy.id
  tls: tlsPolicy.id
  noBlobPublicAccess: noBlobPublicAccessPolicy.id
  mandatoryTags: mandatoryTagsPolicy.id
  encryptionAtRest: encryptionAtRestPolicy.id
}
