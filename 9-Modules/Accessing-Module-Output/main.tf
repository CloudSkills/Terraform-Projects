resource "azurerm_resource_group" "CloudskillsRG" {
  name = "cloudskillsrg"
  location = "eastus"

  instances = module.AKS.Name
}