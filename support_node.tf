
resource "macaddress" "k3s-support" {}

locals {
  support_node_ip = cidrhost(var.control_plane_subnet, 0)
}

locals {
  lan_subnet_cidr_bitnum = split("/", var.lan_subnet)[1]
}

resource "random_password" "support-db-password" {
  length           = 16
  special          = false
  override_special = "_%@"
}

resource "random_password" "k3s-master-db-password" {
  length           = 16
  special          = false
  override_special = "_%@"
}

resource "local_file" "k3s_nginx_config" {
  depends_on = [
    random_password.k3s-master-db-password
  ]
  content = templatefile("${path.module}/config/nginx.conf.tftpl", {
    k3s_server_hosts = [for ip in local.master_node_ips :
    "${ip}:6443"
    ]
    k3s_nodes = concat(local.master_node_ips, [
    for node in local.listed_worker_nodes :
    node.ip
    ])
  })
  filename = "${path.module}/config/nginx.cfg"
}
