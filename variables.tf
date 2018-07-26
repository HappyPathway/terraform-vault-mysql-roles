variable "db_name" {}

variable "vault_backend" {}

variable "db_host" {}

variable "vault_policies_config_dir" {}

variable "mysql_roles_config_dir" {}

variable "server_name" {}

variable "max_ttl" {}

variable "default_ttl" {}

variable "vault_cluster" {}

variable "vault_token" {}

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
