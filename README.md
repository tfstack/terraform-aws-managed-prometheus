# terraform-aws-managed-prometheus

Terraform module for [Amazon Managed Service for Prometheus](https://docs.aws.amazon.com/prometheus/latest/userguide/what-is-Amazon-Managed-Service-Prometheus.html) (AMP) workspaces and related control-plane resources.

This module follows tfstack conventions and groups tightly coupled AMP resources into two submodules:

| Submodule | Responsibility |
|-----------|----------------|
| [`workspace-core`](modules/workspace-core) | Workspace lifecycle, optional KMS encryption, retention configuration |
| [`workspace-content`](modules/workspace-content) | Alertmanager definition, rule group namespaces, workspace resource policy |

## Usage

```hcl
module "managed_prometheus" {
  source  = "tfstack/managed-prometheus/aws"
  version = "~> 0.1"

  workspace_alias          = "eks-21-metrics"
  retention_period_in_days = 30

  create_alert_manager = true
  alert_manager_definition = <<-EOT
alertmanager_config: |
  route:
    receiver: 'default'
  receivers:
    - name: 'default'
EOT

  rule_group_namespaces = {
    basic = {
      name = "basic-rules"
      data = <<-EORULES
groups:
  - name: basic
    rules:
      - record: demo:http_requests_total:sum
        expr: sum(http_requests_total)
EORULES
    }
  }

  create_resource_policy = true
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
```

See [`examples/basic`](examples/basic) for a working end-to-end example.

## Behaviour

- Set `create = false` to disable all module resources (useful for conditional stacks).
- Set `create_workspace = false` and provide `workspace_id` to attach alertmanager, rules, and resource policy to an existing AMP workspace.
- Set `retention_period_in_days = null` to skip `aws_prometheus_workspace_configuration` (workspace default retention applies).
- When `create_resource_policy = true`, the module creates a baseline policy statement allowing **Amazon Managed Grafana** query APIs (`aps:QueryMetrics`, etc.). Add further principals or conditions via `resource_policy_statements`.
- `prometheus_endpoint` is populated when the module creates a new workspace; it is `null` when attaching to an existing workspace by ID.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
