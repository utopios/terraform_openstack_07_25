# storage-module/outputs.tf

output "volume_id" {
  description = "ID du volume principal"
  value       = openstack_blockstorage_volume_v3.main_volume.id
}

output "volume_name" {
  description = "Nom du volume principal"
  value       = openstack_blockstorage_volume_v3.main_volume.name
}

output "volume_size" {
  description = "Taille du volume principal"
  value       = openstack_blockstorage_volume_v3.main_volume.size
}

output "snapshot_id" {
  description = "ID du snapshot (null si non créé)"
  value       = var.create_snapshot ? openstack_blockstorage_volume_v3.snapshot[0].id : null
}

output "snapshot_name" {
  description = "Nom du snapshot (null si non créé)"
  value       = var.create_snapshot ? openstack_blockstorage_volume_v3.snapshot[0].name : null
}

output "backup_volume_id" {
  description = "ID du volume de sauvegarde (null si non créé)"
  value       = var.create_snapshot && var.backup_volume_size != null ? openstack_blockstorage_volume_v3.backup_volume[0].id : null
}

output "backup_volume_name" {
  description = "Nom du volume de sauvegarde (null si non créé)"
  value       = var.create_snapshot && var.backup_volume_size != null ? openstack_blockstorage_volume_v3.backup_volume[0].name : null
}

output "all_volume_info" {
  description = "Informations complètes sur tous les volumes créés"
  value = {
    main_volume = {
      id   = openstack_blockstorage_volume_v3.main_volume.id
      name = openstack_blockstorage_volume_v3.main_volume.name
      size = openstack_blockstorage_volume_v3.main_volume.size
    }
    snapshot = var.create_snapshot ? {
      id   = openstack_blockstorage_volume_v3.snapshot[0].id
      name = openstack_blockstorage_volume_v3.snapshot[0].name
    } : null
    backup_volume = var.create_snapshot && var.backup_volume_size != null ? {
      id   = openstack_blockstorage_volume_v3.backup_volume[0].id
      name = openstack_blockstorage_volume_v3.backup_volume[0].name
      size = openstack_blockstorage_volume_v3.backup_volume[0].size
    } : null
  }
}
