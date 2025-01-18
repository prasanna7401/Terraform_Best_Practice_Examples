terraform {
  
}

variable "name" {
  type = string
}

variable "games" {
  type = list
  
}

variable "game_map" {
  type = map
}

output "games" {
  value = var.games[*].name
}