# FILE HEADER
# WHY THIS SCRIPT: Validate Layer 0 infrastructure compliance post-deployment
# ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
# PRINCIPLE: Verify Kenya DPA 2019 compliance, security posture, governance structure
# SCALING ALGORITHM: IF deployment_complete THEN verify_compliance THEN score_resources THEN report_findings
# DEPENDENCIES: Azure CLI, PowerShell 7+, Management group permissions
# TESTS: tests/unit/test_validators.py, tests/integration/test_policy_compliance.py

#Requires -Version 7.0
#Requires -Modules @{ ModuleName='Az.Accounts'; ModuleVersion='2.13.0' }

param(
    [Parameter(Mandatory = $true)]
    [string]$ManagementGroupId,

    [Parameter(Mandatory = $false)]
    [int]$ComplianceThreshold = 90
)

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'

function Write-Log {
    param([string]$Message, [ValidateSet('INFO', 'WARN', 'ERROR', 'SUCCESS', 'CRITICAL')]$Level = 'INFO')
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage -ForegroundColor @{INFO = 'White'; WARN = 'Yellow'; ERROR = 'Red'; SUCCESS = 'Green'; CRITICAL = 'Magenta'}[$Level]
}

# COMPLIANCE SCORING
function Get-ComplianceScore {
    param([hashtable]$Findings)

    $total = 0
    $passed = 0

    foreach ($finding in $Findings.Values) {
        $total++
        if ($finding.Status -eq 'PASS') {
            $passed++
        }
    }

    return if ($total -gt 0) { [math]::Round(($passed / $total) * 100, 2) } else { 0 }
}

# VERIFY MANAGEMENT GROUPS
function Test-ManagementGroupCompliance {
    Write-Log "Verifying management group hierarchy..." 'INFO'
    $findings = @{}

    $mgList = az account management-group list --output json | ConvertFrom-Json

    $expectedGroups = @{
        'foxheight-root'        = $null
        'foxheight-production'  = 'foxheight-root'
        'foxheight-clients'     = 'foxheight-root'
        'foxheight-development' = 'foxheight-root'
    }

    foreach ($group in $expectedGroups.Keys) {
        $found = $mgList | Where-Object { $_.name -eq $group }
        if ($found) {
            $findings[$group] = @{ Status = 'PASS'; Message = "Management group exists: $group" }
            Write-Log "✓ $group exists" 'SUCCESS'
        }
        else {
            $findings[$group] = @{ Status = 'FAIL'; Message = "Management group missing: $group" }
            Write-Log "✗ $group missing" 'ERROR'
        }
    }

    return $findings
}

# VERIFY DATA RESIDENCY POLICY
function Test-DataResidencyCompliance {
    Write-Log "Verifying Kenya DPA 2019 data residency policy..." 'INFO'
    $findings = @{}

    $policies = az policy definition list --output json | ConvertFrom-Json
    $dpaPolicy = $policies | Where-Object { $_.name -eq 'foxheight-kenya-dpa-data-residency' }

    if ($dpaPolicy) {
        $findings['DPA-Policy-Exists'] = @{ Status = 'PASS'; Message = "DPA 2019 policy defined" }
        Write-Log "✓ DPA 2019 policy found" 'SUCCESS'

        # Verify policy effect is 'deny'
        if ($dpaPolicy.properties.policyRule.then.effect -eq 'deny') {
            $findings['DPA-Policy-Effect'] = @{ Status = 'PASS'; Message = "DPA policy has 'deny' effect" }
            Write-Log "✓ Policy effect is 'deny' (enforcing)" 'SUCCESS'
        }
        else {
            $findings['DPA-Policy-Effect'] = @{ Status = 'FAIL'; Message = "DPA policy does not have 'deny' effect" }
            Write-Log "✗ Policy effect is not 'deny'" 'ERROR'
        }

        # Verify approved regions
        $allowedRegions = $dpaPolicy.properties.policyRule.if.allOf[0].notIn
        if ($allowedRegions -contains 'southafricanorth' -or $allowedRegions -contains 'southafricawest') {
            $findings['DPA-Approved-Regions'] = @{ Status = 'PASS'; Message = "Approved regions configured" }
            Write-Log "✓ South Africa regions approved for data residency" 'SUCCESS'
        }
        else {
            $findings['DPA-Approved-Regions'] = @{ Status = 'FAIL'; Message = "Approved regions not properly configured" }
            Write-Log "✗ Approved regions not configured correctly" 'ERROR'
        }
    }
    else {
        $findings['DPA-Policy-Exists'] = @{ Status = 'FAIL'; Message = "DPA 2019 policy not found" }
        Write-Log "✗ DPA 2019 policy not found" 'CRITICAL'
    }

    return $findings
}

