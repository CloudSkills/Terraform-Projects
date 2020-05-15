#Set up remote state
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "terrastatestorage2134"
    container_name       = "terraformdemo"
    key                  = "dev.terraform.tfstate"
  }
}

#configure azurerm provider
provider "azurerm" {
  version = "1.38"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-remotestatedemo"
    location = "westus2"
}