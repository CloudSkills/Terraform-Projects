provider "azurerm" {
    version="1.38.0"
}

module "importlab" {
    source = "../complex-import"
}