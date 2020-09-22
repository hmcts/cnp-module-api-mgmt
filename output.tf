output "host_name" {
  value = "${azurerm_template_deployment.api-managment.name}.azure-api.net"
}

output "developer_portal_url" {
  value = "${azurerm_template_deployment.api-managment.name}.portal.azure-api.net"
}

output "api_mgmt_name" {
  value = "${azurerm_template_deployment.api-managment.name}"
}