variable "environment" {
  type = string
  description = "The environment of the infrastrcture should be prod or dev"
  validation {
    condition = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be prod or dev, tour value is ${var.environment}"
  }  
}

variable "names" {
  description = "list of names"
  type = set(string)
  default = [ "toto" , "tata" ]
}

variable "instance_type" {
  type = string
  description = "The type of instance"
  validation {
    condition = contains(["small", "large"], var.instance_type)
    error_message = "The type must be small or large"
  }
}