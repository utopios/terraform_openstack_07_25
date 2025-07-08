output "network_id" {
  description = "ID du réseau privé"
  value       = openstack_networking_network_v2.private_network.id
}

output "network_name" {
  description = "Nom du réseau privé"
  value       = openstack_networking_network_v2.private_network.name
}

output "subnet_id" {
  description = "ID du sous-réseau"
  value       = openstack_networking_subnet_v2.private_subnet.id
}

output "subnet_cidr" {
  description = "CIDR du sous-réseau"
  value       = openstack_networking_subnet_v2.private_subnet.cidr
}

output "router_id" {
  description = "ID du routeur"
  value       = openstack_networking_router_v2.router.id
}

output "router_name" {
  description = "Nom du routeur"
  value       = openstack_networking_router_v2.router.name
}

output "external_network_id" {
  description = "ID du réseau externe"
  value       = data.openstack_networking_network_v2.external_network.id
}

output "network_details" {
  description = "Détails complets du réseau"
  value = {
    network = {
      id   = openstack_networking_network_v2.private_network.id
      name = openstack_networking_network_v2.private_network.name
    }
    subnet = {
      id   = openstack_networking_subnet_v2.private_subnet.id
      cidr = openstack_networking_subnet_v2.private_subnet.cidr
    }
    router = {
      id   = openstack_networking_router_v2.router.id
      name = openstack_networking_router_v2.router.name
    }
  }
}