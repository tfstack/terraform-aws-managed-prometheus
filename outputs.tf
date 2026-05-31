output "workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace."
  value       = module.workspace_core.workspace_arn
}

output "workspace_id" {
  description = "Identifier of the workspace."
  value       = module.workspace_core.workspace_id
}

output "prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace."
  value       = module.workspace_core.prometheus_endpoint
}

output "workspace_configuration_applied" {
  description = "Whether workspace configuration (retention period) was applied."
  value       = module.workspace_core.workspace_configuration_applied
}

output "rule_group_namespace_names" {
  description = "List of rule group namespace names created in AMP."
  value       = module.workspace_content.rule_group_namespace_names
}

output "resource_policy_json" {
  description = "Rendered JSON AMP resource policy document."
  value       = module.workspace_content.resource_policy_json
}
