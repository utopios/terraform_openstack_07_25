output "flavors_map" {
  description = "Map des flavors créés"
  value = {
    for k, v in openstack_compute_flavor_v2.flavors : k => {
      id    = v.id
      name  = v.name
      ram   = v.ram
      vcpus = v.vcpus
      disk  = v.disk
    }
  }
}

output "flavors_ids" {
  description = "Liste des IDs des flavors"
  value = {
    for k, v in openstack_compute_flavor_v2.flavors : k => v.id
  }
}

output "flavors_details" {
  description = "Détails complets des flavors"
  value = openstack_compute_flavor_v2.flavors
}