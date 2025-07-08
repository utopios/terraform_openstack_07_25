variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "openstack-modular"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit être 'dev', 'staging' ou 'prod'."
  }
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Environment = "dev"
    Project     = "openstack-modular"
  }
}

variable "network_config" {
  description = "Configuration réseau"
  type = object({
    cidr                = string
    dns_servers         = list(string)
    allocation_start    = string
    allocation_end      = string
    external_network    = string
  })
  default = {
    cidr             = "10.0.1.0/24"
    dns_servers      = ["8.8.8.8", "8.8.4.4", "1.1.1.1"]
    allocation_start = "10.0.1.10"
    allocation_end   = "10.0.1.200"
    external_network = "external"
  }
}

variable "security_rules" {
  description = "Règles de sécurité"
  type = list(object({
    name             = string
    direction        = string
    protocol         = string
    port_range_min   = number
    port_range_max   = number
    remote_ip_prefix = string
  }))
  default = [
    {
      name             = "ssh"
      direction        = "ingress"
      protocol         = "tcp"
      port_range_min   = 22
      port_range_max   = 22
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      name             = "http"
      direction        = "ingress"
      protocol         = "tcp"
      port_range_min   = 80
      port_range_max   = 80
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      name             = "https"
      direction        = "ingress"
      protocol         = "tcp"
      port_range_min   = 443
      port_range_max   = 443
      remote_ip_prefix = "0.0.0.0/0"
    },
    {
      name             = "icmp"
      direction        = "ingress"
      protocol         = "icmp"
      port_range_min   = -1
      port_range_max   = -1
      remote_ip_prefix = "0.0.0.0/0"
    }
  ]
}

variable "images_config" {
  description = "Configuration des images à créer"
  type = map(object({
    source_url       = string
    container_format = string
    disk_format      = string
    min_disk         = number
    min_ram          = number
    properties       = map(string)
  }))
  default = {
    ubuntu22 = {
      source_url       = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
      container_format = "bare"
      disk_format      = "qcow2"
      min_disk         = 20
      min_ram          = 512
      properties = {
        os_type    = "linux"
        os_distro  = "ubuntu"
        os_version = "22.04"
      }
    },
    ubuntu20 = {
      source_url       = "https://cloud-images.ubuntu.com/releases/20.04/release/ubuntu-20.04-server-cloudimg-amd64.img"
      container_format = "bare"
      disk_format      = "qcow2"
      min_disk         = 20
      min_ram          = 512
      properties = {
        os_type    = "linux"
        os_distro  = "ubuntu"
        os_version = "20.04"
      }
    },
    centos8 = {
      source_url       = "https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220125.1.x86_64.qcow2"
      container_format = "bare"
      disk_format      = "qcow2"
      min_disk         = 20
      min_ram          = 512
      properties = {
        os_type    = "linux"
        os_distro  = "centos"
        os_version = "8"
      }
    }
  }
}

variable "flavors_config" {
  description = "Configuration des flavors à créer"
  type = map(object({
    ram         = string
    vcpus       = string
    disk        = string
    swap        = string
    extra_specs = map(string)
  }))
  default = {
    tiny = {
      ram   = "1024"
      vcpus = "1"
      disk  = "10"
      swap  = "0"
      extra_specs = {
        "hw:cpu_policy" = "shared"
      }
    },
    small = {
      ram   = "2048"
      vcpus = "2"
      disk  = "20"
      swap  = "0"
      extra_specs = {
        "hw:cpu_policy" = "shared"
      }
    },
    medium = {
      ram   = "4096"
      vcpus = "2"
      disk  = "40"
      swap  = "0"
      extra_specs = {
        "hw:cpu_policy" = "shared"
      }
    }
  }
}

variable "ssh_keys_config" {
  description = "Configuration des clés SSH"
  type = map(object({
    algorithm = string
    rsa_bits  = number
  }))
  default = {
    production = {
      algorithm = "RSA"
      rsa_bits  = 4096
    },
    development = {
      algorithm = "RSA"
      rsa_bits  = 2048
    }
  }
}

variable "vm_configurations" {
  description = "Configuration spécifique de chaque VM"
  type = map(object({
    image_key           = string
    flavor_key          = string
    ssh_key             = string
    volume_size         = number
    volume_type         = string
    assign_floating_ip  = bool
    user_data_template  = string
    packages            = list(string)
    services            = list(string)
    custom_ports        = list(number)
  }))
  default = {
    frontend = {
      image_key          = "ubuntu22"
      flavor_key         = "small"
      ssh_key           = "production"
      volume_size        = 30
      volume_type        = "standard"
      assign_floating_ip = true
      user_data_template = "web_server"
      packages          = ["nginx", "htop", "curl"]
      services          = ["nginx"]
      custom_ports      = [8080, 8443]
    },
    backend = {
      image_key          = "ubuntu20"
      flavor_key         = "medium"
      ssh_key           = "production"
      volume_size        = 50
      volume_type        = "standard"
      assign_floating_ip = true
      user_data_template = "app_server"
      packages          = ["docker.io", "nodejs", "npm"]
      services          = ["docker"]
      custom_ports      = [3000, 5000]
    },
    database = {
      image_key          = "centos8"
      flavor_key         = "medium"
      ssh_key           = "production"
      volume_size        = 100
      volume_type        = "standard"
      assign_floating_ip = false
      user_data_template = "database"
      packages          = ["postgresql-server"]
      services          = ["postgresql"]
      custom_ports      = [5432]
    }
  }
}