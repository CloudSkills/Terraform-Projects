variable "system" {
  type        = string
  description = "Name of the system or environment"
  default     = "scalingapp"
}

variable "hub_location" {
  type        = string
  description = "Azure region location of Virtual Network"
  default     = "westus2"

}

variable "spokes" {
}