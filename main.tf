module "workspace_core" {
  source = "./modules/workspace-core"

  create                   = var.create
  create_workspace         = var.create_workspace
  workspace_alias          = var.workspace_alias
  workspace_id             = var.workspace_id
  kms_key_arn              = var.kms_key_arn
  retention_period_in_days = var.retention_period_in_days
  tags                     = var.tags
}

module "workspace_content" {
  source = "./modules/workspace-content"

  create_content             = var.create && (var.create_workspace || trimspace(var.workspace_id) != "")
  create                     = var.create
  workspace_id               = module.workspace_core.workspace_id
  workspace_arn              = module.workspace_core.workspace_arn
  create_alert_manager       = var.create_alert_manager
  alert_manager_definition   = var.alert_manager_definition
  create_resource_policy     = var.create_resource_policy
  resource_policy_statements = var.resource_policy_statements
  rule_group_namespaces      = var.rule_group_namespaces
}
