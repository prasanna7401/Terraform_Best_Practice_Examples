terraform {
  
}

variable "some_value" {
  type = string
  default = "Hello, World!\n "
  
}

variable "students" {
    type = map
    default = {
        "Alice" = 20
        "Bob" = 21
        "Charlie" = 22
    }
}
