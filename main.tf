locals {
  name                  = "core-api-mgmt-${var.env}-private"
  platform_api_mgmt_sku = var.env == "prod" ? "Premium_1" : "Developer_1"
}

resource "azurerm_public_ip" "apim" {
  name                = "core-api-mgmt-${var.env}-private-pip"
  resource_group_name = var.vnet_rg_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
  sku = "Standard"

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

resource "azurerm_template_deployment" "apim" {
  name                = "core-infra-subnet-apimgmt-${var.env}"
  resource_group_name = var.vnet_rg_name
  deployment_mode     = "Incremental"
  template_body       = file("arm/apim.json")
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

resource "azurerm_api_management_custom_domain" "api-management-custom-domain" {
  api_management_id = azurerm_api_management.api-managment.id

  proxy {
    host_name                    = join("", [azurerm_api_management.api-managment.name, ".azure-api.net"])
    negotiate_client_certificate = true
  }
}

resource "azurerm_key_vault_access_policy" "apim" {
  key_vault_id = data.azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_api_management.apim.identity[0]["principal_id"]

  secret_permissions = [
    "Get",
    "List"
  ]

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
    azurerm_key_vault_access_policy.apim
  ]
}