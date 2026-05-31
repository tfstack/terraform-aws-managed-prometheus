output "rule_group_namespace_names" {
  description = "Names of AMP rule group namespaces created."
  value       = [for namespace in aws_prometheus_rule_group_namespace.this : namespace.name]
}

output "resource_policy_json" {
  description = "Rendered JSON AMP resource policy document."
  value       = try(data.aws_iam_policy_document.resource_policy[0].json, null)
}
