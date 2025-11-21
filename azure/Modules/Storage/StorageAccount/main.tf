resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  # Optional top-level settings
  account_kind                    = var.account_kind
  access_tier                     = var.access_tier
  https_traffic_only_enabled      = var.https_traffic_only_enabled
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  default_to_oauth_authentication = var.default_to_oauth_authentication
  nfsv3_enabled                   = var.nfsv3_enabled

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_properties == null ? [] : [var.blob_properties]

    content {
      dynamic "cors_rule" {
        for_each = try(blob_properties.value.cors_rule, null) == null ? [] : [blob_properties.value.cors_rule]

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = try(blob_properties.value.delete_retention_policy, null) == null ? [] : [blob_properties.value.delete_retention_policy]

        content {
          days                     = try(delete_retention_policy.value.days, null)
          permanent_delete_enabled = try(delete_retention_policy.value.permanent_delete_enabled, null)
        }
      }

      dynamic "restore_policy" {
        for_each = try(blob_properties.value.restore_policy, null) == null ? [] : [blob_properties.value.restore_policy]

        content {
          days = restore_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try(blob_properties.value.container_retention_policy, null) == null ? [] : [blob_properties.value.container_retention_policy]

        content {
          days = try(container_delete_retention_policy.value.days, null)
        }
      }

      versioning_enabled            = try(blob_properties.value.versioning_enabled, null)
      change_feed_enabled           = try(blob_properties.value.change_feed_enabled, null)
      change_feed_retention_in_days = try(blob_properties.value.change_feed_retention_in_days, null)
      default_service_version       = try(blob_properties.value.default_service_version, null)
      last_access_time_enabled      = try(blob_properties.value.last_access_time_enabled, null)
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]

    content {
      default_action             = network_rules.value.default_action
      bypass                     = try(network_rules.value.bypass, null)
      ip_rules                   = try(network_rules.value.ip_rules, null)
      virtual_network_subnet_ids = try(network_rules.value.virtual_network_subnet_ids, null)

      dynamic "private_link_access" {
        for_each = try(network_rules.value.private_link_access, null) == null ? [] : [network_rules.value.private_link_access]

        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id   = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }

  tags = var.tags
}

