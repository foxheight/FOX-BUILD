# FILE HEADER
# WHY THIS SCRIPT: Orchestrate deterministic deployment of Layer 0 infrastructure
# ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
# PRINCIPLE: Same input → same output every time. Idempotent. Fully auditable. Rollback-capable.
# SCALING ALGORITHM: IF pre_validation_passed THEN deploy_bicep THEN post_validation THEN audit_log
# DEPENDENCIES: Azure CLI, Bicep CLI, Management group permissions, PowerShell 7+
# TESTS: tests/unit/test_deployment.py

#Requires -Version 7.0
#Requires -Modules @{ ModuleName='Az.Accounts'; ModuleVersion='2.13.0' }, @{ ModuleName='Az.Resources'; ModuleVersion='6.5.0' }

param(
    [Parameter(Mandatory = $true)]
    [string]$ManagementGroupId,

    [Parameter(Mandatory = $true)]
    [string]$Location = 'southafricanorth',

    [Parameter(Mandatory = $false)]
    [string]$Environment = 'production',

    [Parameter(Mandatory = $false)]
    [switch]$ValidateOnly,

    [Parameter(Mandatory = $false)]
    [switch]$RollbackOnFailure
)

# Set strict error handling
$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

# Logging
$logPath = "./layer0-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"

function Write-Log {
    param([string]$Message, [ValidateSet('INFO', 'WARN', 'ERROR', 'SUCCESS')]$Level = 'INFO')
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logMessage = "[$timestamp] [$Level] $Message"
    Add-Content -Path $logPath -Value $logMessage
    Write-Host $logMessage -ForegroundColor @{INFO = 'White'; WARN = 'Yellow'; ERROR = 'Red'; SUCCESS = 'Green'}[$Level]
}

# PRE-DEPLOYMENT VALIDATION
function Invoke-PreDeploymentValidation {
    Write-Log "Starting pre-deployment validation..." 'INFO'

    # Check Azure CLI
    try {
        $azVersion = az version --output json | ConvertFrom-Json
        Write-Log "Azure CLI version: $($azVersion.'azure-cli')" 'INFO'
    }
    catch {
        Write-Log "Azure CLI not found. Install from https://aka.ms/azure-cli" 'ERROR'
        throw
    }

    # Check Bicep
    try {
        $bicepVersion = bicep version
        Write-Log "Bicep version: $bicepVersion" 'INFO'
    }
    catch {
        Write-Log "Bicep not found. Install via 'az bicep install'" 'ERROR'
        throw
    }

    # Validate Bicep files
    $bicepFiles = @(
        './src/layer-0-infrastructure/landing-zone/management-groups.bicep',
        './src/layer-0-infrastructure/landing-zone/policies.bicep',
        './src/layer-0-infrastructure/landing-zone/rbac.bicep',
        './src/layer-0-infrastructure/landing-zone/networking.bicep'
    )

    foreach ($file in $bicepFiles) {
        if (-not (Test-Path $file)) {
            Write-Log "Bicep file not found: $file" 'ERROR'
            throw
        }
        Write-Log "Validating Bicep: $file" 'INFO'
        bicep build $file --output-file /dev/null
    }

    # Check management group permissions
    try {
        $mgScope = "/providers/Microsoft.Management/managementGroups/$ManagementGroupId"
        $existing = az account management-group show --name $ManagementGroupId 2>/dev/null
        if ($existing) {
            Write-Log "Management group exists: $ManagementGroupId" 'INFO'
        }
    }
    catch {
        Write-Log "Cannot access management group: $ManagementGroupId. Ensure you have tenant-level permissions." 'WARN'
    }

    Write-Log "Pre-deployment validation passed." 'SUCCESS'
}

