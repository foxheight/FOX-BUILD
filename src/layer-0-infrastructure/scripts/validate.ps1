<#
.SYNOPSIS
Validate Fox Height infrastructure deployment

.DESCRIPTION
Verifies that all Layer 0 components are deployed correctly and compliant.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [string]$OrgIdentifier = 'foxheight'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Result {
    param([string]$Test, [bool]$Passed, [string]$Message)
    $status = if ($Passed) { '✓ PASS' } else { '✗ FAIL' }
    Write-Host "[$status] $Test: $Message"
}

$context = Get-AzContext
if ($context.Subscription.Id -ne $SubscriptionId) {
    Set-AzContext -SubscriptionId $SubscriptionId
}

Write-Host "Validating Fox Height Infrastructure"
Write-Host "Subscription: $SubscriptionId"
Write-Host ""

# Test 1: Management Groups exist
Write-Host "Checking Management Groups..."
try {
    $mgRoot = Get-AzManagementGroup -GroupId "$OrgIdentifier-root" -ErrorAction SilentlyContinue
    Write-Result "Root Management Group" ($null -ne $mgRoot) "Found: $($mgRoot.DisplayName)"
    
    $mgProd = Get-AzManagementGroup -GroupId "$OrgIdentifier-production" -ErrorAction SilentlyContinue
    Write-Result "Production Management Group" ($null -ne $mgProd) "Found: $($mgProd.DisplayName)"
    
    $mgClients = Get-AzManagementGroup -GroupId "$OrgIdentifier-clients" -ErrorAction SilentlyContinue
    Write-Result "Clients Management Group" ($null -ne $mgClients) "Found: $($mgClients.DisplayName)"
}
catch {
    Write-Result "Management Groups" $false $_.Exception.Message
}

Write-Host ""

# Test 2: Resource Groups exist
Write-Host "Checking Resource Groups..."
try {
    $rgCore = Get-AzResourceGroup -Name "$OrgIdentifier-core-prod" -ErrorAction SilentlyContinue
    Write-Result "Core Resource Group" ($null -ne $rgCore) "Location: $($rgCore.Location)"
    
    $rgNetwork = Get-AzResourceGroup -Name "$OrgIdentifier-network-prod" -ErrorAction SilentlyContinue
    Write-Result "Network Resource Group" ($null -ne $rgNetwork) "Location: $($rgNetwork.Location)"
}
catch {
    Write-Result "Resource Groups" $false $_.Exception.Message
}

Write-Host ""

# Test 3: Key Vault
Write-Host "Checking Key Vault..."
try {
    $kvs = Get-AzKeyVault -ResourceGroupName "$OrgIdentifier-core-prod" -ErrorAction SilentlyContinue
    $kvExists = $null -ne $kvs
    Write-Result "Key Vault" $kvExists "Found $(if($kvExists) { $kvs.Count } else { 0 }) vault(s)"
}
catch {
    Write-Result "Key Vault" $false $_.Exception.Message
}

Write-Host ""

# Test 4: Storage Account (state)
Write-Host "Checking Storage Accounts..."
try {
    $storageAccounts = Get-AzStorageAccount -ResourceGroupName "$OrgIdentifier-core-prod" -ErrorAction SilentlyContinue
    Write-Result "State Storage Account" ($null -ne $storageAccounts) "Found $(if($null -ne $storageAccounts) { $storageAccounts.Count } else { 0 }) account(s)"
    
    foreach ($storage in $storageAccounts) {
        $httpsOnly = $storage.HttpsTrafficOnlyEnabled
        $tlsVersion = $storage.MinimumTlsVersion
        Write-Result "  HTTPS Only: $($storage.StorageAccountName)" $httpsOnly "TLS Version: $tlsVersion"
    }
}
catch {
    Write-Result "Storage Accounts" $false $_.Exception.Message
}

Write-Host ""

# Test 5: Virtual Network
Write-Host "Checking Networking..."
try {
    $vnets = Get-AzVirtualNetwork -ResourceGroupName "$OrgIdentifier-network-prod" -ErrorAction SilentlyContinue
    Write-Result "Virtual Networks" ($null -ne $vnets) "Found $(if($null -ne $vnets) { $vnets.Count } else { 0 }) VNet(s)"
    
    foreach ($vnet in $vnets) {
        Write-Result "  Subnets: $($vnet.Name)" ($vnet.Subnets.Count -gt 0) "$($vnet.Subnets.Count) subnet(s)"
    }
}
catch {
    Write-Result "Networking" $false $_.Exception.Message
}

Write-Host ""

# Test 6: Policy Compliance
Write-Host "Checking Policy Compliance..."
try {
    $nonCompliant = Get-AzPolicyState -ResourceGroupName "$OrgIdentifier-core-prod" -ErrorAction SilentlyContinue | Where-Object {$_.ComplianceState -eq 'NonCompliant'}
    $compliant = $null -eq $nonCompliant -or $nonCompliant.Count -eq 0
    Write-Result "Policy Compliance" $compliant "Non-compliant resources: $(if($compliant) { 0 } else { $nonCompliant.Count })"
}
catch {
    Write-Result "Policy Compliance" $false $_.Exception.Message
}

Write-Host ""
Write-Host "Validation completed."
