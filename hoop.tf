##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  hoop_enabled    = try(var.hoop.enabled, false)
  hoop_enterprise = local.hoop_enabled && !try(var.hoop.community, true)
}

# Per-field hoop secrets for owner connections (enterprise only)
resource "google_secret_manager_secret" "hoop_owner_host" {
  for_each  = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret_id = lower(replace("${local.owner_secret_ids[each.key]}-hoop-host", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_owner_host" {
  for_each    = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret      = google_secret_manager_secret.hoop_owner_host[each.key].id
  secret_data = local.psql.host
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_owner_port" {
  for_each  = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret_id = lower(replace("${local.owner_secret_ids[each.key]}-hoop-port", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_owner_port" {
  for_each    = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret      = google_secret_manager_secret.hoop_owner_port[each.key].id
  secret_data = tostring(local.psql.port)
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_owner_user" {
  for_each  = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret_id = lower(replace("${local.owner_secret_ids[each.key]}-hoop-user", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_owner_user" {
  for_each    = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret      = google_secret_manager_secret.hoop_owner_user[each.key].id
  secret_data = module.db.owner_usernames[each.key]
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_owner_pass" {
  for_each  = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret_id = lower(replace("${local.owner_secret_ids[each.key]}-hoop-pass", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_owner_pass" {
  for_each    = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret      = google_secret_manager_secret.hoop_owner_pass[each.key].id
  secret_data = module.db.owner_passwords[each.key]
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_owner_db" {
  for_each  = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret_id = lower(replace("${local.owner_secret_ids[each.key]}-hoop-db", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_owner_db" {
  for_each    = local.hoop_enterprise ? { for k, db in var.databases : k => db if try(db.create_owner, false) } : {}
  secret      = google_secret_manager_secret.hoop_owner_db[each.key].id
  secret_data = each.value.name
  lifecycle { create_before_destroy = true }
}

# Per-field hoop secrets for user connections (enterprise only)
resource "google_secret_manager_secret" "hoop_user_host" {
  for_each  = local.hoop_enterprise ? var.users : {}
  secret_id = lower(replace("${local.user_secret_ids[each.key]}-hoop-host", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_user_host" {
  for_each    = local.hoop_enterprise ? var.users : {}
  secret      = google_secret_manager_secret.hoop_user_host[each.key].id
  secret_data = local.psql.host
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_user_port" {
  for_each  = local.hoop_enterprise ? var.users : {}
  secret_id = lower(replace("${local.user_secret_ids[each.key]}-hoop-port", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_user_port" {
  for_each    = local.hoop_enterprise ? var.users : {}
  secret      = google_secret_manager_secret.hoop_user_port[each.key].id
  secret_data = tostring(local.psql.port)
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_user_user" {
  for_each  = local.hoop_enterprise ? var.users : {}
  secret_id = lower(replace("${local.user_secret_ids[each.key]}-hoop-user", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_user_user" {
  for_each    = local.hoop_enterprise ? var.users : {}
  secret      = google_secret_manager_secret.hoop_user_user[each.key].id
  secret_data = each.value.name
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_user_pass" {
  for_each  = local.hoop_enterprise ? var.users : {}
  secret_id = lower(replace("${local.user_secret_ids[each.key]}-hoop-pass", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_user_pass" {
  for_each    = local.hoop_enterprise ? var.users : {}
  secret      = google_secret_manager_secret.hoop_user_pass[each.key].id
  secret_data = module.db.user_passwords[each.key]
  lifecycle { create_before_destroy = true }
}

resource "google_secret_manager_secret" "hoop_user_db" {
  for_each  = local.hoop_enterprise ? var.users : {}
  secret_id = lower(replace("${local.user_secret_ids[each.key]}-hoop-db", "/[^a-zA-Z0-9_-]/", "-"))
  project   = data.google_project.current.project_id
  labels    = local.all_tags
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "hoop_user_db" {
  for_each    = local.hoop_enterprise ? var.users : {}
  secret      = google_secret_manager_secret.hoop_user_db[each.key].id
  secret_data = try(each.value.db_ref, "") != "" ? var.databases[each.value.db_ref].name : each.value.database_name
  lifecycle { create_before_destroy = true }
}

output "hoop_connections" {
  description = "Hoop connection definitions (enterprise only; community returns null — GCP SM has no sub-key access)."
  value = local.hoop_enterprise ? merge(
    {
      for k, db in var.databases : "${local.psql.server_name}-${db.name}-owner" => {
        name           = "${local.psql.server_name}-${db.name}-owner"
        agent_id       = var.hoop.agent_id
        type           = "database"
        subtype        = "postgres"
        tags           = try(var.hoop.tags, {})
        access_control = toset(try(var.hoop.access_control, []))
        access_modes   = { connect = "enabled", exec = "enabled", runbooks = "enabled", schema = "enabled" }
        import         = try(var.hoop.import, false)
        secrets = {
          "envvar:HOST"    = "_envs/gcp/${google_secret_manager_secret.hoop_owner_host[k].secret_id}"
          "envvar:PORT"    = "_envs/gcp/${google_secret_manager_secret.hoop_owner_port[k].secret_id}"
          "envvar:USER"    = "_envs/gcp/${google_secret_manager_secret.hoop_owner_user[k].secret_id}"
          "envvar:PASS"    = "_envs/gcp/${google_secret_manager_secret.hoop_owner_pass[k].secret_id}"
          "envvar:DB"      = "_envs/gcp/${google_secret_manager_secret.hoop_owner_db[k].secret_id}"
          "envvar:SSLMODE" = try(var.hoop.default_sslmode, "require")
        }
      } if try(db.create_owner, false)
    },
    {
      for k, user in var.users : "${local.psql.server_name}-${try(user.db_ref, "") != "" ? var.databases[user.db_ref].name : user.database_name}-${user.name}" => {
        name     = "${local.psql.server_name}-${try(user.db_ref, "") != "" ? var.databases[user.db_ref].name : user.database_name}-${user.name}"
        agent_id = var.hoop.agent_id
        type     = "database"
        subtype  = "postgres"
        tags     = try(var.hoop.tags, {})
        access_control = setunion(
          toset(try(var.hoop.access_control, [])),
          toset(try(user.hoop.access_control, []))
        )
        access_modes = { connect = "enabled", exec = "enabled", runbooks = "enabled", schema = "enabled" }
        import       = try(var.hoop.import, false)
        secrets = {
          "envvar:HOST"    = "_envs/gcp/${google_secret_manager_secret.hoop_user_host[k].secret_id}"
          "envvar:PORT"    = "_envs/gcp/${google_secret_manager_secret.hoop_user_port[k].secret_id}"
          "envvar:USER"    = "_envs/gcp/${google_secret_manager_secret.hoop_user_user[k].secret_id}"
          "envvar:PASS"    = "_envs/gcp/${google_secret_manager_secret.hoop_user_pass[k].secret_id}"
          "envvar:DB"      = "_envs/gcp/${google_secret_manager_secret.hoop_user_db[k].secret_id}"
          "envvar:SSLMODE" = try(var.hoop.default_sslmode, "require")
        }
      }
    }
  ) : null

  precondition {
    condition     = !local.hoop_enterprise || try(var.hoop.agent_id, "") != ""
    error_message = "hoop.agent_id must be set when hoop.enabled=true and hoop.community=false."
  }
}
