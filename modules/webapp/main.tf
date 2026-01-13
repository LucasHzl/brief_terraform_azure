resource "azurerm_service_plan" "this" {
  name                = "${var.webapp_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = var.service_plan_sku
}

resource "azurerm_linux_web_app" "this" {
  name                = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id = azurerm_service_plan.this.id

  https_only = true

  site_config {
    always_on = false
  }
}
