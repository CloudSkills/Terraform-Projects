variable "nsg_rules" {
  description = "Predefined rules from the rules.tf list"
  type        = list(any)
  default     = []
}

variable "source_address_prefix" {
  description = "Source address prefix to be applied to all rules."
  type        = list(string)
  default     = ["*"]
}

variable "destination_address_prefix" {
  description = "Destination address prefix to be applied to all rules."
  type        = list(string)
  default     = ["*"]
}

variable "vnet_address" {
  description = "Destination address prefix to be applied to all rules."
  type        = list(string)
  default     = ["*"]
}

variable "subnet_address" {
  description = "Destination address prefix to be applied to all rules."
  type        = list(string)
  default     = ["*"]
}