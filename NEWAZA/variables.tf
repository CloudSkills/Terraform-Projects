variable "subscriptionID" {
    type = string
    description = "Variable for our resource group"
}

variable "rgName" {
    type = string
    description = "name of resource group"
}

variable "location" {
    type = string
    description = "location of your resource group"
}

variable "network_interface_id" {
    type = string
}

variable "PublicIP" {
    type = string
    description = "name of Pubic IP"
}

variable "SubnetName" {
    type = string
    description = "name of Subnet"
}

variable "VirtualNet" {
    type = string
    description = "VirtualNet"
}