data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
  numeric = true
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  storage_account_name = "datacorpsa${random_string.suffix.result}"
  container_name       = var.storage_container_name
}

module "webapp" {
  source = "./modules/webapp"

  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  webapp_name      = "datacorp-webapp-${random_string.suffix.result}"
  service_plan_sku = "F1"
}

module "vm" {
  source              = "./modules/vm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  vm_name             = var.vm_name
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
}
