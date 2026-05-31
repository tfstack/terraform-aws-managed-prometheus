variable "create" {
  description = "Determines whether resources will be created."
  type        = bool
  default     = true
}

variable "create_workspace" {
  description = "Determines whether an AMP workspace is created or an existing workspace is used."
  type        = bool
  default     = true
}

variable "workspace_alias" {
  description = "Alias for the AMP workspace. Required when creating a workspace."
  type        = string
  default     = null

  validation {
    condition = !var.create || !var.create_workspace || (
      var.workspace_alias != null && trimspace(var.workspace_alias) != ""
    )
    error_message = "workspace_alias must be provided when create and create_workspace are true."
  }
}

variable "workspace_id" {
  description = "ID of an existing AMP workspace. Required when create_workspace is false."
  type        = string
  default     = ""

  validation {
    condition     = !var.create || var.create_workspace || trimspace(var.workspace_id) != ""
    error_message = "workspace_id must be provided when create is true and create_workspace is false."
  }
}

variable "kms_key_arn" {
  description = "ARN of a KMS key used for workspace encryption at rest."
  type        = string
  default     = ""
}

variable "retention_period_in_days" {
  description = "Retention in days for workspace metrics. Set null to skip workspace configuration."
  type        = number
  default     = null
}

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
  default     = {}
}
