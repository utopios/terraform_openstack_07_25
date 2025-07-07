variable "second_var" {
  description = "second variable"
  type        = number
  default     = 30
}

variable "first_object" {
  description = "first object variable"
  type = object({
    name = string
    age  = number
  })
  default = {
    name = "John Doe"
    age  = 25
  }
  
}