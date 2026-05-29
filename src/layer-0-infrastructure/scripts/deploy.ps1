<#
.SYNOPSIS
Deploy Fox Height's Azure Landing Zone infrastructure

.DESCRIPTION
This script deploys the complete Layer 0 sovereign infrastructure substrate,
including management groups, policies, networking, and monitoring.

.PARAMETER Environment
Deployment environment (dev, stage, prod)

.PARAMETER SubscriptionId
Target Azure subscription ID

.PARAMETER TenantId
Azure AD tenant ID

.EXAMPLE
.\deploy.ps1 -Environment prod -SubscriptionId "00000000-0000-0000-0000-000000000000"
#>

param(
    [ValidateSet('dev', 'stage', 'prod')]
    [string]$Environment = 'prod',
    
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory=$true)]
    [string]$TenantId,
    
    [string]$PrimaryRegion = 'southafricanorth',
    [string]$SecondaryRegion = 'southafricawest',
    [string]$OrgIdentifier = 'foxheight'
)

# Enable strict mode
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Logging function
function Write-Log {
    param([string]$Message, [ValidateSet('Info', 'Warning', 'Error')]$Level = 'Info')
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] [$Level] $Message"
}

try {
    Write-Log "Starting Fox Height Infrastructure Deployment"
    Write-Log "Environment: $Environment"
    Write-Log "Subscription: $SubscriptionId"
    Write-Log "Primary Region: $PrimaryRegion"
    
    # Authenticate to Azure
    Write-Log "Authenticating to Azure"
    $null = Connect-AzAccount -TenantId $TenantId -SubscriptionId $SubscriptionId
    
    # Verify context
    $context = Get-AzContext
    Write-Log "Connected to subscription: $($context.Subscription.Name)"
    
    # Deploy management groups
    Write-Log "Deploying management group hierarchy"
    $mgDeployment = New-AzTenantDeployment `
        -Location $PrimaryRegion `
        -TemplateFile './management-groups.bicep' `
        -TemplateParameterObject @{
            orgIdentifier = $OrgIdentifier
            environment = $Environment
        } `
        -Name "deploy-mg-$([guid]::NewGuid().ToString().Substring(0,8))"
    
    if ($mgDeployment.ProvisioningState -ne 'Succeeded') {
        throw "Management group deployment failed: $($mgDeployment.ProvisioningState)"
    }
    Write-Log "Management groups deployed successfully"
    
    # Deploy policies at root management group
    Write-Log "Deploying Azure Policy definitions"
    $policyDeployment = New-AzManagementGroupDeployment `
        -ManagementGroupId "$OrgIdentifier-root" `
        -Location $PrimaryRegion `
        -TemplateFile './policies.bicep' `
        -TemplateParameterObject @{
            orgIdentifier = $OrgIdentifier
            primaryRegion = $PrimaryRegion
            secondaryRegion = $SecondaryRegion
        } `
        -Name "deploy-policies-$([guid]::NewGuid().ToString().Substring(0,8))"
    
    if ($policyDeployment.ProvisioningState -ne 'Succeeded') {
        throw "Policy deployment failed: $($policyDeployment.ProvisioningState)"
    }
    Write-Log "Policies deployed successfully"
    
    # Deploy core infrastructure to subscription
    Write-Log "Deploying core infrastructure resources"
    $infraDeployment = New-AzSubscriptionDeployment `
        -Location $PrimaryRegion `
        -TemplateFile './main.bicep' `
        -TemplateParameterObject @{
            environment = $Environment
            primaryRegion = $PrimaryRegion
            secondaryRegion = $SecondaryRegion
            orgIdentifier = $OrgIdentifier
        } `
        -Name "deploy-infra-$([guid]::NewGuid().ToString().Substring(0,8))"
    
    if ($infraDeployment.ProvisioningState -ne 'Succeeded') {
        throw "Infrastructure deployment failed: $($infraDeployment.ProvisioningState)"
    }
    Write-Log "Infrastructure deployed successfully"
    
    # Output deployment summary
    Write-Log "=== Deployment Summary ==="
    Write-Log "Management Group ID: $($mgDeployment.Outputs.rootManagementGroupId.Value)"
    Write-Log "Core RG ID: $($infraDeployment.Outputs.coreResourceGroupId.Value)"
    Write-Log "Network RG ID: $($infraDeployment.Outputs.networkResourceGroupId.Value)"
    Write-Log "Key Vault ID: $($infraDeployment.Outputs.keyVaultId.Value)"
    Write-Log "Hub VNet ID: $($infraDeployment.Outputs.hubVnetId.Value)"
    
    Write-Log "Deployment completed successfully"
    exit 0
}
catch {
    Write-Log $_.Exception.Message 'Error'
    Write-Log $_.ScriptStackTrace 'Error'
    exit 1
}
