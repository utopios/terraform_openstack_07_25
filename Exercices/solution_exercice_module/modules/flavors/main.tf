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

resource "openstack_compute_flavor_v2" "flavors" {
  for_each = var.flavors_config
  
  name        = "${local.resource_prefix}-${each.key}"
  ram         = each.value.ram
  vcpus       = each.value.vcpus
  disk        = each.value.disk
  swap        = each.value.swap
  extra_specs = merge(
    each.value.extra_specs,
    {
      "flavor_type" = each.key
      "created_by"  = "terraform-module-flavors"
    }
  )
}