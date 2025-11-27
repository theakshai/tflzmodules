resource "azurerm_storage_container" "container" {
  name                              = var.container_name
  storage_account_id                = var.storage_account_id
  container_access_type             = var.container_access_type
  default_encryption_scope          = var.default_encryption_scope
  encryption_scope_override_enabled = var.encryption_scope_override_enabled
}
