resource "azurerm_public_ip" "apim" {
  name                = "core-api-mgmt-${var.env}-private-pip"
  resource_group_name = var.vnet_rg_name
  location            = var.location
  allocation_method   = "Static"

  tags = var.common_tags
  sku  = "Standard"

}

resource "azurerm_subnet" "api-mgmt-subnet" {
  name                 = "core-infra-subnet-apimgmt-${local.env}-private"
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.apim_subnet_address_prefix]

  lifecycle {
    ignore_changes = [address_prefix]
  }
}

resource "azurerm_template_deployment" "apim" {
  name                = "core-infra-subnet-apimgmt-${local.env}"
  resource_group_name = var.vnet_rg_name
  deployment_mode     = "Incremental"
  template_body       = file("${path.module}/arm/apim.json")
  parameters = {
    name                    = local.name
    location                = var.location
    sku_name                = var.sku_name
    publisherEmail          = var.publisher_email
    publisherName           = var.publisher_name
    subnetResourceId        = azurerm_subnet.api-mgmt-subnet.id
    notificationSenderEmail = var.notification_sender_email
    virtualNetworkType      = var.virtualNetworkType
    publicIpAddressId       = azurerm_public_ip.apim.id
  }
}

resource "azurerm_role_assignment" "apim" {
  principal_id = data.azurerm_api_management.apim.identity[0]["principal_id"]
  scope        = data.azurerm_key_vault.main.id

  role_definition_name = "Key Vault Secrets User"

  depends_on = [
    azurerm_template_deployment.apim,
    data.azurerm_api_management.apim
  ]
}

resource "azurerm_api_management_custom_domain" "api-management-custom-domain" {
  api_management_id = data.azurerm_api_management.apim.id

  proxy {
    host_name                    = "core-api-mgmt.${var.env}.platform.hmcts.net"
    negotiate_client_certificate = true
    key_vault_id                 = data.azurerm_key_vault_certificate.certificate.secret_id
  }

  depends_on = [
    azurerm_template_deployment.apim,
    data.azurerm_api_management.apim,
    azurerm_role_assignment.apim
  ]
}


