terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
  }
}

provider "openstack" {
    
}

module "simple_module" {
  source = "../simple_module"
  v1 = "Injection d'une valeur dans simple module (var v1)"
}

module "network" {
  source = "../network_module"
  network_name = "dev-network"
  subnet_name = "dev-subnet"
  cidr = "10.0.1.0/24"
}

output "network_info" {
  value = {
    network_id = module.network.network_id
    subnet_id = module.network.subnet_id
  }
}