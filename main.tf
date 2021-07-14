locals {
  name                  = "core-api-mgmt-${var.env}"
  platform_api_mgmt_sku = "${var.env == "prod" ? "Premium_1" : "Developer_1"}"
}

resource "azurerm_subnet" "api-mgmt-subnet" {
  name                 = "core-infra-subnet-apimgmt-${var.env}"
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["${cidrsubnet(var.source_range, 4, 4)}"]

  lifecycle {
    ignore_changes = [address_prefix]
  }
}

resource "azurerm_api_management" "api-managment" {
  name                      = local.name
  location                  = var.location
  resource_group_name       = var.vnet_rg_name
  publisher_name            = var.publisher_name
  publisher_email           = var.publisher_email
  notification_sender_email = var.notification_sender_email
  virtual_network_type      = var.virtual_network_type

  virtual_network_configuration {
    subnet_id = azurerm_subnet.api-mgmt-subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  sku_name = local.platform_api_mgmt_sku
}

data "azurerm_api_management" "core-api-mgmt" {
  name                = local.name
  resource_group_name = var.vnet_rg_name
}

output "api_management_host_name" {
  value = data.azurerm_api_management.core-api-mgmt.hostname_configuration.management.host_name
}

output "api_management_client_cert" {
  value = data.azurerm_api_management.core-api-mgmt.hostname_configuration.management.negotiate_client_certificate
}

output "api_management_portal_host_name" {
  value = data.azurerm_api_management.core-api-mgmt.hostname_configuration.portal.host_name
}

output "api_management_portal_client_cert" {
  value = data.azurerm_api_management.core-api-mgmt.hostname_configuration.portal.negotiate_client_certificate
}

output "api_management_dev_portal_host_name" {
  value = data.azurerm_api_management.core-api-mgmt.hostname_configuration.developer_portal.host_name
}

output "api_management_dev_portal_client_cert" {
  value = data.azurerm_api_management.core-api-mgmt.hostname_configuration.developer_portal.negotiate_client_certificate
}