provider "azurerm" {
  version = "1.38.0"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-testcondition"
    location = var.location != "" ? var.location : "southcentralus"
}