output "deployment_summary" {
  description = "Résumé du déploiement"
  value = {
    project_name       = var.project_name
    environment        = var.environment
    total_vms          = length(var.vm_configurations)
    total_images       = length(var.images_config)
    total_flavors      = length(var.flavors_config)
    total_ssh_keys     = length(var.ssh_keys_config)
    vm_types           = keys(var.vm_configurations)
    floating_ips_count = length(module.floating_ips.floating_ips_addresses)
  }
}

output "images_created" {
  description = "Images créées par le module images"
  value       = module.images.images_map
}

output "flavors_created" {
  description = "Flavors créés par le module flavors"
  value       = module.flavors.flavors_map
}

output "ssh_keys_info" {
  description = "Informations sur les clés SSH créées"
  value       = module.ssh_keys.ssh_keys_info
}

output "network_details" {
  description = "Détails du réseau créé"
  value       = module.networking.network_details
}

output "security_info" {
  description = "Informations sur la sécurité"
  value = {
    security_group_name = module.security.security_group_name
    security_group_id   = module.security.security_group_id
    custom_ports        = module.security.all_custom_ports
    rules_created       = module.security.security_rules_created
  }
}

output "storage_summary" {
  description = "Résumé du stockage"
  value = {
    volumes_created    = module.storage.volumes_map
    total_storage_size = module.storage.total_storage_size
  }
}

output "vm_details" {
  description = "Détails complets des VMs"
  value = {
    for vm_name, config in var.vm_configurations : vm_name => {
      name         = module.compute.instances_map[vm_name].name
      id           = module.compute.instances_map[vm_name].id
      private_ip   = module.compute.instances_map[vm_name].private_ip
      floating_ip  = config.assign_floating_ip ? module.floating_ips.floating_ips_addresses[vm_name] : "none"
      image_used   = config.image_key
      flavor_used  = config.flavor_key
      ssh_key_used = config.ssh_key
      volume_size  = config.volume_size
      volume_id    = module.storage.volumes_map[vm_name].id
      packages     = config.packages
      services     = config.services
      custom_ports = config.custom_ports
      ssh_command  = config.assign_floating_ip ? "ssh -i ${var.project_name}-${var.environment}-${config.ssh_key}-key.pem ubuntu@${module.floating_ips.floating_ips_addresses[vm_name]}" : "ssh via private network only"
    }
  }
}

output "floating_ips_summary" {
  description = "Résumé des IPs flottantes"
  value = {
    addresses    = module.floating_ips.floating_ips_addresses
    associations = module.floating_ips.floating_ip_associations
    total_count  = length(module.floating_ips.floating_ips_list)
  }
}

output "ssh_connection_commands" {
  description = "Commandes de connexion SSH pour chaque VM"
  value = {
    for vm_name, config in var.vm_configurations : vm_name => {
      command  = config.assign_floating_ip ? "ssh -i ${var.project_name}-${var.environment}-${config.ssh_key}-key.pem ubuntu@${module.floating_ips.floating_ips_addresses[vm_name]}" : "Connection via private network: ssh -i ${var.project_name}-${var.environment}-${config.ssh_key}-key.pem ubuntu@${module.compute.instances_map[vm_name].private_ip}"
      key_file = "${var.project_name}-${var.environment}-${config.ssh_key}-key.pem"
      ip_type  = config.assign_floating_ip ? "floating" : "private"
    }
  }
}

output "service_endpoints" {
  description = "Points d'accès aux services déployés"
  value = {
    for vm_name, config in var.vm_configurations : vm_name => {
      base_url = config.assign_floating_ip ? "http://${module.floating_ips.floating_ips_addresses[vm_name]}" : "http://${module.compute.instances_map[vm_name].private_ip}"
      endpoints = [
        for port in config.custom_ports : "${config.assign_floating_ip ? module.floating_ips.floating_ips_addresses[vm_name] : module.compute.instances_map[vm_name].private_ip}:${port}"
      ]
      access_type = config.assign_floating_ip ? "public" : "private"
    }
  }
}