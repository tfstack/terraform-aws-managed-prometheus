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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workspace_content"></a> [workspace\_content](#module\_workspace\_content) | ./modules/workspace-content | n/a |
| <a name="module_workspace_core"></a> [workspace\_core](#module\_workspace\_core) | ./modules/workspace-core | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_manager_definition"></a> [alert\_manager\_definition](#input\_alert\_manager\_definition) | Alert manager definition YAML payload. | `string` | `"alertmanager_config: |\n  route:\n    receiver: 'default'\n  receivers:\n    - name: 'default'\n"` | no |
| <a name="input_create"></a> [create](#input\_create) | Determines whether resources will be created. | `bool` | `true` | no |
| <a name="input_create_alert_manager"></a> [create\_alert\_manager](#input\_create\_alert\_manager) | Controls whether an Alert Manager definition is created. | `bool` | `false` | no |
| <a name="input_create_resource_policy"></a> [create\_resource\_policy](#input\_create\_resource\_policy) | Controls whether an AMP resource policy is created. | `bool` | `false` | no |
| <a name="input_create_workspace"></a> [create\_workspace](#input\_create\_workspace) | Determines whether an AMP workspace will be created or an existing workspace\_id will be used. | `bool` | `true` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of the KMS key used for workspace encryption at rest. | `string` | `""` | no |
| <a name="input_resource_policy_statements"></a> [resource\_policy\_statements](#input\_resource\_policy\_statements) | A map of IAM policy statements that will be merged into the AMP resource policy document. | <pre>map(object({<br/>    sid           = optional(string)<br/>    actions       = optional(list(string))<br/>    not_actions   = optional(list(string))<br/>    effect        = optional(string, "Allow")<br/>    resources     = optional(list(string))<br/>    not_resources = optional(list(string))<br/>    principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })), [])<br/>    not_principals = optional(list(object({<br/>      type        = string<br/>      identifiers = list(string)<br/>    })), [])<br/>    condition = optional(list(object({<br/>      test     = string<br/>      variable = string<br/>      values   = list(string)<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_retention_period_in_days"></a> [retention\_period\_in\_days](#input\_retention\_period\_in\_days) | Number of days to retain metric data in the workspace. When null, no workspace configuration is applied. | `number` | `null` | no |
| <a name="input_rule_group_namespaces"></a> [rule\_group\_namespaces](#input\_rule\_group\_namespaces) | Map of AMP rule group namespaces to create. | <pre>map(object({<br/>    name = string<br/>    data = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to resources. | `map(string)` | `{}` | no |
| <a name="input_workspace_alias"></a> [workspace\_alias](#input\_workspace\_alias) | Alias for the AMP workspace. Required when create and create\_workspace are true. | `string` | `null` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | ID of an existing AMP workspace to use when create\_workspace is false. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_prometheus_endpoint"></a> [prometheus\_endpoint](#output\_prometheus\_endpoint) | Prometheus endpoint available for this workspace. |
| <a name="output_resource_policy_json"></a> [resource\_policy\_json](#output\_resource\_policy\_json) | Rendered JSON AMP resource policy document. |
| <a name="output_rule_group_namespace_names"></a> [rule\_group\_namespace\_names](#output\_rule\_group\_namespace\_names) | List of rule group namespace names created in AMP. |
| <a name="output_workspace_arn"></a> [workspace\_arn](#output\_workspace\_arn) | Amazon Resource Name (ARN) of the workspace. |
| <a name="output_workspace_configuration_applied"></a> [workspace\_configuration\_applied](#output\_workspace\_configuration\_applied) | Whether workspace configuration (retention period) was applied. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Identifier of the workspace. |
<!-- END_TF_DOCS -->
