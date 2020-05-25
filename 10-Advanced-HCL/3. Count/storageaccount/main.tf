provider "azurerm" {
  version = "1.38.0"
}

variable "bootdiag_storage" {
  type = bool
  description = "Enter the name of the boot diagnostic storage account if one is desired"
  default = true
}

resource "azurerm_resource_group" "rg" {

  name     = "rg-MyResourceGroup"
  location = "West US 2"
}

resource "azurerm_storage_account" "bootdiag" {
  count = var.bootdiag_storage ? 1 : 0

  name                     = "myterraformvmsadiag"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}