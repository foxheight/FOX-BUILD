# FILE HEADER
# WHY THIS FILE: Comprehensive unit tests for Layer 0 infrastructure components
# ARCHITECTURE LINK: Layer 0 — Sovereign Infrastructure Substrate
# PRINCIPLE: Zero mistakes entry condition. Every component tested before deployment.
# SCALING ALGORITHM: IF code_written THEN test_immediately THEN enforce_80%_coverage
# DEPENDENCIES: pytest, pytest-cov, json, yaml
# TESTS: This file contains the tests

import json
import pytest
from pathlib import Path

# Test fixtures
@pytest.fixture
def bicep_dir():
    return Path('./src/layer-0-infrastructure/landing-zone')

@pytest.fixture
def management_groups_bicep(bicep_dir):
    return bicep_dir / 'management-groups.bicep'

@pytest.fixture
def policies_bicep(bicep_dir):
    return bicep_dir / 'policies.bicep'

@pytest.fixture
def rbac_bicep(bicep_dir):
    return bicep_dir / 'rbac.bicep'

@pytest.fixture
def networking_bicep(bicep_dir):
    return bicep_dir / 'networking.bicep'

# Management Groups Tests
class TestManagementGroups:
    """Test management group hierarchy definition."""

    def test_management_groups_file_exists(self, management_groups_bicep):
        """Verify management groups Bicep file exists."""
        assert management_groups_bicep.exists(), f"File not found: {management_groups_bicep}"

    def test_management_groups_contains_root(self, management_groups_bicep):
        """Verify management groups includes root group."""
        content = management_groups_bicep.read_text()
        assert 'foxheight-root' in content, "Root management group definition missing"
        assert "displayName: 'Fox Height LTD — Root'" in content

    def test_management_groups_contains_production(self, management_groups_bicep):
        """Verify management groups includes production group."""
        content = management_groups_bicep.read_text()
        assert 'foxheight-production' in content, "Production management group missing"
        assert 'displayName' in content and 'Production' in content

    def test_management_groups_contains_clients(self, management_groups_bicep):
        """Verify management groups includes clients group."""
        content = management_groups_bicep.read_text()
        assert 'foxheight-clients' in content, "Clients management group missing"
        assert 'Client Environments' in content

    def test_management_groups_contains_development(self, management_groups_bicep):
        """Verify management groups includes development group."""
        content = management_groups_bicep.read_text()
        assert 'foxheight-development' in content, "Development management group missing"

    def test_management_groups_hierarchy_structure(self, management_groups_bicep):
        """Verify parent-child relationships are defined."""
        content = management_groups_bicep.read_text()
        # Child groups should reference parent ID
        assert 'foxHeightRoot.id' in content, "Parent references missing in hierarchy"
        assert content.count('parent') >= 3, "Not all child groups reference parent"

    def test_management_groups_outputs(self, management_groups_bicep):
        """Verify outputs are defined for downstream use."""
        content = management_groups_bicep.read_text()
        assert 'output rootId' in content, "Root ID output missing"
        assert 'output productionId' in content, "Production ID output missing"
        assert 'output clientsId' in content, "Clients ID output missing"
        assert 'output developmentId' in content, "Development ID output missing"

