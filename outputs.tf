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

output "webapp_url" {
  value = module.webapp.default_hostname
}

output "vm_public_ip" {
  value = module.vm.public_ip
}

output "vm_name" {
  value = module.vm.vm_name
}
