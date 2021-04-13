provider "azurerm" {
  version = "<=2.0.0"

  features {}
}

resource "azurerm_container_group" "nginxwebapp" {
  name                = "$nginxwebappcontainer"
  location            = var.location
  resource_group_name = var.RG
  ip_address_type     = "public"
  dns_name_label      = "nginx-dns"
  os_type             = "Linux"

  container {
    name   = "nginx"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
