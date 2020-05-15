#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-acrdemo"
  location = "West US 2"
}

#Create Azure Container Registry
resource "azurerm_container_registry" "acr-prod" {
  name                     = "acrprodregistrycloudskillslab001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = false


}

#Create Azure Container Registry
resource "azurerm_container_registry" "acr-dev" {
  name                     = "acrdevregistrycloudskillslab001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Standard"
  admin_enabled            = false


}

#Import Container Image to Azure Container Registries
resource "null_resource" "image" {

  triggers = {
     prod = azurerm_container_registry.acr-prod.id
     dev = azurerm_container_registry.acr-dev.id
  }  

  provisioner "local-exec" {
    command = <<EOT
       az acr import --name ${azurerm_container_registry.acr-prod.name} --source docker.io/library/hello-world:latest --image hello-world:latest
       az acr import --name ${azurerm_container_registry.acr-dev.name} --source docker.io/library/hello-world:latest --image hello-world:latest
   EOT
   interpreter = ["pwsh", "-Command"]
  }
}