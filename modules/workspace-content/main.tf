data "aws_iam_policy_document" "resource_policy" {
  count = var.create_content && var.create_resource_policy ? 1 : 0

  statement {
    sid    = "AllowGrafanaQuery"
    effect = "Allow"
    actions = [
      "aps:GetLabels",
      "aps:GetMetricMetadata",
      "aps:GetSeries",
      "aps:QueryMetrics"
    ]
    resources = [var.workspace_arn]

    principals {
      type        = "Service"
      identifiers = ["grafana.amazonaws.com"]
    }
  }

  dynamic "statement" {
    for_each = var.resource_policy_statements
    content {
      sid           = try(statement.value.sid, null)
      effect        = try(statement.value.effect, "Allow")
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      resources     = try(statement.value.resources, [var.workspace_arn])
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.condition, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_prometheus_alert_manager_definition" "this" {
  count = var.create_content && var.create_alert_manager ? 1 : 0

  workspace_id = var.workspace_id
  definition   = var.alert_manager_definition
}

resource "aws_prometheus_rule_group_namespace" "this" {
  for_each = var.create_content ? var.rule_group_namespaces : {}

  workspace_id = var.workspace_id
  name         = each.value.name
  data         = each.value.data
}

resource "aws_prometheus_resource_policy" "this" {
  count = var.create_content && var.create_resource_policy ? 1 : 0

  policy_document = data.aws_iam_policy_document.resource_policy[0].json
  workspace_id    = var.workspace_id
}
