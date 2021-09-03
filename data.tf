data "azurerm_client_config" "current" {}

data "azurerm_api_management" "apim" {
  name                = local.name
  resource_group_name = var.vnet_rg_name

  depends_on = [
    azurerm_template_deployment.apim
  ]
}

data "azurerm_key_vault" "main" {
  name                = "acmedcdcftapps${var.env}"
  resource_group_name = "cft-platform-${var.env}-rg"
}

data "azurerm_key_vault_certificate" "certificate" {
  name         = "wildcard-sandbox-platform-hmcts-net"
  key_vault_id = data.azurerm_key_vault.main.id
}