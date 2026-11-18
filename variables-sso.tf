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
#     customer_managed_policies:                         # (Optional) List of customer managed IAM policies to attach by name. The policy must exist with the same name and path in every account the permission set is provisioned to. Default: []
#       - name: "MyCustomerPolicy"                       # (Required) Name of the customer managed policy.
#         path: "/"                                    # (Optional) Path of the customer managed policy. Default: "/"
#     inline_policy:                                     # (Optional) List of named inline policies. All entries are merged into the single inline policy of the permission set; statement sids must be unique across entries. Default: []
#       - name: "InlinePolicy"                           # (Required) Name of the inline policy (when an inline_policy entry is provided).
#         statements:                                    # (Required) One or more IAM policy statements.
#           - sid: "SIDNAME"                             # (Optional) Statement ID. Default: null
#             effect: "Allow"                            # (Required) Statement effect. Valid values: "Allow", "Deny".
#             actions:                                   # (Optional) List of IAM actions the statement allows or denies. Mutually exclusive with not_actions. Default: []
#               - "s3:GetObject"
#               - "s3:PutObject"
#             not_actions:                               # (Optional) List of IAM actions the statement applies to by exclusion. Mutually exclusive with actions. Default: []
#               - "s3:DeleteBucket"
#             resources:                                 # (Optional) List of resource ARNs the statement applies to. Mutually exclusive with not_resources. Default: []
#               - "arn:aws:s3:::mybucket/*"
#             not_resources:                             # (Optional) List of resource ARNs the statement applies to by exclusion. Mutually exclusive with resources. Default: []
#               - "arn:aws:s3:::otherbucket/*"
#             conditions:                                # (Optional) List of conditions applied to the statement. Alias: condition. Default: []
#               - test: "StringEquals"                   # (Required) Condition operator (when a conditions entry is provided). e.g. StringEquals, StringLike, ArnLike, Bool, IpAddress, DateGreaterThan.
#                 variable: "aws:PrincipalTag/team"      # (Required) Condition key the operator is evaluated against.
#                 values:                                # (Required) List of values compared against the condition key.
#                   - "platform"
variable "permission_sets" {
  description = "(Optional) List of permission sets to create in the IAM Identity Center instance. Default: []"
  type        = any
  default     = []
}
