##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
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
  customer_managed_policies = merge([
    for p in var.permission_sets : {
      for pol in try(p.customer_managed_policies, []) : "${p.name}-${pol.name}" => {
        permission_set = p.name
        name           = pol.name
        path           = try(pol.path, "/")
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
  inline_policy_sets = {
    for p in var.permission_sets : p.name => [
      for pol in try(p.inline_policy, []) : "${p.name}-${pol.name}"
    ] if length(try(p.inline_policy, [])) > 0
  }
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
      sid           = try(statement.value.sid, null)
      effect        = statement.value.effect
      actions       = try(statement.value.actions, [])
      resources     = try(statement.value.resources, [])
      not_actions   = try(statement.value.not_actions, [])
      not_resources = try(statement.value.not_resources, [])
      dynamic "condition" {
        for_each = try(statement.value.condition, statement.value.conditions, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

# A permission set holds a single inline policy, so every inline_policy entry of the
# same permission set is merged into one document before it is attached.
data "aws_iam_policy_document" "inline_policy_merged" {
  for_each                = local.inline_policy_sets
  version                 = "2012-10-17"
  source_policy_documents = [for key in each.value : data.aws_iam_policy_document.inline_policy[key].json]
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  for_each           = local.inline_policy_sets
  instance_arn       = data.aws_ssoadmin_instances.sso.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  inline_policy      = data.aws_iam_policy_document.inline_policy_merged[each.key].json
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "customer" {
  for_each           = local.customer_managed_policies
  instance_arn       = data.aws_ssoadmin_instances.sso.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  customer_managed_policy_reference {
    name = each.value.name
    path = each.value.path
  }
}

