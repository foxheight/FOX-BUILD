// FILE HEADER
// WHY THIS FILE: Implement hub-and-spoke network topology with Zero Trust default-deny security
// ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate + Layer 1 Zero Trust Security
// PRINCIPLE: Zero Trust networking. Default-deny all traffic. Explicit allow rules only.
// SCALING ALGORITHM: IF new_workload → THEN attach_to_spoke_vnet → THEN route_through_hub → THEN apply_firewall_rules
// DEPENDENCIES: Resource groups, management groups, RBAC defined
// TESTS: tests/unit/test_networking.py, tests/security/test_zero_trust_posture.py

targetScope = 'subscription'

param location string = 'southafricanorth'
param environment string = 'production'

// Hub Virtual Network
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'vnet-fox-height-hub-${environment}'
  location: location
  tags: {
    Environment: environment
    Layer: 'Layer-0'
    Compliance: 'Kenya-DPA-2019'
  }
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
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'FirewallSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'BastionSubnet'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
}

// Default-Deny Network Security Group
resource defaultDenyNsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'nsg-default-deny-${environment}'
  location: location
  tags: {
    Environment: environment
    Layer: 'Layer-0'
    Compliance: 'Zero-Trust'
  }
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
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowInternalCommunication'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.0.0/8'
          destinationAddressPrefix: '10.0.0.0/8'
          access: 'Allow'
          priority: 200
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Spoke Virtual Network for Production Workloads
resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'vnet-fox-height-spoke-prod-${environment}'
  location: location
  tags: {
    Environment: environment
    Layer: 'Layer-0'
    Compliance: 'Kenya-DPA-2019'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'ComputeSubnet'
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: {
            id: defaultDenyNsg.id
          }
        }
      }
      {
        name: 'DataSubnet'
        properties: {
          addressPrefix: '10.1.2.0/24'
          networkSecurityGroup: {
            id: defaultDenyNsg.id
          }
        }
      }
    ]
  }
}

// Hub to Spoke Peering
resource hubToSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  parent: hubVnet
  name: 'peering-hub-to-spoke'
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
  }
}

// Spoke to Hub Peering
resource spokeToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  parent: spokeVnet
  name: 'peering-spoke-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
  }
}

output hubVnetId string = hubVnet.id
output spokeVnetId string = spokeVnet.id
output nsgId string = defaultDenyNsg.id
