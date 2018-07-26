variable "db_name" {}

variable "db_port" {}

variable "db_host" {}

variable "vault_policies_config_dir" {}

variable "mysql_roles_config_dir" {}

variable "server_name" {}

variable "max_ttl" {}

variable "default_ttl" {}

variable "username" {}

variable "password" {}

variable "vault_policies" {
  type        = "list"
  description = "List of Vault Policies to create"
}

variable "mysql_roles" {
  type        = "list"
  description = "List of MySQL Roles to create"
}
