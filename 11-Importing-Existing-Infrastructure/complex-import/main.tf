provider "azurerm" {
    version="1.38.0"
}

# create resource group
resource "azurerm_resource_group" "rg"{
    name = "rg-terraform-import"
    location = "eastus"
}


resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


  security_rule {
    name                       = "Allow-HTTPS"
    description                = "Allow HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    description                = "Allow HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform-eastus-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]


  subnet {
    name           = "subnet-terraform-10.0.0.0_24"
    address_prefix = "10.0.0.0/24"
  }

  subnet {
    name           = "subnet-terraform-10.0.1.0_24"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }
}