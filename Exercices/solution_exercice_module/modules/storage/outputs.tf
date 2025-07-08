output "volumes_map" {
  description = "Map des volumes créés"
  value = {
    for k, v in openstack_blockstorage_volume_v3.volumes : k => {
      id   = v.id
      name = v.name
      size = v.size
      type = v.volume_type
    }
  }
}

output "volumes_ids" {
  description = "IDs des volumes créés"
  value = {
    for k, v in openstack_blockstorage_volume_v3.volumes : k => v.id
  }
}

output "volumes_details" {
  description = "Détails complets des volumes"
  value = openstack_blockstorage_volume_v3.volumes
}

output "total_storage_size" {
  description = "Taille totale de stockage allouée"
  value = sum([
    for v in openstack_blockstorage_volume_v3.volumes : v.size
  ])
}