# Policies Tests
class TestPolicies:
    """Test Azure Policy definitions."""

    def test_policies_file_exists(self, policies_bicep):
        """Verify policies Bicep file exists."""
        assert policies_bicep.exists(), f"File not found: {policies_bicep}"

    def test_dpa_2019_policy_defined(self, policies_bicep):
        """Verify Kenya DPA 2019 data residency policy is defined."""
        content = policies_bicep.read_text()
        assert 'foxheight-kenya-dpa-data-residency' in content, "DPA 2019 policy not found"
        assert 'Kenya DPA 2019 Data Residency' in content

    def test_dpa_policy_uses_deny_effect(self, policies_bicep):
        """Verify DPA policy uses 'deny' effect (not 'audit')."""
        content = policies_bicep.read_text()
        # Extract DPA policy section
        dpa_section = content[content.find('foxheight-kenya-dpa'):content.find('foxheight-kenya-dpa') + 2000]
        assert "effect: 'deny'" in dpa_section, "DPA policy should use 'deny' effect for enforcement"

    def test_dpa_policy_approved_regions(self, policies_bicep):
        """Verify DPA policy restricts to approved African regions."""
        content = policies_bicep.read_text()
        assert 'southafricanorth' in content, "South Africa North region not in approved list"
        assert 'southafricawest' in content, "South Africa West region not in approved list"

    def test_encryption_policy_defined(self, policies_bicep):
        """Verify encryption at rest policy is defined."""
        content = policies_bicep.read_text()
        assert 'foxheight-encryption-at-rest' in content, "Encryption policy not found"
        assert 'Encryption at Rest Required' in content

    def test_approved_resources_policy_defined(self, policies_bicep):
        """Verify approved resource types policy is defined."""
        content = policies_bicep.read_text()
        assert 'foxheight-approved-resources-only' in content, "Approved resources policy not found"
        assert 'Approved Resource Types Only' in content

    def test_policies_have_descriptions(self, policies_bicep):
        """Verify all policies have descriptions for audit trails."""
        content = policies_bicep.read_text()
        description_count = content.count('description:')
        assert description_count >= 3, "Not all policies have descriptions"

    def test_policies_outputs(self, policies_bicep):
        """Verify policy definitions are output."""
        content = policies_bicep.read_text()
        assert 'output dpaPolicyId' in content, "DPA policy ID output missing"
        assert 'output encryptionPolicyId' in content, "Encryption policy ID output missing"
        assert 'output approvedResourcesPolicyId' in content, "Approved resources policy ID output missing"

# RBAC Tests
class TestRBAC:
    """Test custom RBAC role definitions."""

    def test_rbac_file_exists(self, rbac_bicep):
        """Verify RBAC Bicep file exists."""
        assert rbac_bicep.exists(), f"File not found: {rbac_bicep}"

    def test_infrastructure_admin_role_defined(self, rbac_bicep):
        """Verify Infrastructure Administrator custom role is defined."""
        content = rbac_bicep.read_text()
        assert 'Fox Height Infrastructure Administrator' in content, "Infrastructure Admin role missing"
        assert 'infraAdminRole' in content

    def test_security_auditor_role_defined(self, rbac_bicep):
        """Verify Security Auditor custom role is defined."""
        content = rbac_bicep.read_text()
        assert 'Fox Height Security Auditor' in content, "Security Auditor role missing"
        assert 'securityAuditorRole' in content

    def test_data_classification_role_defined(self, rbac_bicep):
        """Verify Data Classification Officer role is defined."""
        content = rbac_bicep.read_text()
        assert 'Fox Height Data Classification Officer' in content, "Data Classification role missing"
        assert 'dataClassificationRole' in content

    def test_infrastructure_admin_has_limited_actions(self, rbac_bicep):
        """Verify Infrastructure Admin role has least privilege principle."""
        content = rbac_bicep.read_text()
        assert 'notActions' in content, "notActions (explicit denies) not found"
        assert 'delete' in content, "Delete actions should be denied for Infrastructure Admin"

    def test_security_auditor_read_only(self, rbac_bicep):
        """Verify Security Auditor role is read-only."""
        content = rbac_bicep.read_text()
        # Find security auditor section
        auditor_section = content[content.find('securityAuditorRole'):content.find('dataClassificationRole')]
        assert "'*/read'" in auditor_section, "Security Auditor should have read-only permissions"
        assert 'KeyVault' in auditor_section and 'secrets/read' in auditor_section, "KeyVault secrets should be excluded"

    def test_roles_scoped_correctly(self, rbac_bicep):
        """Verify roles are scoped to appropriate level."""
        content = rbac_bicep.read_text()
        assert 'assignableScopes' in content, "Assignable scopes not defined"
        assert 'subscription().id' in content, "Roles should be scoped to subscription"

    def test_rbac_outputs(self, rbac_bicep):
        """Verify role IDs are output for assignment."""
        content = rbac_bicep.read_text()
        assert 'output infraAdminRoleId' in content
        assert 'output securityAuditorRoleId' in content
        assert 'output dataClassificationRoleId' in content

