terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

locals {
  name = "amp-basic"
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "managed-prometheus"
  }
}

module "managed_prometheus" {
  source = "../../"

  workspace_alias          = local.name
  retention_period_in_days = 30

  create_alert_manager     = true
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
  tags                   = local.tags
}
