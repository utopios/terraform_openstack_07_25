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

data "openstack_images_image_v2" "ubuntu" {
  name        = var.image_name
  most_recent = true
}

resource "openstack_compute_flavor_v2" "test-flavor" {
  name  = "my-flavor"
  ram   = "8096"
  vcpus = "2"
  disk  = "20"

  extra_specs = {
    "hw:cpu_policy"        = "CPU-POLICY",
    "hw:cpu_thread_policy" = "CPU-THREAD-POLICY"
  }
}

resource "openstack_compute_keypair_v2" "test-keypair" {
  name = "my-keypair"
}

resource "openstack_compute_instance_v2" "example" {
  name = "example-instance"
  image_id = openstack_images_image_v2.ubuntu.id
  flavor_id = openstack_compute_flavor_v2.test-flavor.id
  key_pair = openstack_compute_keypair_v2.test-keypair.name
  security_groups = ["default", "example_security_group"]
  network {
    uuid = openstack_networking_network_v2.network_1.id
  }
}

## Utilisation des éléments exportés
output "display_network_tenant_id" {
  value = openstack_networking_network_v2.network_1.tenant_id
}

