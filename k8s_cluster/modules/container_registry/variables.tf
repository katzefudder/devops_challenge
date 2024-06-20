variable "environment" {
  type = string
}

variable "container_registry_name" {
    type = string
}

variable "resource_group_name" {
    type = string  
}

variable "location" {
    type = string
}

variable "tags" {
    type = map(string)
}