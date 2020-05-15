

provider "azurerm" {
    version="1.38.0"
}

module "WindowsServer" {
  source = "../module"

  system = "terraexample"
  servername = "vmterraform"
  location = "westus2"
  admin_username = "cloudadmin"
  admin_password = "P@ssw0rd2020"
  vm_size = "Standard_D2s_v3"
  vnet_address_space = ["10.0.0.0/16"]
  os = "2019-Datacenter"
  os = 
  os = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
  }
  disk_size_gb = "32,64"
}


