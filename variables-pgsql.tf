##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## users definition - YAML format
# users:
#   <user_ref>:
#     name: "username"               # (Required) Name of the user.
#     grant: "owner"                 # (Required) Grant type: owner, readwrite, readonly.
#     db_ref: "db_ref"               # (Optional) Reference to databases key; takes precedence over database_name.
#     database_name: "dbname"        # (Optional) Database name when db_ref not set.
#     database_owner: "dbname_ow"    # (Conditionally Required) Owner role when grant=owner without db_ref.
#     schema: "public"               # (Optional) Schema. Default: public.
#     login: true                    # (Optional) Can login. Default: true.
#     superuser: false               # (Optional) Is superuser. Default: false.
#     create_database: false         # (Optional) Can create databases. Default: false.
#     replication: false             # (Optional) Can replicate. Default: false.
#     encrypted_password: true       # (Optional) Encrypt password. Default: true.
#     inherit: true                  # (Optional) Inherit privileges. Default: true.
#     create_role: false             # (Optional) Can create roles. Default: false.
#     connection_limit: -1           # (Optional) Connection limit. Default: -1.
#     import: false                  # (Optional) Import existing user. Default: false.
#     connection_string_type: ""     # (Optional) jdbc, dotnet, odbc, gopq, node-pg, psycopg, rustpg.
#     hoop:
#       access_control: []           # (Optional) Access control groups.
variable "users" {
  description = "Map of PostgreSQL users — see inline docs for full YAML structure."
  type        = any
  default     = {}
}

## roles definition - YAML format
# roles:
#   <role_ref>:
#     name: "rolename"               # (Required) Name of the role.
#     grant: "owner"                 # (Required) Grant type: owner, readwrite, readonly.
#     db_ref: "db_ref"               # (Optional) Reference to databases key.
#     database_name: "dbname"        # (Optional) Database name when db_ref not set.
#     schema: "public"               # (Optional) Schema. Default: public.
#     create_database: false         # (Optional) Default: false.
#     replication: false             # (Optional) Default: false.
#     inherit: true                  # (Optional) Default: true.
#     create_role: false             # (Optional) Default: false.
#     connection_limit: -1           # (Optional) Default: -1.
#     import: false                  # (Optional) Default: false.
variable "roles" {
  description = "Map of PostgreSQL roles (no-login) — see inline docs for full YAML structure."
  type        = any
  default     = {}
}

## databases definition - YAML format
# databases:
#   <db_ref>:
#     name: "dbname"                 # (Required) Name of the database.
#     create_owner: false            # (Optional) Create a dedicated owner role. Default: false.
#     owner: "ownername"             # (Optional) Owner name when create_owner=false.
#     collate: "en_US.UTF-8"         # (Optional) Default: en_US.UTF-8.
#     ctype: "en_US.UTF-8"           # (Optional) Default: en_US.UTF-8.
#     connection_limit: -1           # (Optional) Default: -1.
#     is_template: false             # (Optional) Default: false.
#     template: "template0"          # (Optional) Default: template0.
#     encoding: "UTF8"               # (Optional) Default: UTF8.
#     allow_connections: true        # (Optional) Default: true.
#     alter_object_ownership: false  # (Optional) Default: false.
#     import: false                  # (Optional) Default: false.
#     schemas:
#       - name: "schema_name"        # (Required) Schema name.
#         owner: "schema_owner"      # (Optional) Owner of the schema.
#         reuse: true                # (Optional) Default: true.
#         cascade_on_delete: false   # (Optional) Default: false.
variable "databases" {
  description = "Map of PostgreSQL databases — see inline docs for full YAML structure."
  type        = any
  default     = {}
}

## hoop attributes - YAML format
# hoop:
#   enabled: false                   # (Optional) Enable hoop output. Default: false.
#   agent_id: "uuid"                 # (Required when enabled+enterprise) Hoop agent UUID.
#   community: true                  # (Optional) true=null (GCP SM no sub-key); false=enterprise. Default: true.
#   import: false                    # (Optional) Import existing connection. Default: false.
#   default_sslmode: "require"       # (Optional) Default: require.
#   tags: {}                         # (Optional) Tags map.
#   access_control: []               # (Optional) Access control groups.
variable "hoop" {
  description = "Hoop connection settings — see inline docs."
  type        = any
  default     = {}
}

## cloudsql connection attributes - YAML format
# cloudsql:
#   enabled: false                   # (Optional) Use Cloud SQL instance as connection source. Default: false.
#   instance_name: ""                # (Required when enabled) Cloud SQL instance name.
#   project_id: ""                   # (Optional) Override GCP project. Default: current project.
#   from_secret: false               # (Optional) Read credentials from GCP Secret Manager. Default: false.
#   secret_id: ""                    # (Required when from_secret=true) Secret Manager secret ID.
#   server_name: ""                  # (Optional) Override server_name used in hoop output and secret paths.
#   sslmode: "require"               # (Optional) SSL mode. Default: require.
#   superuser: false                 # (Optional) Is admin user a superuser. Default: false.
variable "cloudsql" {
  description = "Cloud SQL instance connection attributes — see inline docs."
  type        = any
  default     = {}
}

## direct connection attributes - YAML format
# direct:
#   server_name: "server"            # (Required) Server name identifier.
#   host: "localhost"                # (Required) Host.
#   port: 5432                       # (Required) Port.
#   username: "user"                 # (Required) Username.
#   password: "pass"                 # (Required) Password.
#   engine: "postgresql"             # (Optional) Default: postgresql.
#   db_name: "postgres"              # (Required) Default database name.
#   sslmode: "require"               # (Optional) Default: require.
#   superuser: false                 # (Optional) Default: false.
variable "direct" {
  description = "Direct connection attributes — see inline docs."
  type        = any
  default     = {}
}

# password_rotation_period: 90
variable "password_rotation_period" {
  description = "(Optional) Password rotation period in days. Default: 90."
  type        = number
  default     = 90
}

# force_reset: false
variable "force_reset" {
  description = "(Optional) Force reset all passwords. Default: false."
  type        = bool
  default     = false
}

# secrets_kms_key_name: ""
variable "secrets_kms_key_name" {
  description = "(Optional) GCP KMS key name to encrypt secrets at rest."
  type        = string
  default     = null
}
