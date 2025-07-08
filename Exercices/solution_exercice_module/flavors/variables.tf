variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
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
}

variable "common_tags" {
  description = "Tags communs pour toutes les ressources"
  type        = map(string)
  default     = {}
}