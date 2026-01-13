variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "storage_container_name" {
  type    = string
  default = "raw"
}
