variable "storage_account_name" {
  type        = string
  description = "Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed"
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account"
}
variable "location" {
  type        = string
  description = " Specifies the supported Azure location where the resource exists"
}
variable "account_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Valid options are Standard and Premium"
  }
  default = "Standard"
}
variable "account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAZGRS"], var.account_replication_type)
    error_message = "Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  }
  default = "LRS"
}

variable "access_tier" {
  type        = string
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts"
  validation {
    condition     = contains(["Hot", "Cool", "Cold", "Premium"], var.access_tier)
    error_message = "Valid options are Hot, Cool, Cold and Premium"
  }
  default = "Hot"

}

variable "account_kind" {
  type        = string
  description = "Defines the Kind of account."
  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  }
  default = "StorageV2"
}
variable "https_traffic_only_enabled" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled"
  default     = true
}
variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account"
  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2", "TLS1_3"], var.min_tls_version)
    error_message = "Valid options are TLS1_0, TLS1_1, TLS1_2 and TLS1_3"
  }
  default = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "allow or disallow nested items within this Account to opt into being public"
  default     = true
}
variable "shared_access_key_enabled" {
  type        = bool
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD)"
  default     = true
}
variable "public_network_access_enabled" {
  type        = bool
  description = "Whether the public network access is enabled? "
  default     = true
}

variable "default_to_oauth_authentication" {
  type        = bool
  description = "Default to Azure Active Directory authorization in the Azure portal when accessing the Storage Account"
  default     = false
}

variable "nfsv3_enabled" {
  type        = bool
  description = "Is NFSv3 protocol enabled?"
  default     = false
}


variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned"], var.identity.type)
    error_message = "Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)"
  }
  default = null
}
variable "blob_properties" {
  type = object({
    cors_rule = optional(object({
      allowed_headers    = string
      allowed_methods    = string
      allowed_origins    = string
      exposed_headers    = string
      max_age_in_seconds = number

    }))
    delete_retention_policy = optional(object({
      days                     = optional(number)
      permanent_delete_enabled = optional(bool)

    }))
    restore_policy = optional(object({
      days = number

    }))
    versioning_enabled            = optional(string)
    change_feed_enabled           = optional(string)
    change_feed_retention_in_days = optional(number)
    default_service_version       = optional(string)
    last_access_time_enabled      = optional(bool)
    container_retention_policy = optional(object({
      days = optional(number)

    }))

  })
}
variable "network_rules" {
  type = object({
    default_action             = string
    bypass                     = optional(string)
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
    private_link_access = optional(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = string
    }))
  })
  description = "Network rules defined for the storage account"
}

variable "tags" {
  type = map(any)
}
