##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  normalized_owner_list = {
    for k, db in var.databases : k => try(db.create_owner, false) ? replace("${db.name}-owner", "_", "-") : ""
  }
}

resource "postgresql_database" "this" {
  for_each          = var.databases
  name              = each.value.name
  owner             = try(each.value.create_owner, false) ? postgresql_role.owner[each.key].name : try(each.value.owner, null)
  lc_collate        = try(each.value.collate, "en_US.UTF-8")
  lc_ctype          = try(each.value.ctype, "en_US.UTF-8")
  connection_limit  = try(each.value.connection_limit, -1)
  is_template       = try(each.value.is_template, false)
  template          = try(each.value.template, "template0")
  encoding          = try(each.value.encoding, "UTF8")
  allow_connections = try(each.value.allow_connections, true)

  lifecycle {
    ignore_changes = [owner]
  }
}

resource "postgresql_role" "owner" {
  for_each = { for k, db in var.databases : k => db if try(db.create_owner, false) }
  name     = "${each.value.name}_owner"
  login    = false
  inherit  = true
}

resource "postgresql_schema" "this" {
  for_each = {
    for entry in flatten([
      for db_key, db in var.databases : [
        for schema in try(db.schemas, []) : {
          key     = "${db_key}__${schema.name}"
          db_key  = db_key
          db_name = db.name
          schema  = schema
        }
      ]
    ]) : entry.key => entry
  }
  name          = each.value.schema.name
  database      = postgresql_database.this[each.value.db_key].name
  owner         = try(each.value.schema.owner, null)
  if_not_exists = try(each.value.schema.reuse, true)
  drop_cascade  = try(each.value.schema.cascade_on_delete, false)
}
