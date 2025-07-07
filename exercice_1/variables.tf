 variable "first_name" {
  description = "the first name of the student"
  type = string
  validation {
    condition     = length(var.first_name) > 2
    error_message = "First name cannot be empty."
  }
#   validation {
#     condition     = can(regex("^[a-zA-Z]+$", var.first_name))
#     error_message = "First name must contain only letters."
#   }
}
variable "last_name" {
  description = "the last name of the student"
  type = string
}

variable "age" {
  description = "the age of the student"
  type = number
  validation {
    condition     = var.age >= 15 && var.age <= 120
    error_message = "Age must be between 15 and 120."
  }
#   validation {
#     condition     = var.age < 18
#     error_message = "Age must be a valid number."
#   }
}

variable "is_student" {
  description = "Whether the person is a student"
  type = bool
  default = false
}

variable "courses" {
  description = "the list of courses the student is taking"
  type = list(string)
  default = [ "Math", "Science" ]
}

variable "grades" {
  description = "the grades of the student in each course"
  type = map(number)
  default = {
    "Math" = 90,
    "Science" = 90
  }
}

variable "student" {
  description = "The details of the student"
  type = object({
    first_name = string
    last_name = string
    age = number
    is_student = bool
    courses = list(string)
    grades = map(number) 
  })

  default = {
    first_name = "value"
    last_name = "value"
    age = 20
    is_student = true
    courses = ["Math", "Science"]   
    grades = {
      "Math" = 90,
      "Science" = 90
    }
  }
}