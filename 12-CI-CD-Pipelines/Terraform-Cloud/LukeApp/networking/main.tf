#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-${data.terraform_remote_state.rg.outputs.system}-${data.terraform_remote_state.rg.outputs.rg_location}-001"
    address_space       = var.vnet_address
    location            = data.terraform_remote_state.rg.outputs.rg_location
    resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-${data.terraform_remote_state.rg.outputs.system}-${data.terraform_remote_state.rg.outputs.rg_location}-001 "
  resource_group_name  = data.terraform_remote_state.rg.outputs.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = var.subnet_address
}

# Create network security group and rules
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${data.terraform_remote_state.rg.outputs.system}-001"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
}

resource "azurerm_network_security_rule" "predefined_rules" {
  count                       = length(var.nsg_rules)
  name                        = lookup(var.nsg_rules[count.index], "name")
  priority                    = lookup(var.nsg_rules[count.index], "priority", 4096 - length(var.nsg_rules) + count.index)
  direction                   = element(var.rules[lookup(var.nsg_rules[count.index], "name")], 0)
  access                      = element(var.rules[lookup(var.nsg_rules[count.index], "name")], 1)
  protocol                    = element(var.rules[lookup(var.nsg_rules[count.index], "name")], 2)
  source_port_ranges          = split(",", replace(lookup(var.nsg_rules[count.index], "source_port_range", "*"), "*", "0-65535"))
  destination_port_range      = element(var.rules[lookup(var.nsg_rules[count.index], "name")], 4)
  description                 = element(var.rules[lookup(var.nsg_rules[count.index], "name")], 5)
  source_address_prefix       = join(",", var.source_address_prefix)
  destination_address_prefix  = join(",", var.destination_address_prefix)
  resource_group_name         = data.terraform_remote_state.rg.outputs.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}