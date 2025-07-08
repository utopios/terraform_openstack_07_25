variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
}

variable "ssh_keys_config" {
  description = "Configuration des clés SSH"
  type = map(object({
    algorithm = string
    rsa_bits  = number
  }))
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default     = {}
}