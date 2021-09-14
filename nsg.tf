resource "azurerm_network_security_group" "apim" {
  name                = "${local.name}-nsg"
  location            = var.location
  resource_group_name = var.vnet_rg_name
 
}

resource "azurerm_network_security_rule" "palo" {
  name                        = "palo"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = local.palo_ip_addresses[[for x in keys(local.palo_env_mapping) : x if contains(local.palo_env_mapping[x], local.env)][0]].addresses
  destination_address_prefix = "VirtualNetwork"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}

resource "azurerm_network_security_rule" "apimanagement" {
  name                        = "apimanagement"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "3443"
  source_address_prefix      = "ApiManagement"
  destination_address_prefix = "VirtualNetwork"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}

resource "azurerm_network_security_rule" "deny" {
  name                        = "deny"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}