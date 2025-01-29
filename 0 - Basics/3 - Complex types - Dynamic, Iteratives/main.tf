terraform {
  
}

# Random number
resource "random_integer" "something" {
  min = 1
  max = 100
}

# Collection Types

# LIST
variable "planets" {
  type = list
  default = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]
} # index starts from 0

# MAP
variable "plans" {
  type = map
  default = {
    "Premium" = 100
    "Standard" = 50
    "Basic" = 25
  }
}

# Structural types

# OBJECT - USEFUL!!!
variable "person" {
  type = object({
    name = string
    age = number
    is_student = bool
  })
  default = {
    name = "John Doe"
    age = 25
    is_student = true
  }
}

# TUPLE
variable "random" {
    type = tuple([string, number, bool])
    default = ["Hello", 42, false]
}