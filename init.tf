locals {
  name = "core-api-mgmt-${local.env}-private"
  # platform_api_mgmt_sku = var.env == "prod" ? "Premium_1" : "Developer_1"

  env = (var.env == "aat") ? "stg" : (var.env == "sandbox") ? "sbox" : "${(var.env == "perftest") ? "test" : "${var.env}"}"


  acmedcdcftapps = {
    sbox = {
      subscription = "b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb"
    }
  }

  palo_env_mapping = {
    sbox    = ["sbox"]
    nonprod = ["dev", "preview", "test", "ithc", "demo", "perftest"]
    prod    = ["prod", "aat"]
  }

  palo_ip_addresses = {
    sbox = {
      addresses = "10.10.200.37,10.10.200.38"
    }
  }
}


provider "azurerm" {
  alias                      = "acmedcdcftapps"
  skip_provider_registration = "true"
  features {}
  subscription_id = local.acmedcdcftapps[local.env].subscription
}
