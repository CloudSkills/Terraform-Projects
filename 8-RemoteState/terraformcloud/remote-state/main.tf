#Set up remote state
terraform {
  backend "remote" {
    organization = "LukeLab"

    workspaces {
      name = "terraformdemo"
    }
  }
}

#configure azurerm provider
provider "azurerm" {
  version = "1.38"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-remotestatetfc"
    location = "westus2"
}