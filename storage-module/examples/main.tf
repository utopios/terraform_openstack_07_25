# examples/main.tf

terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.0"
    }
  }
}

# Configuration du provider OpenStack
provider "openstack" {
  # Les variables d'environnement OS_* doivent être définies
  # ou utiliser un fichier clouds.yaml
}

# Variables locales pour la configuration
locals {
  environment = "dev"
  project     = "mon-projet"
  
  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
  }
}

# 1. Volume "app-data" de 30GB avec snapshot
module "app_data_volume" {
  source = "../"  # Chemin vers le module storage-module

  volume_name     = "${local.project}-app-data-${local.environment}"
  volume_size     = 30
  create_snapshot = true
  
  tags = merge(local.common_tags, {
    Component = "application"
    Usage     = "data-storage"
  })
}

# 2. Volume "logs" de 10GB sans snapshot
module "logs_volume" {
  source = "../"

  volume_name     = "${local.project}-logs-${local.environment}"
  volume_size     = 10
  create_snapshot = false
  
  tags = merge(local.common_tags, {
    Component = "logging"
    Usage     = "log-storage"
  })
}

# 3. Volume "database" de 50GB avec snapshot et volume de sauvegarde
module "database_volume" {
  source = "../"

  volume_name        = "${local.project}-database-${local.environment}"
  volume_size        = 50
  create_snapshot    = true
  backup_volume_size = 60  # Légèrement plus grand pour permettre la croissance
  
  tags = merge(local.common_tags, {
    Component    = "database"
    Usage        = "database-storage"
    CriticalData = "true"
  })
}

# Outputs pour récupérer les informations des volumes créés
output "app_data_info" {
  description = "Informations du volume app-data"
  value       = module.app_data_volume.all_volume_info
}

output "logs_info" {
  description = "Informations du volume logs"
  value       = module.logs_volume.all_volume_info
}

output "database_info" {
  description = "Informations du volume database"
  value       = module.database_volume.all_volume_info
}

output "volume_summary" {
  description = "Résumé de tous les volumes créés"
  value = {
    app_data = {
      volume_id = module.app_data_volume.volume_id
      snapshot_id = module.app_data_volume.snapshot_id
    }
    logs = {
      volume_id = module.logs_volume.volume_id
    }
    database = {
      volume_id = module.database_volume.volume_id
      snapshot_id = module.database_volume.snapshot_id
      backup_volume_id = module.database_volume.backup_volume_id
    }
  }
}
