data "aws_partition" "current" {
  count = var.create ? 1 : 0
}

data "aws_region" "current" {
  count = var.create ? 1 : 0
}

data "aws_caller_identity" "current" {
  count = var.create ? 1 : 0
}

locals {
  workspace_id = var.create ? (
    var.create_workspace ? aws_prometheus_workspace.this[0].id : var.workspace_id
  ) : null

  workspace_arn = var.create ? (
    var.create_workspace
    ? aws_prometheus_workspace.this[0].arn
    : format(
      "arn:%s:aps:%s:%s:workspace/%s",
      data.aws_partition.current[0].partition,
      data.aws_region.current[0].region,
      data.aws_caller_identity.current[0].account_id,
      var.workspace_id
    )
  ) : null
}

resource "aws_prometheus_workspace" "this" {
  count = var.create && var.create_workspace ? 1 : 0

  alias       = var.workspace_alias
  kms_key_arn = var.kms_key_arn != "" ? var.kms_key_arn : null
  tags        = var.tags
}

resource "aws_prometheus_workspace_configuration" "this" {
  count = var.create && var.retention_period_in_days != null ? 1 : 0

  workspace_id             = local.workspace_id
  retention_period_in_days = var.retention_period_in_days
}
