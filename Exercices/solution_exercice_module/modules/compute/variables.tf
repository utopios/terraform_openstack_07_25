variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
}

variable "vm_configurations" {
  description = "Configuration des VMs"
  type = map(object({
    image_key          = string
    flavor_key         = string
    ssh_key            = string
    volume_size        = number
    volume_type        = string
    assign_floating_ip = bool
    user_data_template = string
    packages           = list(string)
    services           = list(string)
    custom_ports       = list(number)
  }))
}

variable "images_map" {
  description = "Map des images disponibles"
  type = map(object({
    id   = string
    name = string
    size = number
  }))
}

variable "flavors_map" {
  description = "Map des flavors disponibles"
  type = map(object({
    id    = string
    name  = string
    ram   = string
    vcpus = string
    disk  = string
  }))
}

variable "ssh_keypairs_map" {
  description = "Map des keypairs SSH"
  type = map(object({
    id          = string
    name        = string
    fingerprint = string
  }))
}

variable "network_id" {
  description = "ID du réseau privé"
  type        = string
}

variable "security_group_id" {
  description = "ID du groupe de sécurité"
  type        = string
}

variable "security_group_name" {
  description = "Nom du groupe de sécurité"
  type        = string
  default     = ""
}

variable "volumes_map" {
  description = "Map des volumes de stockage"
  type = map(object({
    id   = string
    name = string
    size = number
    type = string
  }))
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default     = {}
}