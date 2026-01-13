output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "resource_group_location" {
  value = data.azurerm_resource_group.rg.location
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "storage_container_name" {
  value = module.storage.container_name
}
