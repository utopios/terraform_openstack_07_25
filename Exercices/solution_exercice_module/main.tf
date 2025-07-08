terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
  }
}

provider "openstack" {}

module "images" {
  source = "./modules/images"
  
  project_name    = var.project_name
  environment     = var.environment
  images_config   = var.images_config
  common_tags     = var.common_tags
}

module "flavors" {
  source = "./modules/flavors"
  
  project_name    = var.project_name
  environment     = var.environment
  flavors_config  = var.flavors_config
  common_tags     = var.common_tags
}

module "ssh_keys" {
  source = "./modules/ssh-keys"
  
  project_name      = var.project_name
  environment       = var.environment
  ssh_keys_config   = var.ssh_keys_config
  common_tags       = var.common_tags
}

module "networking" {
  source = "./modules/networking"
  
  project_name     = var.project_name
  environment      = var.environment
  network_config   = var.network_config
  common_tags      = var.common_tags
}

module "security" {
  source = "./modules/security"
  
  project_name        = var.project_name
  environment         = var.environment
  network_id          = module.networking.network_id
  security_rules      = var.security_rules
  vm_configurations   = var.vm_configurations
  common_tags         = var.common_tags
}

module "storage" {
  source = "./modules/storage"
  
  project_name      = var.project_name
  environment       = var.environment
  vm_configurations = var.vm_configurations
  common_tags       = var.common_tags
}

module "compute" {
  source = "./modules/compute"
  
  project_name      = var.project_name
  environment       = var.environment
  vm_configurations = var.vm_configurations
  
  images_map        = module.images.images_map
  flavors_map       = module.flavors.flavors_map
  ssh_keypairs_map  = module.ssh_keys.ssh_keypairs_map
  network_id        = module.networking.network_id
  security_group_id = module.security.security_group_id
  volumes_map       = module.storage.volumes_map
  
  common_tags       = var.common_tags
  
  depends_on = [
    module.networking,
    module.security,
    module.storage
  ]
}

module "floating_ips" {
  source = "./modules/floating-ips"
  
  project_name      = var.project_name
  environment       = var.environment
  vm_configurations = var.vm_configurations
  network_config    = var.network_config
  
  instances_map     = module.compute.instances_map
  
  common_tags       = var.common_tags
  
  depends_on = [
    module.compute
  ]
}