terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
    
    required_version = ">= 1.0"
}

variable "var_1" {
  description = "first variable"
    type        = string
    default     = "default_value_2223"
}

variable "var_2" {
  description = "second variable"
    type        = string
    default     = "default_value_23423432"
}

resource "null_resource" "resource_1" {
  attribut1 = var.var_1
}

resource "null_resource" "resource_2" {
  attribut2 = var.var_2
  attribut2_resource_1 = null_resource.resource_1.id
  lifecycle {
    create_before_destroy = true
    prevent_destroy = true
    ignore_changes = [ 
      null_resource.resource_1.attribut1,
    ]
    replace_triggered_by = [ null_resource.resource_1.attribut2 ]
  }
}

resource "null_resource" "resource_3" {
  depends_on = [null_resource.resource_1, null_resource.resource_2] 
}

output "display_var_1" {
  description = "Display the value of var_1"
  value       = var.var_1
}

output "display_second_var" {
  description = "Display the value of second_var"
  value       = var.second_var
  
}

output "display_first_object_name" {
  description = "Display the first_object variable"
  value       = var.first_object.name
  
}


