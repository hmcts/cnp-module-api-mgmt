output "host_name" {
  value = "${azurerm_api_management.api-managment.name}.azure-api.net"
}

output "developer_portal_url" {
  value = "${azurerm_api_management.api-managment.name}.portal.azure-api.net"
}

output "api_mgmt_name" {
  value = "${azurerm_api_management.api-managment.name}"
}

output "api_management_host_name" {
  value = azurerm_api_management.api-managment.hostname_configuration["management"].host_name
}

output "api_management_client_cert" {
  value = azurerm_api_management.api-managment.hostname_configuration["management"].negotiate_client_certificate
}

output "api_management_portal_host_name" {
  value = azurerm_api_management.api-managment.hostname_configuration["portal"].host_name
}

output "api_management_portal_client_cert" {
  value = azurerm_api_management.api-managment.hostname_configuration["portal"].negotiate_client_certificate
}

output "api_management_dev_portal_host_name" {
  value = azurerm_api_management.api-managment.hostname_configuration["developer_portal"].host_name
}

output "api_management_dev_portal_client_cert" {
  value = azurerm_api_management.api-managment.hostname_configuration["developer_portal"].negotiate_client_certificate
}