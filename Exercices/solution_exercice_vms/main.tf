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

provider "openstack" {
    
}
provider "tls" {}
provider "local" {}

variable "project_name" {
  default = "terraform-lab"
}

variable "vm_count" {
  default = 3
}

variable "volume_size" {
  default = 20
}

resource "openstack_images_image_v2" "ubuntu_image" {
  name             = "${var.project_name}-ubuntu-22-04"
  image_source_url = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
  #web_download     = true
  verify_checksum  = true
  
  properties = {
    os_type    = "linux"
    os_distro  = "ubuntu"
    os_version = "22.04"
  }
}

resource "openstack_compute_flavor_v2" "custom_flavor" {
  name  = "${var.project_name}-flavor"
  ram   = "2048"
  vcpus = "2"
  disk  = "20"
  
  extra_specs = {
    "hw:cpu_policy" = "shared"
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${var.project_name}-key.pem"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${var.project_name}-key.pub"
}

resource "openstack_compute_keypair_v2" "ssh_keypair" {
  name       = "${var.project_name}-keypair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# data "openstack_networking_network_v2" "external_network" {
#   name     = "external"
#   external = true
# }

resource "openstack_networking_network_v2" "private_network" {
  name           = "${var.project_name}-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name       = "${var.project_name}-subnet"
  network_id = openstack_networking_network_v2.private_network.id
  cidr       = "10.0.1.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
  
  allocation_pool {
    start = "10.0.1.10"
    end   = "10.0.1.200"
  }
}

# resource "openstack_networking_router_v2" "router" {
#   name                = "${var.project_name}-router"
#   admin_state_up      = true
#   external_network_id = data.openstack_networking_network_v2.external_network.id
# }

# resource "openstack_networking_router_interface_v2" "router_interface" {
#   router_id = openstack_networking_router_v2.router.id
#   subnet_id = openstack_networking_subnet_v2.private_subnet.id
# }

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "${var.project_name}-secgroup"
  description = "Security group for VMs"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "https_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "icmp_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup.id
}

resource "openstack_blockstorage_volume_v3" "volumes" {
  count = var.vm_count
  
  name = "${var.project_name}-volume-${count.index + 1}"
  size = var.volume_size
}

# resource "openstack_networking_floatingip_v2" "floating_ips" {
#   count = var.vm_count
  
#   pool = "external"
# }

resource "openstack_compute_instance_v2" "vms" {
  count = var.vm_count
  
  name            = "${terraform.workspace}-${var.project_name}-vm-${count.index + 1}"
  image_id        = openstack_images_image_v2.ubuntu_image.id
  flavor_id       = openstack_compute_flavor_v2.custom_flavor.id
  key_pair        = openstack_compute_keypair_v2.ssh_keypair.name
  security_groups = [openstack_networking_secgroup_v2.secgroup.name]
  
  network {
    uuid = openstack_networking_network_v2.private_network.id
  }

  provisioner "remote-exec" {
    inline = [ "apt update" ]
  }

  provisioner "local-exec" {
    command = "echo Machine créée"
  }

  provisioner "file" {
    source = "file.txt"
    destination = "file.txt"
  }
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx htop curl
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>VM ${count.index + 1} - ${var.project_name}</h1>" > /var/www/html/index.html
    echo "<p>Hostname: $(hostname)</p>" >> /var/www/html/index.html
    echo "<p>IP: $(hostname -I)</p>" >> /var/www/html/index.html
    echo "<p>Date: $(date)</p>" >> /var/www/html/index.html
  EOF
  )
  
  tags = {
    name = "${terraform.workspace}-vm-${count.index}"
    env = terraform.workspace
  }

  depends_on = [
    openstack_networking_subnet_v2.private_subnet,
    #openstack_networking_router_interface_v2.router_interface
  ]
}

resource "openstack_compute_volume_attach_v2" "volume_attachments" {
  count = var.vm_count
  
  instance_id = openstack_compute_instance_v2.vms[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.volumes[count.index].id
}

# resource "openstack_compute_floatingip_associate_v2" "floating_ip_associations" {
#   count = var.vm_count
  
#   floating_ip = openstack_networking_floatingip_v2.floating_ips[count.index].address
#   instance_id = openstack_compute_instance_v2.vms[count.index].id
# }

output "vm_info" {
  value = {
    for i in range(var.vm_count) : "vm-${i + 1}" => {
      name        = openstack_compute_instance_v2.vms[i].name
      private_ip  = openstack_compute_instance_v2.vms[i].network[0].fixed_ip_v4
      #floating_ip = openstack_networking_floatingip_v2.floating_ips[i].address
      volume_id   = openstack_blockstorage_volume_v3.volumes[i].id
      #ssh_command = "ssh -i ${var.project_name}-key.pem ubuntu@${openstack_networking_floatingip_v2.floating_ips[i].address}"
    }
  }
}

output "network_info" {
  value = {
    network_name = openstack_networking_network_v2.private_network.name
    subnet_cidr  = openstack_networking_subnet_v2.private_subnet.cidr
    #router_name  = openstack_networking_router_v2.router.name
  }
}

output "created_resources" {
  value = {
    image_name  = openstack_images_image_v2.ubuntu_image.name
    flavor_name = openstack_compute_flavor_v2.custom_flavor.name
    keypair     = openstack_compute_keypair_v2.ssh_keypair.name
    network     = openstack_networking_network_v2.private_network.name
    secgroup    = openstack_networking_secgroup_v2.secgroup.name
  }
}