variable "key_vault_name" {
  type        = string
  description = "Name of the Key Valut"
}

variable "tags" {
  type        = map(any)
  description = "All default tag values"
}

variable "location" {
  type        = string
  description = "Location to deploy the key vaults"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy the key vaults"
}


variable "sku" {
  type        = string
  description = "The Name of the SKU used for this Key Vault"
  validation {
    condition     = contains(["standard", "premium"], var.sku)
    error_message = "Supported SKU values: standard, premium"
  }
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
}

variable "enabled_for_deployment" {
  type    = bool
  default = false
}
variable "enabled_for_template_deployment" {
  type    = bool
  default = false
}
variable "enabled_for_disk_encryption" {
  type    = bool
  default = false
}

variable "rbac_authorization_enabled" {
  type    = bool
  default = false
}

variable "purge_protection_enabled" {
  type    = bool
  default = false

}
variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Retention days for the Key Vault"
  validation {
    condition     = var.soft_delete_retention_days > 6 && var.soft_delete_retention_days <= 90
    error_message = "Key Vault rentention days must between 7 and 90"
  }
  default = 7
}

variable "access_policies" {
  description = "List of access policies"
  type = list(object({
    tenant_id               = string
    object_id               = string
    secret_permissions      = list(string)
    certificate_permissions = optional(list(string))
    key_permissions         = optional(list(string))
    storage_permissions     = optional(list(string))
  }))
  default = []
}

variable "network_acls" {
  description = "Network ACLs for Key Vault"
  type = object({
    default_action             = string
    bypass                     = string
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  default = null
}
