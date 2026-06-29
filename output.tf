##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

output "identity_store_id" {
  description = "Identity store ID of the discovered AWS IAM Identity Center instance."
  value       = data.aws_ssoadmin_instances.sso.identity_store_ids[0]
}

output "identity_store_arn" {
  description = "ARN of the discovered AWS IAM Identity Center instance."
  value       = data.aws_ssoadmin_instances.sso.arns[0]
}

output "permission_sets" {
  description = "Map of created permission sets keyed by name, each with its id, arn, and name."
  value = {
    for p in aws_ssoadmin_permission_set.this : p.name => {
      id   = p.id
      arn  = p.arn
      name = p.name
    }
  }
}
