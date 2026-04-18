##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "postgresql_role" "role" {
  for_each         = var.roles
  name             = each.value.name
  login            = false
  create_database  = try(each.value.create_database, false)
  create_role      = try(each.value.create_role, false)
  inherit          = try(each.value.inherit, true)
  replication      = try(each.value.replication, false)
  connection_limit = try(each.value.connection_limit, -1)
}
