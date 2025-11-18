resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku
  tenant_id           = var.tenant_id

  dynamic "access_policy" {
    for_each = var.access_policies
    content {
      tenant_id               = access_policy.value.tenant_id
      object_id               = access_policy.value.object_id
      secret_permissions      = access_policy.value.secret_permissions
      certificate_permissions = try(access_policy.value.certificate_permissions, null)
      key_permissions         = try(access_policy.value.key_permissions, null)
      storage_permissions     = try(access_policy.value.storage_permissions, null)
    }
  }

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [var.network_acls]
    content {
      default_action = network_acls.value.default_action
      bypass         = network_acls.value.bypass

      ip_rules                   = try(network_acls.value.ip_rules, null)
      virtual_network_subnet_ids = try(network_acls.value.virtual_network_subnet_ids, null)
    }
  }
  # This requires Microsoft.Authorization/roleAssignments/Write
  rbac_authorization_enabled    = var.rbac_authorization_enabled
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  tags                          = var.tags

}
