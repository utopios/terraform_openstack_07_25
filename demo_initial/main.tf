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
    default     = "default_value_1"
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