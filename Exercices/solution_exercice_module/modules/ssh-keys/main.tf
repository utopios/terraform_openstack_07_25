terraform {
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

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

resource "tls_private_key" "ssh_keys" {
  for_each = var.ssh_keys_config

  algorithm = each.value.algorithm
  rsa_bits  = each.value.algorithm == "RSA" ? each.value.rsa_bits : null
}

resource "local_file" "private_keys" {
  for_each = tls_private_key.ssh_keys

  content         = each.value.private_key_pem
  filename        = "${local.resource_prefix}-${each.key}-key.pem"
  file_permission = "0600"
}

resource "local_file" "public_keys" {
  for_each = tls_private_key.ssh_keys

  content  = each.value.public_key_openssh
  filename = "${local.resource_prefix}-${each.key}-key.pub"
}

resource "openstack_compute_keypair_v2" "ssh_keypairs" {
  for_each = tls_private_key.ssh_keys

  name       = "${local.resource_prefix}-${each.key}-keypair"
  public_key = each.value.public_key_openssh
}