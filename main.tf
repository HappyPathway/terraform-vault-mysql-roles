resource "vault_mount" "db" {
  path                      = "db-${var.server_name}"
  type                      = "database"
  max_lease_ttl_seconds     = "${var.max_ttl}"
  default_lease_ttl_seconds = "${var.default_ttl}"
}

data "template_file" "vault_backend_connection" {
  template = "${file("${path.module}/database_connection.json.tpl")}"

  vars = {
    db_port        = "${var.db_port}"
    db_host        = "${var.db_host}"
    db_name        = "${var.db_name}"
    username       = "${var.username}"
    password       = "${var.password}"
    db_server_name = "${var.server_name}"
  }
}

resource "vault_database_secret_backend_connection" "mysql" {
  backend       = "${vault_mount.db.path}"
  name          = "${var.db_name}"
  allowed_roles = "${var.mysql_roles}"

  mysql {
    connection_url = "${var.username}@${var.server_name}:${var.password}@tcp(${var.db_host}:3306)/${var.db_name}"
  }
}

data "template_file" "vault_policies" {
  count    = "${length(var.vault_policies)}"
  template = "${file("${var.vault_policies_config_dir}/${element(var.vault_policies, count.index)}.hcl.tpl")}"

  vars {
    db_name = "${var.db_name}"
  }
}

data "template_file" "mysql_roles" {
  count    = "${length(var.mysql_roles)}"
  template = "${file("${var.mysql_roles_config_dir}/${element(var.mysql_roles, count.index)}.hcl.tpl")}"

  vars {
    db_name = "${var.db_name}"
  }
}

resource "vault_policy" "mysql_roles" {
  count = "${length(var.mysql_roles)}"

  # name   = "${var.db_name}-mysql_crud"
  policy = "${element(data.template_file.mysql_roles.*.rendered, count.index)}"
}

resource "vault_database_secret_backend_role" "mysql_roles" {
  count               = "${length(var.mysql_roles)}"
  backend             = "${vault_mount.db.path}"
  name                = "${element(var.mysql_roles, count.index)}"
  db_name             = "${var.db_name}"
  creation_statements = "${element(data.template_file.mysql_roles.*.rendered, count.index)}"
  default_ttl         = "${var.default_ttl}"
  max_ttl             = "${var.max_ttl}"
}
