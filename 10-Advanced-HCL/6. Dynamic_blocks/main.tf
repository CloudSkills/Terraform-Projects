provider "azurerm" {
  version = "1.38.0"
}

#Collect powershell script and input variables
data "template_file" "init" {
  template = "${file("./post-deploy.ps1")}"
  vars = {
    webservername = var.servername
  }
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-${var.system}"
    location = var.location
    tags      = {
      Environment = var.system
    }
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-dev-${var.location}-001"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-dev-${var.location}-001 "
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.0.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "pip-${var.servername}-dev-${var.location}-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


# Create network security group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-httpsallow-${var.system}-001 "
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "HTTP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "nic-01-${var.servername}-dev-001 "
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "niccfg-${var.servername}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

 # Create virtual machine
 resource "azurerm_virtual_machine" "vm" {
   name                  = var.servername
   location              = azurerm_resource_group.rg.location
   resource_group_name   = azurerm_resource_group.rg.name
   network_interface_ids = [azurerm_network_interface.nic.id]
   vm_size               = var.vm_size

   storage_os_disk {
     name              = "stvm${var.servername}os"
     caching           = "ReadWrite"
     create_option     = "FromImage"
     managed_disk_type = lookup(var.managed_disk_type, var.location, "Standard_LRS")
   }


    dynamic storage_data_disk {
      for_each = split(",", var.disk_size_gb)
        content {
          name              = "${var.servername}_datadisk_${storage_data_disk.key}"
          create_option     = "empty"
          lun               = storage_data_disk.key
          disk_size_gb      = storage_data_disk.value
          managed_disk_type = "StandardSSD_LRS"
        }
    }



   storage_image_reference {
     publisher = var.os.publisher
     offer     = var.os.offer
     sku       = var.os.sku
     version   = var.os.version
   }

   os_profile {
     computer_name  = var.servername
     admin_username = var.admin_username
     admin_password = var.admin_password
     custom_data = data.template_file.init.rendered
   }

   os_profile_windows_config{
     provision_vm_agent = true
   }
}


#Azure Custom Script Extension for Script Deployment
resource "azurerm_virtual_machine_extension" "script" {
  name                 = "${var.servername}-script-ext"
  location             = azurerm_virtual_machine.vm.location
  resource_group_name  = azurerm_virtual_machine.vm.resource_group_name
  virtual_machine_name = azurerm_virtual_machine.vm.name
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  # CustomVMExtension Documetnation: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows

  settings = <<SETTINGS
    {
      "commandToExecute": "rename  C:\\AzureData\\CustomData.bin  postdeploy.ps1 & powershell -ExecutionPolicy Unrestricted -File C:\\AzureData\\postdeploy.ps1"

    }
SETTINGS

  lifecycle {
    ignore_changes = [
      settings,
    ]
  }

}