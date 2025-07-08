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
  region = "RegionOne"
  insecure = true
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

