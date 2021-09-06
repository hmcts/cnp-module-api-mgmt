data "azurerm_client_config" "current" {}

data "azurerm_api_management" "apim" {
  name                = local.name
  resource_group_name = var.vnet_rg_name

  depends_on = [
    azurerm_template_deployment.apim
  ]
}

data "azurerm_key_vault" "main" {
  provider            = azurerm.acmedcdcftapps
  name                = "acmedcdcftapps${local.env}"
  resource_group_name = "cft-platform-${local.env}-rg"
}

data "azurerm_key_vault_certificate" "certificate" {
  name         = "wildcard-${var.env}-platform-hmcts-net"
  key_vault_id = data.azurerm_key_vault.main.id
}