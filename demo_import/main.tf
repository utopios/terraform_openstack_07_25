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

resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "My neutron security group"
}



import {
    to = openstack_networking_secgroup_v2.secgroup_1
    id = "7d1ac66b-42af-4534-814e-29ae809a9dfd"
}