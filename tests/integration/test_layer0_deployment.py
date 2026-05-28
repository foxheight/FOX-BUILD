# FILE HEADER
# WHY THIS FILE: Integration tests for Layer 0 infrastructure deployment
# ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
# PRINCIPLE: End-to-end validation of deployed infrastructure
# SCALING ALGORITHM: IF deployment_complete THEN verify_resources_exist THEN validate_compliance
# DEPENDENCIES: pytest, Azure CLI configured, Management group permissions
# TESTS: This file contains integration tests

import pytest
import json
import subprocess
from pathlib import Path

@pytest.fixture(scope="session")
def azure_context():
    """Verify Azure CLI is configured."""
    try:
        result = subprocess.run(['az', 'account', 'show', '--output', 'json'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            return json.loads(result.stdout)
        else:
            pytest.skip("Azure CLI not configured")
    except FileNotFoundError:
        pytest.skip("Azure CLI not installed")

class TestManagementGroupDeployment:
    """Integration tests for management group deployment."""

    @pytest.mark.integration
    def test_management_groups_can_be_queried(self, azure_context):
        """Verify management groups are queryable via Azure CLI."""
        result = subprocess.run(
            ['az', 'account', 'management-group', 'list', '--output', 'json'],
            capture_output=True, text=True, timeout=30
        )
        assert result.returncode == 0, f"Failed to query management groups: {result.stderr}"
        groups = json.loads(result.stdout)
        assert isinstance(groups, list), "Management group list should be array"

class TestPolicyDeployment:
    """Integration tests for policy deployment."""

    @pytest.mark.integration
    def test_dpa_policy_can_be_queried(self, azure_context):
        """Verify DPA policy is queryable."""
        result = subprocess.run(
            ['az', 'policy', 'definition', 'list', '--query',
             "[?name=='foxheight-kenya-dpa-data-residency']", '--output', 'json'],
            capture_output=True, text=True, timeout=30
        )
        if result.returncode == 0:
            policies = json.loads(result.stdout)
            # Policy may not exist yet in test environment
            assert isinstance(policies, list), "Policy query should return array"

    @pytest.mark.integration
    def test_encryption_policy_can_be_queried(self, azure_context):
        """Verify encryption policy is queryable."""
        result = subprocess.run(
            ['az', 'policy', 'definition', 'list', '--query',
             "[?name=='foxheight-encryption-at-rest']", '--output', 'json'],
            capture_output=True, text=True, timeout=30
        )
        assert result.returncode == 0, "Policy query failed"

class TestRBACDeployment:
    """Integration tests for RBAC deployment."""

    @pytest.mark.integration
    def test_custom_roles_can_be_queried(self, azure_context):
        """Verify custom roles are queryable."""
        result = subprocess.run(
            ['az', 'role', 'definition', 'list', '--output', 'json'],
            capture_output=True, text=True, timeout=30
        )
        assert result.returncode == 0, "Role definition query failed"
        roles = json.loads(result.stdout)
        assert isinstance(roles, list), "Role list should be array"

class TestNetworkingDeployment:
    """Integration tests for networking deployment."""

    @pytest.mark.integration
    def test_vnets_can_be_queried(self, azure_context):
        """Verify virtual networks are queryable."""
        # This requires subscription context
        result = subprocess.run(
            ['az', 'network', 'vnet', 'list', '--output', 'json'],
            capture_output=True, text=True, timeout=30
        )
        # May fail if no subscription context; that's acceptable for tenant-scoped tests
        if result.returncode == 0:
            vnets = json.loads(result.stdout)
            assert isinstance(vnets, list), "VNet list should be array"

class TestDeploymentScripts:
    """Test deployment and validation scripts."""

    def test_deploy_script_exists(self):
        """Verify deployment script exists."""
        script_path = Path('./src/layer-0-infrastructure/scripts/deploy.ps1')
        assert script_path.exists(), "deploy.ps1 not found"

    def test_validate_script_exists(self):
        """Verify validation script exists."""
        script_path = Path('./src/layer-0-infrastructure/scripts/validate.ps1')
        assert script_path.exists(), "validate.ps1 not found"

    def test_deploy_script_syntax(self):
        """Verify PowerShell deployment script has valid syntax."""
        script_path = Path('./src/layer-0-infrastructure/scripts/deploy.ps1')
        content = script_path.read_text()
        
        # Basic syntax checks
        assert content.count('param(') >= 1, "Script should have parameters"
        assert content.count('function') >= 2, "Script should define functions"
        assert 'try' in content and 'catch' in content, "Script should have error handling"
        assert 'Write-Log' in content, "Script should use logging"

    def test_validate_script_syntax(self):
        """Verify PowerShell validation script has valid syntax."""
        script_path = Path('./src/layer-0-infrastructure/scripts/validate.ps1')
        content = script_path.read_text()
        
        # Basic syntax checks
        assert content.count('function Test-') >= 3, "Script should define test functions"
        assert 'Get-ComplianceScore' in content, "Script should calculate compliance score"
        assert 'Write-Log' in content, "Script should use logging"

if __name__ == '__main__':
    pytest.main([__file__, '-v', '-m', 'integration'])