# Networking Tests
class TestNetworking:
    """Test hub-and-spoke network topology."""

    def test_networking_file_exists(self, networking_bicep):
        """Verify networking Bicep file exists."""
        assert networking_bicep.exists(), f"File not found: {networking_bicep}"

    def test_hub_vnet_defined(self, networking_bicep):
        """Verify hub virtual network is defined."""
        content = networking_bicep.read_text()
        assert 'vnet-fox-height-hub' in content, "Hub VNet not defined"
        assert 'hubVnet' in content

    def test_spoke_vnet_defined(self, networking_bicep):
        """Verify spoke virtual network is defined."""
        content = networking_bicep.read_text()
        assert 'vnet-fox-height-spoke' in content, "Spoke VNet not defined"
        assert 'spokeVnet' in content

    def test_hub_address_space(self, networking_bicep):
        """Verify hub has correct address space."""
        content = networking_bicep.read_text()
        hub_section = content[content.find('hubVnet'):content.find('defaultDenyNsg')]
        assert '10.0.0.0/16' in hub_section, "Hub should use 10.0.0.0/16"

    def test_spoke_address_space(self, networking_bicep):
        """Verify spoke has correct address space."""
        content = networking_bicep.read_text()
        spoke_section = content[content.find('spokeVnet'):content.find('hubToSpokePeering')]
        assert '10.1.0.0/16' in spoke_section, "Spoke should use 10.1.0.0/16"

    def test_default_deny_nsg_defined(self, networking_bicep):
        """Verify default-deny Network Security Group is defined."""
        content = networking_bicep.read_text()
        assert 'defaultDenyNsg' in content, "Default-deny NSG not defined"
        assert 'DenyAllInbound' in content, "DenyAllInbound rule missing"
        assert 'DenyAllOutbound' in content, "DenyAllOutbound rule missing"

    def test_nsg_default_deny_principle(self, networking_bicep):
        """Verify NSG implements Zero Trust default-deny principle."""
        content = networking_bicep.read_text()
        # Count deny rules
        deny_count = content.count("'Deny'")
        allow_count = content.count("'Allow'")
        assert deny_count >= 2, "NSG should have default deny rules"
        assert allow_count <= deny_count, "Allow rules should be minimal and explicit"

    def test_vnet_peering_configured(self, networking_bicep):
        """Verify hub-spoke peering is configured bidirectionally."""
        content = networking_bicep.read_text()
        assert 'hubToSpokePeering' in content, "Hub to spoke peering not defined"
        assert 'spokeToHubPeering' in content, "Spoke to hub peering not defined"
        assert content.count('virtualNetworkPeerings') >= 2, "Peering should be bidirectional"

    def test_network_outputs(self, networking_bicep):
        """Verify network resource IDs are output."""
        content = networking_bicep.read_text()
        assert 'output hubVnetId' in content
        assert 'output spokeVnetId' in content
        assert 'output nsgId' in content

# Documentation Tests
class TestDocumentation:
    """Test file documentation headers."""

    def test_all_bicep_files_have_headers(self, bicep_dir):
        """Verify all Bicep files have documentation headers."""
        bicep_files = list(bicep_dir.glob('*.bicep'))
        assert len(bicep_files) > 0, "No Bicep files found"
        
        for bicep_file in bicep_files:
            content = bicep_file.read_text()
            assert '// FILE HEADER' in content, f"{bicep_file.name} missing documentation header"
            assert '// WHY THIS FILE:' in content, f"{bicep_file.name} missing WHY section"
            assert '// PRINCIPLE:' in content, f"{bicep_file.name} missing PRINCIPLE section"

    def test_no_todo_comments(self, bicep_dir):
        """Verify no TODO/FIXME comments in production code (zero mistakes principle)."""
        bicep_files = list(bicep_dir.glob('*.bicep'))
        
        for bicep_file in bicep_files:
            content = bicep_file.read_text()
            assert 'TODO' not in content.upper(), f"{bicep_file.name} contains TODO comments"
            assert 'FIXME' not in content.upper(), f"{bicep_file.name} contains FIXME comments"
            assert 'XXX' not in content, f"{bicep_file.name} contains XXX comments"
            assert 'HACK' not in content, f"{bicep_file.name} contains HACK comments"

if __name__ == '__main__':
    pytest.main([__file__, '-v', '--cov=src/layer-0-infrastructure', '--cov-report=term-missing'])
