##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "identity_store_id" {
  value = data.aws_ssoadmin_instances.sso.identity_store_ids[0]
}

output "identity_store_arn" {
  value = data.aws_ssoadmin_instances.sso.arns[0]
}

output "permission_sets" {
  value = {
    for p in aws_ssoadmin_permission_set.this : p.value.name => {
      id   = p.value.id
      arn  = p.value.arn
      name = p.value.name
    }
  }
}
