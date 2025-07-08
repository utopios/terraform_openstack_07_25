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

  all_custom_ports = distinct(flatten([
    for vm_name, config in var.vm_configurations : config.custom_ports
  ]))
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${local.resource_prefix}-secgroup"
  description = "Security group for ${var.project_name} ${var.environment}"

  tags = [
    "${var.project_name}:${var.environment}",
    "module:security",
    "type:secgroup"
  ]
}

resource "openstack_networking_secgroup_rule_v2" "security_rules" {
  for_each = {
    for rule in var.security_rules : rule.name => rule
  }

  direction         = each.value.direction
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  port_range_min    = each.value.port_range_min == -1 ? null : each.value.port_range_min
  port_range_max    = each.value.port_range_max == -1 ? null : each.value.port_range_max
  remote_ip_prefix  = each.value.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.secgroup.id

  description = "Rule for ${each.value.name} - ${each.value.protocol}:${each.value.port_range_min}"
}

resource "openstack_networking_secgroup_rule_v2" "custom_port_rules" {
  for_each = toset([for port in local.all_custom_ports : tostring(port)])

  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = tonumber(each.value)
  port_range_max    = tonumber(each.value)
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id

  description = "Custom port ${each.value} for applications"
}

resource "openstack_networking_secgroup_rule_v2" "egress_all" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id

  description = "Allow all outbound traffic"
}