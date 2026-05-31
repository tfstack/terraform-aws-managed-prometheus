output "workspace_id" {
  description = "Identifier of the workspace."
  value       = local.workspace_id
}

output "workspace_arn" {
  description = "Amazon Resource Name (ARN) of the workspace."
  value       = local.workspace_arn
}

output "prometheus_endpoint" {
  description = "Prometheus endpoint for the created workspace."
  value       = try(aws_prometheus_workspace.this[0].prometheus_endpoint, null)
}

output "workspace_configuration_applied" {
  description = "Whether workspace configuration was created."
  value       = length(aws_prometheus_workspace_configuration.this) > 0
}
