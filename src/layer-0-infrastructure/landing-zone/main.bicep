/**
 * fox_build/src/layer-0-infrastructure/landing-zone/main.bicep
 *
 * FILE HEADER: Master orchestration template for Fox Height's Azure Landing Zone
 * ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
 * PRINCIPLE: Deterministic infrastructure provisioning. Same input, same output, every time.
 *            No configuration drift. No snowflake servers.
 * SCALING ALGORITHM:
 *   IF deployment_requested
 *   THEN deploy_management_groups()
 *   THEN assign_root_policies()
 *   THEN deploy_network_topology()
 *   THEN assign_rbac_taxonomy()
 *   THEN enable_monitoring()
 * DEPENDENCIES: Azure subscription, Microsoft Entra ID tenant, appropriate RBAC roles
 * TESTS: tests/unit/test_infrastructure_deployment.py
 */

targetScope = 'subscription'

@description('Environment identifier (dev, stage, prod)')
param environment string = 'prod'

@description('Azure region for primary resources')
param primaryRegion string = 'southafricanorth'

@description('Azure region for secondary resources (DR)')
param secondaryRegion string = 'southafricawest'

@description('Organization identifier')
param orgIdentifier string = 'foxheight'

// Management Groups Module
module managementGroups './management-groups.bicep' = {
  scope: tenant()
  name: 'deploy-management-groups'
  params: {
    orgIdentifier: orgIdentifier
    environment: environment
  }
}

// Policies Module
module policies './policies.bicep' = {
  scope: managementGroup('${orgIdentifier}-root')
  name: 'deploy-policies'
  params: {
    orgIdentifier: orgIdentifier
    primaryRegion: primaryRegion
    secondaryRegion: secondaryRegion
  }
  dependsOn: [
    managementGroups
  ]
}

// Resource Group for core infrastructure
resource foxHeightCoreRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${orgIdentifier}-core-${environment}'
  location: primaryRegion
  tags: {
    environment: environment
    layer: 'layer-0'
    component: 'sovereign-infrastructure'
    dataClassification: 'internal'
  }
}

// Resource Group for networking
resource foxHeightNetworkRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${orgIdentifier}-network-${environment}'
  location: primaryRegion
  tags: {
    environment: environment
    layer: 'layer-0'
    component: 'network-topology'
  }
}

// Storage Account for state and artifacts (encrypted)
resource stateStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'fh${orgIdentifier}state${uniqueString(subscription().id)}'
  location: primaryRegion
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
  }
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Disabled'
    encryption: {
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
  parent: foxHeightCoreRg
  tags: {
    purpose: 'state-and-artifacts'
    encryption: 'enabled'
    dpaCompliant: 'true'
  }
}

// Key Vault for secrets management
resource foxHeightKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: '${orgIdentifier}-kv-${uniqueString(subscription().id)}'
  location: primaryRegion
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
  parent: foxHeightCoreRg
  tags: {
    purpose: 'secrets-management'
    compliance: 'dpa-2019'
  }
}

// Virtual Network (Hub-and-Spoke topology)
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: '${orgIdentifier}-hub-vnet-${environment}'
  location: primaryRegion
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'BastionSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'ManagementSubnet'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
  parent: foxHeightNetworkRg
  tags: {
    topology: 'hub-and-spoke'
    security: 'zero-trust'
  }
}

// Network Security Group for management subnet
resource managementNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${orgIdentifier}-mgmt-nsg-${environment}'
  location: primaryRegion
  properties: {
    securityRules: [
      {
        name: 'DenyAllInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowVnetInbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
  parent: foxHeightNetworkRg
}

// Application Insights for centralized monitoring
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${orgIdentifier}-appinsights-${environment}'
  location: primaryRegion
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
  }
  parent: foxHeightCoreRg
  tags: {
    purpose: 'centralized-monitoring'
    layer: 'observability'
  }
}

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${orgIdentifier}-law-${environment}'
  location: primaryRegion
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
  }
  parent: foxHeightCoreRg
  tags: {
    purpose: 'centralized-logging'
    compliance: 'audit-trail'
  }
}

output managementGroupId string = managementGroups.outputs.rootManagementGroupId
output coreResourceGroupId string = foxHeightCoreRg.id
output networkResourceGroupId string = foxHeightNetworkRg.id
output keyVaultId string = foxHeightKeyVault.id
output stateStorageId string = stateStorage.id
output hubVnetId string = hubVnet.id
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
