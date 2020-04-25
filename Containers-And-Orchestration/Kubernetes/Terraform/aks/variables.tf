variable "Name" {
    type = string
    description = "Name of AKS cluster"
}

variable "resourceGroup" {
    type = string
    description = "Resource Group name"
}

variable "keyvaultID" {
    type = string
    description = "KeyVault ID"
}

variable "location" {
    type = string
    description = "Region"
}

variable "clientID" {
  type = string
  description = "Client ID from the app registration"
}

variable "clientSecret" {
  type = string
  description = "Client secret from the app registration"
}