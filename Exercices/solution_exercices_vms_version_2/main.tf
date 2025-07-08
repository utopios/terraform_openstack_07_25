terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}

provider "openstack" {}
provider "tls" {}
provider "local" {}

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "terraform-advanced"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "dev"
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Environment = "dev"
    Project     = "openstack-lab"
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
    },
    large = {
      ram   = "8192"
      vcpus = "4"
      disk  = "80"
      swap  = "0"
      extra_specs = {
        "hw:cpu_policy" = "shared"
        "hw:numa_nodes" = "1"
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
    main = {
      algorithm = "RSA"
      rsa_bits  = 4096
    },
    backup = {
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
    web = {
      image_key          = "ubuntu22"
      flavor_key         = "small"
      ssh_key           = "main"
      volume_size        = 30
      volume_type        = "standard"
      assign_floating_ip = true
      user_data_template = "web_server"
      packages          = ["nginx", "certbot", "htop", "curl"]
      services          = ["nginx"]
      custom_ports      = [8080, 8443]
    },
    app = {
      image_key          = "ubuntu20"
      flavor_key         = "medium"
      ssh_key           = "main"
      volume_size        = 50
      volume_type        = "standard"
      assign_floating_ip = true
      user_data_template = "app_server"
      packages          = ["docker.io", "docker-compose", "nodejs", "npm"]
      services          = ["docker"]
      custom_ports      = [3000, 9000]
    },
    db = {
      image_key          = "centos8"
      flavor_key         = "large"
      ssh_key           = "backup"
      volume_size        = 100
      volume_type        = "ssd"
      assign_floating_ip = false
      user_data_template = "database"
      packages          = ["postgresql-server", "postgresql-contrib"]
      services          = ["postgresql"]
      custom_ports      = [5432]
    }
  }
}

variable "user_data_templates" {
  description = "Templates de scripts d'initialisation"
  type = map(string)
  default = {
    web_server = <<-EOF
      #!/bin/bash
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -y
      
    EOF
    
    app_server = <<-EOF
      #!/bin/bash
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -y
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
      apt-get update -y
      
      ufw --force enable
    EOF
    
    database = <<-EOF
      #!/bin/bash
      yum update -y
      
    EOF
  }
}

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
  
  vm_list = [for vm_name, config in var.vm_configurations : {
    name                = vm_name
    image_key           = config.image_key
    flavor_key          = config.flavor_key
    ssh_key             = config.ssh_key
    volume_size         = config.volume_size
    volume_type         = config.volume_type
    assign_floating_ip  = config.assign_floating_ip
    user_data_template  = config.user_data_template
    packages            = config.packages
    services            = config.services
    custom_ports        = config.custom_ports
  }]
  
  floating_ip_vms = [for vm in local.vm_list : vm if vm.assign_floating_ip]
  
  all_custom_ports = distinct(flatten([
    for vm in local.vm_list : vm.custom_ports
  ]))
}

resource "openstack_images_image_v2" "images" {
  for_each = var.images_config
  
  name             = "${local.resource_prefix}-${each.key}"
  image_source_url = each.value.source_url
  container_format = each.value.container_format
  disk_format      = each.value.disk_format
  min_disk_gb      = each.value.min_disk
  min_ram_mb       = each.value.min_ram
  web_download     = true
  verify_checksum  = true
  
  properties = merge(each.value.properties, var.common_tags, {
    image_type = each.key
  })
}

resource "openstack_compute_flavor_v2" "flavors" {
  for_each = var.flavors_config
  
  name       = "${local.resource_prefix}-${each.key}"
  ram        = each.value.ram
  vcpus      = each.value.vcpus
  disk       = each.value.disk
  swap       = each.value.swap
  extra_specs = each.value.extra_specs
}

resource "tls_private_key" "ssh_keys" {
  for_each = var.ssh_keys_config
  
  algorithm = each.value.algorithm
  rsa_bits  = each.value.rsa_bits
}

