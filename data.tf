##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  cloudsql_enabled    = try(var.cloudsql.enabled, false)
  from_secret_enabled = local.cloudsql_enabled && try(var.cloudsql.from_secret, false)
  hoop_connect        = try(var.hoop.enabled, false) && !local.cloudsql_enabled && !try(var.direct.server_name, "") != ""
  psql = local.cloudsql_enabled && local.from_secret_enabled ? {
    host        = jsondecode(data.google_secret_manager_secret_version.cloudsql_creds[0].secret_data)["host"]
    port        = jsondecode(data.google_secret_manager_secret_version.cloudsql_creds[0].secret_data)["port"]
    username    = jsondecode(data.google_secret_manager_secret_version.cloudsql_creds[0].secret_data)["username"]
    password    = jsondecode(data.google_secret_manager_secret_version.cloudsql_creds[0].secret_data)["password"]
    db_name     = jsondecode(data.google_secret_manager_secret_version.cloudsql_creds[0].secret_data)["dbname"]
    server_name = try(var.cloudsql.server_name, var.cloudsql.instance_name)
    sslmode     = try(var.cloudsql.sslmode, "require")
    engine      = "postgresql"
    superuser   = try(var.cloudsql.superuser, false)
    } : local.cloudsql_enabled ? {
    host        = data.google_sql_database_instance.this[0].ip_address[0].ip_address
    port        = 5432
    username    = try(var.cloudsql.admin_username, "postgres")
    password    = try(var.cloudsql.admin_password, "")
    db_name     = try(var.cloudsql.db_name, "postgres")
    server_name = try(var.cloudsql.server_name, var.cloudsql.instance_name)
    sslmode     = try(var.cloudsql.sslmode, "require")
    engine      = "postgresql"
    superuser   = try(var.cloudsql.superuser, false)
    } : try(var.hoop.enabled, false) ? {
    host        = "127.0.0.1"
    port        = try(var.hoop.port, 5433)
    username    = try(var.hoop.username, "noop")
    password    = try(var.hoop.password, "noop")
    db_name     = try(var.hoop.db_name, "postgres")
    server_name = try(var.hoop.server_name, "")
    sslmode     = try(var.hoop.default_sslmode, "disable")
    engine      = try(var.hoop.engine, "postgresql")
    superuser   = try(var.hoop.superuser, false)
    } : {
    host        = try(var.direct.host, "")
    port        = try(var.direct.port, 5432)
    username    = try(var.direct.username, "")
    password    = try(var.direct.password, "")
    db_name     = try(var.direct.db_name, "postgres")
    server_name = try(var.direct.server_name, "")
    sslmode     = try(var.direct.sslmode, "require")
    engine      = try(var.direct.engine, "postgresql")
    superuser   = try(var.direct.superuser, false)
  }
}

data "google_sql_database_instance" "this" {
  count   = local.cloudsql_enabled && !local.from_secret_enabled ? 1 : 0
  name    = var.cloudsql.instance_name
  project = try(var.cloudsql.project_id, data.google_project.current.project_id)
}

data "google_secret_manager_secret_version" "cloudsql_creds" {
  count   = local.from_secret_enabled ? 1 : 0
  secret  = var.cloudsql.secret_id
  project = try(var.cloudsql.project_id, data.google_project.current.project_id)
}
