variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
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
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default     = {}
}