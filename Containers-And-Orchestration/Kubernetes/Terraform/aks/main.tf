terraform {
  backend "azurerm" {
    # The below values in the backend MUST be a string, no vars
    resource_group_name = ""
    storage_account_name = ""
    container_name = "tfstate"
    key = "terraform.state"
  }
}

provider azurerm {
  version = "2.0.0"
  features {}
}

resource "azurerm_kubernetes_cluster" "CloudSkillsAKS" {
  name                = var.Name
  location            = var.location
  resource_group_name = var.resourceGroup
  dns_prefix          = "cloudskillsprefix"

  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_D2_v2"
  }
  service_principal {
    client_id     = var.clientID
    client_secret = var.clientSecret
  }

  tags = {
    Environment = "Development"
  }
}