##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "random_password" "user" {
  for_each         = var.users
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

resource "postgresql_role" "user" {
  for_each           = var.users
  name               = each.value.name
  login              = try(each.value.login, true)
  password           = random_password.user[each.key].result
  encrypted_password = try(each.value.encrypted_password, true)
  superuser          = try(each.value.superuser, false)
  create_database    = try(each.value.create_database, false)
  create_role        = try(each.value.create_role, false)
  inherit            = try(each.value.inherit, true)
  replication        = try(each.value.replication, false)
  connection_limit   = try(each.value.connection_limit, -1)

  roles = each.value.grant == "owner" ? [
    try(each.value.db_ref, "") != "" ? postgresql_role.owner[each.value.db_ref].name : each.value.database_owner
  ] : []
}

resource "postgresql_grant" "user_readwrite" {
  for_each    = { for k, v in var.users : k => v if v.grant == "readwrite" }
  database    = try(each.value.db_ref, "") != "" ? postgresql_database.this[each.value.db_ref].name : each.value.database_name
  role        = postgresql_role.user[each.key].name
  schema      = try(each.value.schema, "public")
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE"]
}

resource "postgresql_grant" "user_readonly" {
  for_each    = { for k, v in var.users : k => v if v.grant == "readonly" }
  database    = try(each.value.db_ref, "") != "" ? postgresql_database.this[each.value.db_ref].name : each.value.database_name
  role        = postgresql_role.user[each.key].name
  schema      = try(each.value.schema, "public")
  object_type = "table"
  privileges  = ["SELECT"]
}
