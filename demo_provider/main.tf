terraform {
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

variable "password_openstack" {
  type = string
  sensitive = true
}

variable "user_openstack" {
  type = string
  sensitive = true
}

variable "tenant_name" {
  type = string
  sensitive = true
}

variable "url_cloud" {
  type = string
}

provider "openstack" {
  user_name = var.user_openstack
  tenant_name = "demo"
  password = var.tenant_name
  auth_url = var.url_cloud
  region = "microstack"
}

resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.199.0/24"
  ip_version = 4
}

resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "a security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_port_v2" "port_1" {
  name               = "port_1"
  network_id         = openstack_networking_network_v2.network_1.id
  admin_state_up     = "true"
  security_group_ids = [openstack_networking_secgroup_v2.secgroup_1.id]

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_1.id
    ip_address = "192.168.199.10"
  }
}

resource "openstack_compute_instance_v2" "instance_1" {
  name            = "instance_1"
  security_groups = [openstack_networking_secgroup_v2.secgroup_1.name]

  network {
    port = openstack_networking_port_v2.port_1.id
  }
}