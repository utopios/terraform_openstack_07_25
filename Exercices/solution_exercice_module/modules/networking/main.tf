terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
  }
}

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
}

data "openstack_networking_network_v2" "external_network" {
  name     = var.network_config.external_network
  external = true
}

resource "openstack_networking_network_v2" "private_network" {
  name           = "${local.resource_prefix}-network"
  admin_state_up = true
  description    = "Private network for ${var.project_name} ${var.environment}"
  
  tags = [
    "${var.project_name}:${var.environment}",
    "module:networking",
    "type:private"
  ]
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "${local.resource_prefix}-subnet"
  network_id      = openstack_networking_network_v2.private_network.id
  cidr            = var.network_config.cidr
  ip_version      = 4
  dns_nameservers = var.network_config.dns_servers
  description     = "Private subnet for ${var.project_name} ${var.environment}"
  
  allocation_pool {
    start = var.network_config.allocation_start
    end   = var.network_config.allocation_end
  }
  
  host_routes {
    destination_cidr = "169.254.169.254/32"
    next_hop         = cidrhost(var.network_config.cidr, 1)
  }
}

resource "openstack_networking_router_v2" "router" {
  name                = "${local.resource_prefix}-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external_network.id
  description         = "Router for ${var.project_name} ${var.environment}"
  
  tags = [
    "${var.project_name}:${var.environment}",
    "module:networking",
    "type:router"
  ]
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}