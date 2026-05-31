mock_provider "aws" {
  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "123456789012"
    }
  }

  mock_data "aws_partition" {
    defaults = {
      partition = "aws"
    }
  }

  mock_data "aws_region" {
    defaults = {
      id = "ap-southeast-2"
    }
  }
}

run "plan_full_stack" {
  command = plan

  variables {
    workspace_alias          = "amp-basic"
    retention_period_in_days = 30
    create_alert_manager     = true
    create_resource_policy   = true
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
    tags = {
      Environment = "dev"
      ManagedBy   = "terraform"
    }
  }

  assert {
    condition = (
      var.create &&
      var.workspace_alias == "amp-basic" &&
      var.retention_period_in_days == 30 &&
      var.create_alert_manager &&
      var.create_resource_policy &&
      length(var.rule_group_namespaces) == 1
    )
    error_message = "Full stack plan should run with workspace, retention, alert manager, rules, and resource policy enabled."
  }
}

run "plan_no_resources_when_create_false" {
  command = plan

  variables {
    create                   = false
    workspace_alias          = "unused-when-create-false"
    create_alert_manager     = true
    create_resource_policy   = true
    retention_period_in_days = 30
    workspace_id             = "ws-12345678-1234-1234-1234-123456789012"
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
  }

  assert {
    condition     = output.workspace_id == null
    error_message = "workspace_id should be null when create is false."
  }

  assert {
    condition     = output.workspace_arn == null
    error_message = "workspace_arn should be null when create is false."
  }

  assert {
    condition     = output.prometheus_endpoint == null
    error_message = "prometheus_endpoint should be null when create is false."
  }

  assert {
    condition     = output.workspace_configuration_applied == false
    error_message = "workspace_configuration_applied should be false when create is false."
  }

  assert {
    condition     = length(output.rule_group_namespace_names) == 0
    error_message = "No rule group namespaces should be created when create is false."
  }

  assert {
    condition     = output.resource_policy_json == null
    error_message = "resource_policy_json should be null when create is false."
  }
}

run "plan_no_resources_when_disabled_by_default_inputs" {
  command = plan

  variables {
    create = false
  }

  assert {
    condition     = output.workspace_id == null && output.workspace_arn == null
    error_message = "Core workspace outputs should be null when module is disabled."
  }

  assert {
    condition     = output.workspace_configuration_applied == false && length(output.rule_group_namespace_names) == 0
    error_message = "No content resources should be planned when module is disabled."
  }
}
