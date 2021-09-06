output "host_name" {
  value = "${data.azurerm_api_management.apim.name}.azure-api.net"
}

output "developer_portal_url" {
  value = "${data.azurerm_api_management.apim.name}.portal.azure-api.net"
}

output "api_mgmt_name" {
  value = "${data.azurerm_api_management.apim.name}"
}