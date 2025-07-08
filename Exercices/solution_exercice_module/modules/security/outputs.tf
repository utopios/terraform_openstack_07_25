output "security_group_id" {
  description = "ID du groupe de sécurité"
  value       = openstack_networking_secgroup_v2.secgroup.id
}

output "security_group_name" {
  description = "Nom du groupe de sécurité"
  value       = openstack_networking_secgroup_v2.secgroup.name
}

output "security_rules_created" {
  description = "Règles de sécurité créées"
  value = {
    standard_rules = {
      for k, v in openstack_networking_secgroup_rule_v2.security_rules : k => {
        direction      = v.direction
        protocol       = v.protocol
        port_range_min = v.port_range_min
        port_range_max = v.port_range_max
        remote_ip      = v.remote_ip_prefix
      }
    }
    custom_port_rules = {
      for k, v in openstack_networking_secgroup_rule_v2.custom_port_rules : k => {
        port = v.port_range_min
      }
    }
  }
}

output "all_custom_ports" {
  description = "Liste de tous les ports personnalisés"
  value       = local.all_custom_ports
}