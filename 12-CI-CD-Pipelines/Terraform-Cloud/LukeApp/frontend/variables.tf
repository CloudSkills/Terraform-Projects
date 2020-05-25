
#Authentication
variable "admin_username" {
  type        = string
  description = "Administrator username for server"
}

variable "admin_password" {
  type        = string
  description = "Administrator password for server"
}


#Server Settings

variable "servers" {
  description = "List of backend HTTP settings."
  type = list(object({
    servername        = string
    location          = string
    managed_disk_type = string
    vm_size           = string
    os                = string
    disk_size_gb      = string
  }))
}
