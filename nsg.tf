resource "azurerm_network_security_group" "apim" {
  name                = "${local.name}-nsg"
  location            = var.location
  resource_group_name = var.vnet_rg_name

}

resource "azurerm_subnet_network_security_group_association" "apim" {
  subnet_id                 = azurerm_subnet.api-mgmt-subnet.id
  network_security_group_id = azurerm_network_security_group.apim.id
}

resource "azurerm_network_security_rule" "palo" {
  name                        = "palo"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefixes     = split(",", local.palo_ip_addresses[[for x in keys(local.palo_env_mapping) : x if contains(local.palo_env_mapping[x], local.env)][0]].addresses)
  destination_address_prefix  = "VirtualNetwork"
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
  source_address_prefix       = "ApiManagement"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}

resource "azurerm_network_security_rule" "vpn" {
  name                        = "vpn"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_ranges     = [80, 443]
  source_address_prefix       = "10.99.0.0/18"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}

resource "azurerm_network_security_rule" "AccessRedisService" {
  name                        = "AccessRedisService"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_ranges     = [6381, 6382, 6383]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}

resource "azurerm_network_security_rule" "SyncCounter" {
  name                        = "SyncCounter"
  priority                    = 104
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "udp"
  source_port_range           = "*"
  destination_port_ranges     = ["4290"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}

resource "azurerm_network_security_rule" "loadbalancer" {
  name                        = "loadbalancer"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
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
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}