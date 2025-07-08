output "instances_map" {
  description = "Map des instances créées"
  value = {
    for k, v in openstack_compute_instance_v2.instances : k => {
      id         = v.id
      name       = v.name
      private_ip = v.network[0].fixed_ip_v4
    }
  }
}

output "instances_ids" {
  description = "IDs des instances créées"
  value = {
    for k, v in openstack_compute_instance_v2.instances : k => v.id
  }
}

output "instances_private_ips" {
  description = "IPs privées des instances"
  value = {
    for k, v in openstack_compute_instance_v2.instances : k => v.network[0].fixed_ip_v4
  }
}

output "instances_details" {
  description = "Détails complets des instances"
  value = openstack_compute_instance_v2.instances
}

output "volume_attachments" {
  description = "Détails des attachements de volumes"
  value = {
    for k, v in openstack_compute_volume_attach_v2.volume_attachments : k => {
      instance_id = v.instance_id
      volume_id   = v.volume_id
      device      = v.device
    }
  }
}