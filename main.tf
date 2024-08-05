##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

data "aws_ssoadmin_instances" "sso" {}

locals {
  managed_policies = merge([
    for p in var.permission_sets : {
      for pol in try(p.managed_policy_arns, []) : "${p.name}-${pol}" => {
        permission_set = p.name
        arn            = pol
      }
    }
  ]...)
  inline_policies = merge([
    for p in var.permission_sets : {
      for pol in try(p.inline_policy, []) : "${p.name}-${pol.name}" => {
        permission_set = p.name
        name           = pol.name
        statements     = pol.statements
      }
    }
  ]...)
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each         = { for p in var.permission_sets : p.name => p }
  instance_arn     = data.aws_ssoadmin_instances.sso.arns[0]
  name             = each.value.name
  description      = try(each.value.description, "Managed by Terraform")
  session_duration = try(each.value.session_duration, "PT12H")
  tags             = local.all_tags
}

data "aws_iam_policy" "managed_policy" {
  for_each = local.managed_policies
  arn      = each.value.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "policy" {
  for_each           = local.managed_policies
  instance_arn       = data.aws_ssoadmin_instances.sso.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  managed_policy_arn = data.aws_iam_policy.managed_policy[each.key].arn
}

data "aws_iam_policy_document" "inline_policy" {
  for_each = local.inline_policies
  version  = "2012-10-17"
  dynamic "statement" {
    for_each = each.value.statements
    content {
      sid       = try(statement.value.sid, null)
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  for_each           = local.inline_policies
  instance_arn       = data.aws_ssoadmin_instances.sso.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  inline_policy      = data.aws_iam_policy_document.inline_policy[each.key].json
}