provider "azurerm" {
  version = "2.0.0"

  features {}
}

resource "azurerm_resource_group" "cloudskillsRG" {
  name = "CloudSkilsRG1992"
  location = "eastus"
}