resource "local_file" "private_keys" {
  for_each = tls_private_key.ssh_keys
  
  content         = each.value.private_key_pem
  filename        = "${local.resource_prefix}-${each.key}-key.pem"
  file_permission = "0600"
}

resource "local_file" "public_keys" {
  for_each = tls_private_key.ssh_keys
  
  content  = each.value.public_key_openssh
  filename = "${local.resource_prefix}-${each.key}-key.pub"
}

resource "openstack_compute_keypair_v2" "ssh_keypairs" {
  for_each = tls_private_key.ssh_keys
  
  name       = "${local.resource_prefix}-${each.key}-keypair"
  public_key = each.value.public_key_openssh
}

data "openstack_networking_network_v2" "external_network" {
  name     = var.network_config.external_network
  external = true
}

resource "openstack_networking_network_v2" "private_network" {
  name           = "${local.resource_prefix}-network"
  admin_state_up = true
  
  tags = [for k, v in var.common_tags : "${k}:${v}"]
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "${local.resource_prefix}-subnet"
  network_id      = openstack_networking_network_v2.private_network.id
  cidr            = var.network_config.cidr
  ip_version      = 4
  dns_nameservers = var.network_config.dns_servers
  
  allocation_pool {
    start = var.network_config.allocation_start
    end   = var.network_config.allocation_end
  }
}

resource "openstack_networking_router_v2" "router" {
  name                = "${local.resource_prefix}-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${local.resource_prefix}-secgroup"
  description = "Security group for ${var.project_name}"
  
  tags = [for k, v in var.common_tags : "${k}:${v}"]
}

resource "openstack_networking_secgroup_rule_v2" "security_rules" {
  for_each = {
    for rule in var.security_rules : rule.name => rule
  }
  
  direction         = each.value.direction
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  port_range_min    = each.value.port_range_min == -1 ? null : each.value.port_range_min
  port_range_max    = each.value.port_range_max == -1 ? null : each.value.port_range_max
  remote_ip_prefix  = each.value.remote_ip_prefix
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "custom_port_rules" {
  for_each = toset([for port in local.all_custom_ports : tostring(port)])
  
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = tonumber(each.value)
  port_range_max    = tonumber(each.value)
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_blockstorage_volume_v3" "volumes" {
  for_each = {
    for vm in local.vm_list : vm.name => vm
  }
  
  name        = "${local.resource_prefix}-${each.key}-volume"
  size        = each.value.volume_size
  volume_type = each.value.volume_type
  
  metadata = merge(var.common_tags, {
    vm_name     = each.key
    volume_type = each.value.volume_type
  })
}

resource "openstack_networking_floatingip_v2" "floating_ips" {
  for_each = {
    for vm in local.floating_ip_vms : vm.name => vm
  }
  
  pool        = var.network_config.external_network
  description = "Floating IP for ${each.key}"
  
  tags = [for k, v in var.common_tags : "${k}:${v}"]
}

resource "openstack_compute_instance_v2" "vms" {
  for_each = {
    for vm in local.vm_list : vm.name => vm
  }
  
  name            = "${local.resource_prefix}-${each.key}"
  image_id        = openstack_images_image_v2.images[each.value.image_key].id
  flavor_id       = openstack_compute_flavor_v2.flavors[each.value.flavor_key].id
  key_pair        = openstack_compute_keypair_v2.ssh_keypairs[each.value.ssh_key].name
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]
  
  network {
    uuid = openstack_networking_network_v2.private_network.id
  }
  
  user_data = base64encode(templatefile("${path.module}/user_data_inline.tpl", {
    template_content = var.user_data_templates[each.value.user_data_template]
    vm_name         = each.key
    packages        = join(" ", each.value.packages)
    services        = each.value.services
    custom_ports    = each.value.custom_ports
  }))
  
  metadata = merge(var.common_tags, {
    vm_type     = each.key
    image_type  = each.value.image_key
    flavor_type = each.value.flavor_key
  })
  
  depends_on = [
    openstack_networking_subnet_v2.private_subnet,
    openstack_networking_router_interface_v2.router_interface
  ]
}

