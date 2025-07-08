variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
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
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default     = {}
}