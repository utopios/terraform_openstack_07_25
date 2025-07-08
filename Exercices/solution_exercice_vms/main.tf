
terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}

provider "local" {
  
}

provider "tls" {
  
}

provider "openstack" {}

variable "project_name" {
  default = "terraform-lab"
}

variable "vm_count" {
  default = 3
}

variable "volume_size" {
  default = 20
}


resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${var.project_name}-key.pem"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${var.project_name}-key.pub"
}


resource "openstack_images_image_v2" "ubuntu_image" {
}

resource "openstack_compute_flavor_v2" "custom_flavor" {

}


resource "openstack_compute_keypair_v2" "ssh_keypair" {

}

data "openstack_networking_network_v2" "external_network" {

}

resource "openstack_networking_network_v2" "private_network"  {

}
resource "openstack_networking_subnet_v2" "private_subnet" {

}

resource "openstack_networking_router_v2" "router" {

}

resource "openstack_networking_router_interface_v2" "router_interface"  {

}

resource "openstack_networking_secgroup_v2" "secgroup" {

}
resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {

}

resource "openstack_blockstorage_volume_v3" "volumes" {
}

resource "openstack_compute_instance_v2" "vms" {

}

resource "openstack_compute_volume_attach_v2" "volume_attachments" {
    
}