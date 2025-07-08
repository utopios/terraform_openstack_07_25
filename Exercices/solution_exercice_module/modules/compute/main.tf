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

  user_data_templates = {
    web_server        = templatefile("${path.module}/user_data/web_server.tpl", {})
    app_server        = templatefile("${path.module}/user_data/app_server.tpl", {})
    database          = templatefile("${path.module}/user_data/database.tpl", {})
    monitoring_server = templatefile("${path.module}/user_data/monitoring.tpl", {})
    cache_server      = templatefile("${path.module}/user_data/cache_server.tpl", {})
  }
}

resource "openstack_compute_instance_v2" "instances" {
  for_each = var.vm_configurations

  name            = "${local.resource_prefix}-${each.key}"
  image_id        = var.images_map[each.value.image_key].id
  flavor_id       = var.flavors_map[each.value.flavor_key].id
  key_pair        = var.ssh_keypairs_map[each.value.ssh_key].name
  security_groups = [var.security_group_name]

  network {
    uuid = var.network_id
  }

  user_data = base64encode(templatestring(
    local.user_data_templates[each.value.user_data_template],
    {
      vm_name      = each.key
      packages     = join(" ", each.value.packages)
      services     = each.value.services
      custom_ports = each.value.custom_ports
      environment  = var.environment
      project_name = var.project_name
    }
  ))

  metadata = merge(
    var.common_tags,
    {
      vm_type     = each.key
      image_type  = each.value.image_key
      flavor_type = each.value.flavor_key
      ssh_key     = each.value.ssh_key
      created_by  = "terraform-module-compute"
      environment = var.environment
      project     = var.project_name
    }
  )

  tags = [
    "${var.project_name}:${var.environment}",
    "module:compute",
    "vm_type:${each.key}"
  ]
}

resource "openstack_compute_volume_attach_v2" "volume_attachments" {
  for_each = var.vm_configurations

  instance_id = openstack_compute_instance_v2.instances[each.key].id
  volume_id   = var.volumes_map[each.key].id

  depends_on = [
    openstack_compute_instance_v2.instances
  ]
}