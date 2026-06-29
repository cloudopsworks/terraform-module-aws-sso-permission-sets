##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# permission_sets: # (Optional) List of permission sets to create in the IAM Identity Center instance. Default: []
#   - name: "Admin"                                      # (Required) Unique name of the permission set.
#     description: "Admin permission set"                # (Optional) Description of the permission set. Default: "Managed by Terraform"
#     session_duration: "PT8H"                           # (Optional) Session duration as an ISO-8601 duration (e.g. PT1H, PT8H, PT12H). Default: "PT12H"
#     managed_policy_arns:                               # (Optional) List of AWS managed policy ARNs to attach. Default: []
#       - "arn:aws:iam::aws:policy/AdministratorAccess"
#       - "arn:aws:iam::aws:policy/SecurityAudit"
#     inline_policy:                                     # (Optional) List of named inline policies to attach. Default: []
#       - name: "InlinePolicy"                           # (Required) Name of the inline policy (when an inline_policy entry is provided).
#         statements:                                    # (Required) One or more IAM policy statements.
#           - sid: "SIDNAME"                             # (Optional) Statement ID. Default: null
#             effect: "Allow"                            # (Required) Statement effect. Valid values: "Allow", "Deny".
#             actions:                                   # (Required) List of IAM actions for the statement.
#               - "s3:GetObject"
#               - "s3:PutObject"
#             resources:                                 # (Required) List of resource ARNs the statement applies to.
#               - "arn:aws:s3:::mybucket/*"
variable "permission_sets" {
  description = "(Optional) List of permission sets to create in the IAM Identity Center instance. Default: []"
  type        = any
  default     = []
}
