variable "network_name" {
  description = "Nom du réseau OpenStack"
  type        = string
}

variable "subnet_name" {
  description = "Nom du sous-réseau"
  type        = string
}

variable "cidr" {
  description = "CIDR du sous-réseau"
  type        = string
  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "CIDR must be a valid IPv4 CIDR block."
  }
}

variable "admin_state_up" {
  description = "État administratif du réseau"
  type        = bool
  default     = true
}

variable "shared" {
  description = "Réseau partagé entre les projets"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = list(string)
  default     = []
}