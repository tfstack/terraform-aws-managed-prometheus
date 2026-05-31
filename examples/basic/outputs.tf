output "workspace_id" {
  description = "Identifier of the created AMP workspace."
  value       = module.managed_prometheus.workspace_id
}

output "workspace_arn" {
  description = "ARN of the created AMP workspace."
  value       = module.managed_prometheus.workspace_arn
}

output "prometheus_endpoint" {
  description = "Prometheus endpoint for the workspace."
  value       = module.managed_prometheus.prometheus_endpoint
}

output "rule_group_namespace_names" {
  description = "Rule group namespaces created by the example."
  value       = module.managed_prometheus.rule_group_namespace_names
}
