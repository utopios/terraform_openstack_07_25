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

resource "openstack_images_image_v2" "images" {
  for_each = var.images_config
  
  name             = "${local.resource_prefix}-${each.key}"
  image_source_url = each.value.source_url
  container_format = each.value.container_format
  disk_format      = each.value.disk_format
  min_disk_gb      = each.value.min_disk
  min_ram_mb       = each.value.min_ram
  web_download     = true
  verify_checksum  = true
  
  properties = merge(
    each.value.properties,
    var.common_tags,
    {
      image_type = each.key
      created_by = "terraform-module-images"
    }
  )
  
  tags = [
    "${var.project_name}:${var.environment}",
    "module:images",
    "image_type:${each.key}"
  ]
}