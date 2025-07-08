# storage-module/main.tf

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.0"
    }
  }
}

# Volume principal
resource "openstack_blockstorage_volume_v3" "main_volume" {
  name              = var.volume_name
  size              = var.volume_size
  volume_type       = var.volume_type
  availability_zone = var.availability_zone

  metadata = merge(
    var.tags,
    {
      "managed_by" = "terraform"
      "module"     = "storage-module"
    }
  )

  lifecycle {
    prevent_destroy = true
  }
}

# Snapshot du volume principal (conditionnel)
resource "openstack_blockstorage_volume_v3" "snapshot" {
  count = var.create_snapshot ? 1 : 0

  name        = "${var.volume_name}-snapshot"
  description = "Snapshot automatique du volume ${var.volume_name}"
  source_vol_id = openstack_blockstorage_volume_v3.main_volume.id

  metadata = merge(
    var.tags,
    {
      "managed_by"    = "terraform"
      "module"        = "storage-module"
      "snapshot_of"   = var.volume_name
      "creation_date" = timestamp()
    }
  )

  lifecycle {
    ignore_changes = [metadata["creation_date"]]
  }
}

# Volume de sauvegarde depuis le snapshot (conditionnel)
resource "openstack_blockstorage_volume_v3" "backup_volume" {
  count = var.create_snapshot && var.backup_volume_size != null ? 1 : 0

  name        = "${var.volume_name}-backup"
  size        = var.backup_volume_size
  source_vol_id = openstack_blockstorage_volume_v3.snapshot[0].id

  metadata = merge(
    var.tags,
    {
      "managed_by"  = "terraform"
      "module"      = "storage-module"
      "backup_of"   = var.volume_name
      "backup_date" = timestamp()
    }
  )

  lifecycle {
    ignore_changes = [metadata["backup_date"]]
  }

  depends_on = [openstack_blockstorage_volume_v3.snapshot]
}
