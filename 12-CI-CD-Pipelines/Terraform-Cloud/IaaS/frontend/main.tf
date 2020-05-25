
# Create network interface
resource "azurerm_network_interface" "nic" {
  count = length(var.servers)
  name                      = "nic-01-${var.servers[count.index].servername}-dev-001 "
  location                  = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name       = data.terraform_remote_state.rg.outputs.rg_name

  ip_configuration {
    name                          = "niccfg-${var.servers[count.index].servername}"
    subnet_id                     = data.terraform_remote_state.networking.outputs.subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

 # Create virtual machine
 resource "azurerm_virtual_machine" "vm" {
   count = length(var.servers)
   name                  = var.servers[count.index].servername
   location              = data.terraform_remote_state.rg.outputs.rg_location
   resource_group_name   = data.terraform_remote_state.rg.outputs.rg_name
   network_interface_ids = [azurerm_network_interface.nic[count.index].id]
   vm_size               = var.servers[count.index].vm_size

   storage_os_disk {
     name              = "stvm${var.servers[count.index].servername}os"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = var.servers[count.index].managed_disk_type
   }


    dynamic storage_data_disk {
      for_each = split(",", var.servers[count.index].disk_size_gb)
        content {
          name              = "${var.servers[count.index].servername}_datadisk_${storage_data_disk.key}"
          create_option     = "empty"
          lun               = storage_data_disk.key
          disk_size_gb      = storage_data_disk.value
          managed_disk_type = var.servers[count.index].managed_disk_type
        }
    }



   storage_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer     = "WindowsServer"
     sku       = var.servers[count.index].os
     version   = "latest"
   }

   os_profile {
     computer_name  = var.servers[count.index].servername
     admin_username = var.admin_username
     admin_password = var.admin_password
   }

   os_profile_windows_config{
     provision_vm_agent = true
   }
}
