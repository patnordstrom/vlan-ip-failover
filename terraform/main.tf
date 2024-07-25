resource "random_password" "root_pass" {
  length  = 30
  special = true
}

resource "linode_instance" "ha_nodes" {
  for_each         = var.ha_node_labels
  label            = each.key
  region           = var.region
  image            = var.image_name
  type             = var.image_type
  root_pass        = random_password.root_pass.result
  authorized_users = var.authorized_users
  metadata {
    user_data = filebase64("../cloud-init/ha-server-config.yaml")
  }

  interface {
    purpose = "public"
    primary = true
  }

  interface {
    purpose      = "vlan"
    label        = var.vlan_name
    ipam_address = lookup(var.node_vlan_ips, each.key)
  }

}

resource "linode_instance" "test_client_node" {
  region           = var.region
  label            = var.test_client_node_label
  image            = var.image_name
  type             = var.image_type
  root_pass        = random_password.root_pass.result
  authorized_users = var.authorized_users
  metadata {
    user_data = filebase64("../cloud-init/test-client-config.yaml")
  }

  interface {
    purpose = "public"
    primary = true
  }

  interface {
    purpose      = "vlan"
    label        = var.vlan_name
    ipam_address = lookup(var.node_vlan_ips, var.test_client_node_label)
  }

}

resource "linode_firewall" "vlan-ip-failover-test" {
  label = "vlan-ip-failover-test"

  inbound_policy = "DROP"
  inbound {
    label    = "allow-ssh-from-my-computer"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = var.allowed_ssh_user_ips
  }
  outbound_policy = "ACCEPT"

  linodes = concat([for item in linode_instance.ha_nodes : item.id],[linode_instance.test_client_node.id])
}