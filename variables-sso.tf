##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

## YAML format
# permission_sets:
#   - name: "Admin"
#     description: "Admin permission set"
#     session_duration: PT8H
#     managed_policy_arns:
#       - "arn:aws:iam::aws:policy/AdministratorAccess"
#       - "arn:aws:iam::aws:policy/SecurityAudit"
#     inline_policy:
#       - name: "InlinePolicy"
#         statements:
#           - sid: "SIDNAME"
#             effect: "Allow"
#             actions:
#               - "s3:GetObject"
#               - "s3:PutObject"
#             resources:
#               - "arn:aws:s3:::mybucket/*"
variable "permission_sets" {
  description = "List of permission sets to create in the identity store"
  type        = any
  default     = []
}
