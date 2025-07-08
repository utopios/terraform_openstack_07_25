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

resource "openstack_blockstorage_volume_v3" "volumes" {
  for_each = var.vm_configurations
  
  name        = "${local.resource_prefix}-${each.key}-volume"
  size        = each.value.volume_size
  volume_type = each.value.volume_type
  description = "Storage volume for ${each.key} VM in ${var.project_name} ${var.environment}"
  
  metadata = merge(
    var.common_tags,
    {
      vm_name     = each.key
      volume_type = each.value.volume_type
      created_by  = "terraform-module-storage"
      environment = var.environment
      project     = var.project_name
    }
  )
}