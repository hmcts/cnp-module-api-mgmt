resource "azurerm_network_security_group" "apim" {
  name                = "${local.name}-nsg"
  location            = var.location
  resource_group_name = var.vnet_rg_name
 
}

resource "azurerm_network_security_rule" "apimrules" {
  for_each                    = local.nsgrules 
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.vnet_rg_name
  network_security_group_name = azurerm_network_security_group.apim.name
}