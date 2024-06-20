variable "project" {
  type = string
}

variable "author" {
  type = string
}

variable "purpose" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain_name_label" {
  type = string
  default = "devopschallenge"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "DevOpsChallenge"
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "germanywestcentral"
}

variable "container_registry_name" {
  type = string
  default = "DevOpsChallengeCGI"
}

variable "aks_version" {
  type = string
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "DevOpsChallenge"
}

variable "os_disk_size_gb" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
  default     = "dvps"
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
}