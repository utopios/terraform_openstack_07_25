variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
}

variable "vm_configurations" {
  description = "Configuration des VMs pour créer les volumes"
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

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default     = {}
}