resource "local_file" "user_data_template" {
  content = <<-EOF
%{for vm_name, config in var.vm_configurations}
# Template for ${vm_name}
${templatestring(var.user_data_templates[config.user_data_template], {
  vm_name      = vm_name
  packages     = join(" ", config.packages)
  services     = config.services
  custom_ports = config.custom_ports
})}

%{endfor}
EOF
  filename = "user_data_inline.tpl"
}

resource "openstack_compute_volume_attach_v2" "volume_attachments" {
  for_each = openstack_compute_instance_v2.vms
  
  instance_id = each.value.id
  volume_id   = openstack_blockstorage_volume_v3.volumes[each.key].id
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip_associations" {
  for_each = {
    for vm in local.floating_ip_vms : vm.name => vm
  }
  
  floating_ip = openstack_networking_floatingip_v2.floating_ips[each.key].address
  instance_id = openstack_compute_instance_v2.vms[each.key].id
}

output "images_created" {
  description = "Images créées"
  value = {
    for k, v in openstack_images_image_v2.images : k => {
      id   = v.id
      name = v.name
      size = v.size_bytes
    }
  }
}

output "flavors_created" {
  description = "Flavors créés"
  value = {
    for k, v in openstack_compute_flavor_v2.flavors : k => {
      id    = v.id
      name  = v.name
      ram   = v.ram
      vcpus = v.vcpus
      disk  = v.disk
    }
  }
}

output "ssh_keys_info" {
  description = "Informations sur les clés SSH"
  value = {
    for k, v in openstack_compute_keypair_v2.ssh_keypairs : k => {
      name        = v.name
      fingerprint = v.fingerprint
      private_key_file = "${local.resource_prefix}-${k}-key.pem"
      public_key_file  = "${local.resource_prefix}-${k}-key.pub"
    }
  }
  sensitive = false
}

output "vm_details" {
  description = "Détails complets des VMs"
  value = {
    for k, v in openstack_compute_instance_v2.vms : k => {
      name           = v.name
      id             = v.id
      image_used     = var.vm_configurations[k].image_key
      flavor_used    = var.vm_configurations[k].flavor_key
      private_ip     = v.network[0].fixed_ip_v4
      floating_ip    = contains(keys(openstack_networking_floatingip_v2.floating_ips), k) ? openstack_networking_floatingip_v2.floating_ips[k].address : "none"
      volume_id      = openstack_blockstorage_volume_v3.volumes[k].id
      volume_size    = openstack_blockstorage_volume_v3.volumes[k].size
      ssh_key_used   = var.vm_configurations[k].ssh_key
      ssh_command    = contains(keys(openstack_networking_floatingip_v2.floating_ips), k) ? "ssh -i ${local.resource_prefix}-${var.vm_configurations[k].ssh_key}-key.pem ubuntu@${openstack_networking_floatingip_v2.floating_ips[k].address}" : "ssh via private network only"
      packages       = var.vm_configurations[k].packages
      custom_ports   = var.vm_configurations[k].custom_ports
    }
  }
}

output "network_summary" {
  description = "Résumé de l'infrastructure réseau"
  value = {
    network_name    = openstack_networking_network_v2.private_network.name
    subnet_cidr     = openstack_networking_subnet_v2.private_subnet.cidr
    router_name     = openstack_networking_router_v2.router.name
    security_group  = openstack_networking_secgroup_v2.secgroup.name
    dns_servers     = var.network_config.dns_servers
    floating_ips    = [for k, v in openstack_networking_floatingip_v2.floating_ips : v.address]
  }
}

output "deployment_summary" {
  description = "Résumé du déploiement"
  value = {
    project_name     = var.project_name
    environment      = var.environment
    total_vms        = length(var.vm_configurations)
    total_images     = length(var.images_config)
    total_flavors    = length(var.flavors_config)
    total_volumes    = length(openstack_blockstorage_volume_v3.volumes)
    total_floating_ips = length(openstack_networking_floatingip_v2.floating_ips)
    vm_types         = keys(var.vm_configurations)
  }
}