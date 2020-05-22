data "terraform_remote_state" "terraformdemo" {
  backend = "remote"
  config = {
    organization = "lukelabdemo"
    workspaces = {
      name = "terraformdemo"
    }
  }
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-terraformtfctest"
    address_space       = ["10.0.0.0/22"]
    location            = data.terraform_remote_state.terraformdemo.outputs.rg.location
    resource_group_name = data.terraform_remote_state.terraformdemo.outputs.rg.name
}