##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

module "db" {
  source    = "git::https://github.com/cloudopsworks/terraform-module-postgres-management.git?ref=v1.0.7"
  providers = { postgresql = postgresql }

  org = var.org

  databases                = var.databases
  users                    = var.users
  roles                    = try(var.roles, {})
  password_rotation_period = var.password_rotation_period
  force_reset              = var.force_reset
  rotation_lambda_name     = ""
  rotated_owner_passwords  = {}
  rotated_user_passwords   = {}
}
