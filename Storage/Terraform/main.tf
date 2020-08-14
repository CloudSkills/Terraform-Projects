provider "azurerm" {
  version = ">=2.0.0"

  features {}
}

resource "azurerm_storage_account" "cloudskillsstorage" {
  name = "cloudskills92"
  resource_group_name = var.RG
  location = var.location
  account_tier = "Standard"
  account_replication_type = "GRS"
}
