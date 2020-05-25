provider "azurerm" {
  version = "1.38.0"
}

data "azurerm_virtual_network" "example" {
  name                = "LukeLab-NC-Prod-Vnet"
  resource_group_name = "NetworkingTest-RG"
}

# output "subnets" {
#   value = [for s in data.azurerm_virtual_network.example.subnets : lower(s)]
# }


# output "subnets" {
#   value = {for s in data.azurerm_virtual_network.example.subnets : s => lower(s)}
# }


# output "subnets" {
#   value = [for s in data.azurerm_virtual_network.example.subnets : s if length(regexall("LukeApp[2-4]-NC-Prod-Subnet", s)) > 0]

# }


# output "subnets" {
#   value = data.azurerm_virtual_network.example[*].subnets[0]

# }


