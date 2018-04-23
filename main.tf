resource "azurerm_resource_group" "api-mgmt-resourcegroup" {
  name     = "core-api-mgmt-rg-${var.env}"
  location = "${var.location}"

  tags {
    environment = "${var.env}"
  }
}

data "template_file" "apimgmttemplate" {
  template = "${file("${path.module}/templates/api-management.json")}"
}

locals {
  name = "core-api-mgmt-${var.env}"
}

resource "azurerm_template_deployment" "api-managment" {
  template_body       = "${data.template_file.apimgmttemplate.rendered}"
  name                = "${local.name}"
  resource_group_name = "${azurerm_resource_group.api-mgmt-resourcegroup.name}"
  deployment_mode     = "Incremental"

  parameters = {
    location                           = "${var.location}"
    env                                = "${var.env}"
    platform_api_mgmt_name             = "${local.name}"
    platform_api_mgmt_subnetResourceId = "${var.subnetResourceId}"
  }
}