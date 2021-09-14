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
    sbox = ["sbox"]
    nonprod = ["dev", "preview", "test", "ithc", "demo", "perftest"]
    prod    = ["prod", "aat"]
  }

  palo_ip_addresses = {
    sbox = {
      addresses = "10.10.200.37,10.10.200.38"
    }
  }

  nsgrules = {

    rdp = {
      name                       = "palo"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = local.palo_ip_addresses[[for x in keys(local.palo_env_mapping) : x if contains(local.palo_env_mapping[x], local.env)][0]].addresses
      destination_address_prefix = "*"
    }

    deny = {
      name                       = "deny"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Any"
      destination_address_prefix = "Any"
    }

  }

}

provider "azurerm" {
  alias                      = "acmedcdcftapps"
  skip_provider_registration = "true"
  features {}
  subscription_id = local.acmedcdcftapps[local.env].subscription
}
