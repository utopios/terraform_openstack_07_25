output "images_map" {
  description = "Map des images créées"
  value = {
    for k, v in openstack_images_image_v2.images : k => {
      id   = v.id
      name = v.name
      size = v.size_bytes
    }
  }
}

output "images_ids" {
  description = "Liste des IDs des images"
  value = {
    for k, v in openstack_images_image_v2.images : k => v.id
  }
}

output "images_details" {
  description = "Détails complets des images"
  value = openstack_images_image_v2.images
}