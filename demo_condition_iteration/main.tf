variable "environment" {
  type = string
  default = "prod"
}

variable "sockets" {
  type = number
  default = 4
}

variable "instance_count" {
  type = number
  default = 3
}

variable "server_names" {
  type = list(string)
  default = [ "web", "api", "database" ]
}

variable "server_configuration" {
  type = map(string)
  default = {
    "web" = "nginx"
    "api" = "apache2"
    "database" = "mysql"
  }
}

locals {
  number_cpu = var.environment == "prod" ? var.sockets * 10 : var.sockets * 5
  capital_servers_name = [for server in var.server_names : upper(server)]
}

# resource "null_resource" "res1" {
#     attribut = var.environment == "prod" ? "large" : "medium"
# }

# resource "null_resource" "res2" {
#   count = var.environment == "prod" ? 1 : 0
# }

# resource "null_resource" "vm" {
#   count = var.instance_count
#   attribut = "value-attribut - ${count.index}"
# }

resource "null_resource" "vm_names" {
  for_each = toset(var.server_names)
  name = "${each.value}-server"
}

resource "null_resource" "vm_configuration" {
  for_each = var.server_configuration
  name = "${each.key}-server"
  attribut = each.value
  cpu = local.number_cpu
}