# VERIFY ENCRYPTION POLICY
function Test-EncryptionCompliance {
    Write-Log "Verifying encryption at rest policy..." 'INFO'
    $findings = @{}

    $policies = az policy definition list --output json | ConvertFrom-Json
    $encPolicy = $policies | Where-Object { $_.name -eq 'foxheight-encryption-at-rest' }

    if ($encPolicy) {
        $findings['Encryption-Policy'] = @{ Status = 'PASS'; Message = "Encryption policy defined" }
        Write-Log "✓ Encryption policy found" 'SUCCESS'
    }
    else {
        $findings['Encryption-Policy'] = @{ Status = 'FAIL'; Message = "Encryption policy not found" }
        Write-Log "✗ Encryption policy not found" 'WARN'
    }

    return $findings
}

# VERIFY RBAC ROLES
function Test-RBACCompliance {
    Write-Log "Verifying custom RBAC roles..." 'INFO'
    $findings = @{}

    $roles = az role definition list --output json | ConvertFrom-Json

    $expectedRoles = @(
        'Fox Height Infrastructure Administrator',
        'Fox Height Security Auditor',
        'Fox Height Data Classification Officer'
    )

    foreach ($role in $expectedRoles) {
        $found = $roles | Where-Object { $_.roleName -eq $role }
        if ($found) {
            $findings["Role-$role"] = @{ Status = 'PASS'; Message = "Custom role exists: $role" }
            Write-Log "✓ Role found: $role" 'SUCCESS'
        }
        else {
            $findings["Role-$role"] = @{ Status = 'FAIL'; Message = "Custom role missing: $role" }
            Write-Log "✗ Role missing: $role" 'WARN'
        }
    }

    return $findings
}

# VERIFY NETWORKING
function Test-NetworkingCompliance {
    Write-Log "Verifying hub-and-spoke network topology..." 'INFO'
    $findings = @{}

    # This would require subscription context; adjust as needed
    $vnets = az network vnet list --output json 2>/dev/null | ConvertFrom-Json

    if ($vnets) {
        $hubVnet = $vnets | Where-Object { $_.name -like '*hub*' }
        $spokeVnet = $vnets | Where-Object { $_.name -like '*spoke*' }

        if ($hubVnet) {
            $findings['Hub-VNet'] = @{ Status = 'PASS'; Message = "Hub VNet exists" }
            Write-Log "✓ Hub VNet found" 'SUCCESS'
        }
        else {
            $findings['Hub-VNet'] = @{ Status = 'FAIL'; Message = "Hub VNet not found" }
            Write-Log "✗ Hub VNet not found" 'WARN'
        }

        if ($spokeVnet) {
            $findings['Spoke-VNet'] = @{ Status = 'PASS'; Message = "Spoke VNet exists" }
            Write-Log "✓ Spoke VNet found" 'SUCCESS'
        }
        else {
            $findings['Spoke-VNet'] = @{ Status = 'FAIL'; Message = "Spoke VNet not found" }
            Write-Log "✗ Spoke VNet not found" 'WARN'
        }
    }
    else {
        Write-Log "No VNets found (may be expected in tenant scope)" 'INFO'
        $findings['VNets'] = @{ Status = 'SKIP'; Message = "VNets check skipped (subscription required)" }
    }

    return $findings
}

# MAIN EXECUTION
try {
    Write-Log "===== FOX HEIGHT LAYER 0 COMPLIANCE VALIDATION ====="
    Write-Log "Management Group: $ManagementGroupId"
    Write-Log "Compliance Threshold: $ComplianceThreshold%"
    Write-Log "=============================================="

    $allFindings = @{}

    $allFindings += Test-ManagementGroupCompliance
    $allFindings += Test-DataResidencyCompliance
    $allFindings += Test-EncryptionCompliance
    $allFindings += Test-RBACCompliance
    $allFindings += Test-NetworkingCompliance

    # Calculate score
    $score = Get-ComplianceScore -Findings $allFindings

    Write-Log ""
    Write-Log "===== COMPLIANCE REPORT ====="
    Write-Log "Total Checks: $($allFindings.Count)"
    Write-Log "Passed: $($allFindings.Values | Where-Object { $_.Status -eq 'PASS' } | Measure-Object | Select-Object -ExpandProperty Count)"
    Write-Log "Failed: $($allFindings.Values | Where-Object { $_.Status -eq 'FAIL' } | Measure-Object | Select-Object -ExpandProperty Count)"
    Write-Log "Compliance Score: $score%"

    if ($score -ge $ComplianceThreshold) {
        Write-Log "===== VALIDATION PASSED =====" 'SUCCESS'
        exit 0
    }
    else {
        Write-Log "===== VALIDATION FAILED =====" 'CRITICAL'
        Write-Log "Compliance score ($score%) is below threshold ($ComplianceThreshold%)" 'CRITICAL'
        exit 1
    }
}
catch {
    Write-Log "VALIDATION ERROR: $_" 'ERROR'
    exit 1
}
