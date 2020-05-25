provider "azurerm" {
  features{}
  version = "2.9.0"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-MyFirstTerraform"
    location = "westus2"
    tags      = {
      Environment = "Terraform Demo"
    }
}