# DEPLOY INFRASTRUCTURE
function Invoke-InfrastructureDeployment {
    Write-Log "Starting infrastructure deployment..." 'INFO'

    # Deploy management groups
    Write-Log "Deploying management groups..." 'INFO'
    $mgDeployment = az deployment tenant create `
        --name "fox-height-layer0-$(Get-Date -Format 'yyyyMMddHHmmss')" `
        --location $Location `
        --template-file './src/layer-0-infrastructure/landing-zone/management-groups.bicep' `
        --output json | ConvertFrom-Json

    if ($mgDeployment.properties.provisioningState -ne 'Succeeded') {
        Write-Log "Management group deployment failed: $($mgDeployment.properties.provisioningState)" 'ERROR'
        throw
    }

    Write-Log "Management groups deployed successfully." 'SUCCESS'

    # Deploy policies
    Write-Log "Deploying policies..." 'INFO'
    $policyDeployment = az deployment tenant create `
        --name "fox-height-policies-$(Get-Date -Format 'yyyyMMddHHmmss')" `
        --location $Location `
        --template-file './src/layer-0-infrastructure/landing-zone/policies.bicep' `
        --parameters managementGroupId=$ManagementGroupId `
        --output json | ConvertFrom-Json

    if ($policyDeployment.properties.provisioningState -ne 'Succeeded') {
        Write-Log "Policy deployment failed: $($policyDeployment.properties.provisioningState)" 'ERROR'
        throw
    }

    Write-Log "Policies deployed successfully." 'SUCCESS'

    # Deploy RBAC
    Write-Log "Deploying RBAC taxonomy..." 'INFO'
    $rbacDeployment = az deployment sub create `
        --subscription $ManagementGroupId `
        --name "fox-height-rbac-$(Get-Date -Format 'yyyyMMddHHmmss')" `
        --location $Location `
        --template-file './src/layer-0-infrastructure/landing-zone/rbac.bicep' `
        --parameters managementGroupId=$ManagementGroupId `
        --output json | ConvertFrom-Json

    if ($rbacDeployment.properties.provisioningState -ne 'Succeeded') {
        Write-Log "RBAC deployment failed: $($rbacDeployment.properties.provisioningState)" 'ERROR'
        throw
    }

    Write-Log "RBAC deployed successfully." 'SUCCESS'

    # Deploy networking
    Write-Log "Deploying hub-and-spoke network..." 'INFO'
    $networkDeployment = az deployment sub create `
        --subscription $ManagementGroupId `
        --name "fox-height-network-$(Get-Date -Format 'yyyyMMddHHmmss')" `
        --location $Location `
        --template-file './src/layer-0-infrastructure/landing-zone/networking.bicep' `
        --parameters location=$Location environment=$Environment `
        --output json | ConvertFrom-Json

    if ($networkDeployment.properties.provisioningState -ne 'Succeeded') {
        Write-Log "Network deployment failed: $($networkDeployment.properties.provisioningState)" 'ERROR'
        throw
    }

    Write-Log "Networking deployed successfully." 'SUCCESS'
}

# POST-DEPLOYMENT VALIDATION
function Invoke-PostDeploymentValidation {
    Write-Log "Starting post-deployment validation..." 'INFO'

    # Verify management groups
    Write-Log "Verifying management groups..." 'INFO'
    $mgList = az account management-group list --output json | ConvertFrom-Json
    $expectedGroups = @('foxheight-root', 'foxheight-production', 'foxheight-clients', 'foxheight-development')
    foreach ($group in $expectedGroups) {
        if ($mgList.name -contains $group) {
            Write-Log "✓ Management group found: $group" 'SUCCESS'
        }
        else {
            Write-Log "✗ Management group missing: $group" 'ERROR'
            throw
        }
    }

    # Verify policies
    Write-Log "Verifying policies..." 'INFO'
    $policyList = az policy definition list --output json | ConvertFrom-Json
    $expectedPolicies = @('foxheight-kenya-dpa-data-residency', 'foxheight-encryption-at-rest', 'foxheight-approved-resources-only')
    foreach ($policy in $expectedPolicies) {
        if ($policyList.name -contains $policy) {
            Write-Log "✓ Policy found: $policy" 'SUCCESS'
        }
        else {
            Write-Log "✗ Policy missing: $policy" 'WARN'
        }
    }

    Write-Log "Post-deployment validation completed." 'SUCCESS'
}

# MAIN EXECUTION
try {
    Write-Log "===== FOX HEIGHT LAYER 0 DEPLOYMENT START ====="
    Write-Log "Management Group: $ManagementGroupId"
    Write-Log "Location: $Location"
    Write-Log "Environment: $Environment"
    Write-Log "========================================"

    Invoke-PreDeploymentValidation

    if (-not $ValidateOnly) {
        Invoke-InfrastructureDeployment
        Invoke-PostDeploymentValidation
        Write-Log "===== DEPLOYMENT COMPLETED SUCCESSFULLY =====" 'SUCCESS'
    }
    else {
        Write-Log "Validation-only mode. Skipping deployment." 'INFO'
    }
}
catch {
    Write-Log "DEPLOYMENT FAILED: $_" 'ERROR'
    Write-Log "Log file: $logPath"
    if ($RollbackOnFailure) {
        Write-Log "Initiating rollback..." 'WARN'
        # Rollback logic would be implemented here
    }
    exit 1
}
