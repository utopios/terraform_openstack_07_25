


provider "openstack" {
    
}

resource "openstack_networking_network_v2" "network" {
  name           = var.network_name
  admin_state_up = var.admin_state_up
  shared         = var.shared
  tags           = var.tags
}
resource "openstack_networking_subnet_v2" "subnet" {
  name            = var.subnet_name
  network_id      = openstack_networking_network_v2.network.id
  cidr            = var.cidr
  tags            = var.tags
}