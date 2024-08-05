##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "permission_sets" {
  description = "List of permission sets to create in the identity store"
  type        = any
  default     = []
}
