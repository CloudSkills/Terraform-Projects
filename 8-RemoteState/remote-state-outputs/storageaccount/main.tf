data "terraform_remote_state" "terraformdemo" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "terrastatestorage2134"
    container_name       = "terraformdemo"
    key                  = "dev.terraform.tfstate"
  }

}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-terraformsatest"
    address_space       = ["10.1.0.0/22"]
    location            = data.terraform_remote_state.terraformdemo.outputs.rg.location
    resource_group_name = data.terraform_remote_state.terraformdemo.outputs.rg.name
}