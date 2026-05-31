variable "create" {
  description = "Determines whether resources will be created."
  type        = bool
  default     = true
}

variable "create_workspace" {
  description = "Determines whether an AMP workspace will be created or an existing workspace_id will be used."
  type        = bool
  default     = true
}

variable "workspace_alias" {
  description = "Alias for the AMP workspace. Required when create and create_workspace are true."
  type        = string
  default     = null
}

variable "workspace_id" {
  description = "ID of an existing AMP workspace to use when create_workspace is false."
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for workspace encryption at rest."
  type        = string
  default     = ""
}

variable "retention_period_in_days" {
  description = "Number of days to retain metric data in the workspace. When null, no workspace configuration is applied."
  type        = number
  default     = null
}

variable "create_alert_manager" {
  description = "Controls whether an Alert Manager definition is created."
  type        = bool
  default     = false
}

variable "alert_manager_definition" {
  description = "Alert manager definition YAML payload."
  type        = string
  default     = <<-EOT
alertmanager_config: |
  route:
    receiver: 'default'
  receivers:
    - name: 'default'
EOT
}

variable "create_resource_policy" {
  description = "Controls whether an AMP resource policy is created."
  type        = bool
  default     = false
}

variable "resource_policy_statements" {
  description = "A map of IAM policy statements that will be merged into the AMP resource policy document."
  type = map(object({
    sid           = optional(string)
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    effect        = optional(string, "Allow")
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })), [])
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })), [])
    condition = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))
  default = {}
}

variable "rule_group_namespaces" {
  description = "Map of AMP rule group namespaces to create."
  type = map(object({
    name = string
    data = string
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to apply to resources."
  type        = map(string)
  default     = {}
}
