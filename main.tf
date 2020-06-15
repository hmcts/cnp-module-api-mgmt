locals {
  name                  = "core-api-mgmt-${var.env}"
  platform_api_mgmt_sku = "${var.env == "prod" ? "Premium_1" : "Developer_1"}"
}

resource "azurerm_api_management" "api-managment" {
  name                = "${local.name}"
  location            = "${var.location}"
  resource_group_name = "${var.vnet_rg_name}"
  publisher_name      = "${var.publisher_name}"
  publisher_email     = "${var.publisher_email}"
  notification_sender_email = "${var.notification_sender_email}"

  virtual_network_configuration {
    subnet_id = "${var.api_subnet_id}"
  }

  sku_name = "${local.platform_api_mgmt_sku}"
}
