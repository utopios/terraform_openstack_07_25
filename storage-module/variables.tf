# storage-module/variables.tf

variable "volume_name" {
  description = "Nom du volume principal"
  type        = string
}

variable "volume_size" {
  description = "Taille du volume principal en GB"
  type        = number
  validation {
    condition     = var.volume_size > 0 && var.volume_size <= 1000
    error_message = "La taille du volume doit être entre 1 et 1000 GB."
  }
}

variable "create_snapshot" {
  description = "Créer un snapshot du volume principal"
  type        = bool
  default     = false
}

variable "backup_volume_size" {
  description = "Taille du volume de sauvegarde en GB (doit être >= à la taille du volume principal)"
  type        = number
  default     = null
  validation {
    condition = var.backup_volume_size == null || var.backup_volume_size > 0
    error_message = "La taille du volume de sauvegarde doit être positive."
  }
}

variable "volume_type" {
  description = "Type de volume (optionnel)"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Zone de disponibilité (optionnel)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
}
