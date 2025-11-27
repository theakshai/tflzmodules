variable "container_name" {
  type        = string
  description = "Name of the container"
}

variable "storage_account_id" {
  type        = string
  description = "Storage account where the container needs to get deployed"
  default     = null
}

variable "container_access_type" {
  type        = string
  description = "The Access Level configured for this Container."
  validation {
    condition     = contains(["blob", "container", "private"], var.container_access_type)
    error_message = "Only blob, container and private access types are allowed"
  }
  default = "private"
}

variable "default_encryption_scope" {
  type        = bool
  description = "The default encryption scope to use for blobs uploaded to this container"
  default     = true

}
variable "encryption_scope_override_enabled" {
  type        = bool
  description = "Whether to allow blobs to override the default encryption scope for this container"
  default     = true
}

variable "metadata" {
  type        = map(any)
  description = "A mapping of MetaData for this Container. All metadata keys should be lowercase."
  default     = {}
}
