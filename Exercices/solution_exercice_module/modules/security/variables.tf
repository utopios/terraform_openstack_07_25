variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
}

variable "network_id" {
  description = "ID du réseau privé"
  type        = string
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
}

variable "vm_configurations" {
  description = "Configuration des VMs pour extraire les ports personnalisés"
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
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default     = {}
}