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

variable "vm_name" {
  type    = string
  default = "datacorp-vm"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
