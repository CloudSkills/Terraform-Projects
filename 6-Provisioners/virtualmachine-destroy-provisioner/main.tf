provider "azurerm" {
  version = "1.38.0"
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-MyFirstTerraform"
    location = "westus2"
    tags      = {
      Environment = "Terraform Demo"
    }
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-dev-westus2-001"
    address_space       = ["10.0.0.0/16"]
    location            = "westus2"
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-dev-westus2-001 "
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.0.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "pip-vmterraform-dev-westus2-001"
  location            = "westus2"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


# Create network security group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-sshallow-001 "
  location            = "westus2"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
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
  name                      = "nic-01-vmterraform-dev-001 "
  location                  = "westus2"
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "niccfg-vmterraform"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "vmterraform"
  location              = "westus2"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "stvmpmvmterraformos"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vmterraform"
    admin_username = "terrauser"
    admin_password = "Password1234!"
  }
  os_profile_windows_config{
    provision_vm_agent = true
  }

  #Add Virtual Machine to Azure DSC after deployment.
  provisioner "local-exec" {
    command = <<EOT
        $params = @{
        AutomationAccountName = "aa-terraformdemo"
        AzureVMName = "${azurerm_virtual_machine.vm.name}"
        ResourceGroupName = "rg-terraformaa"
        NodeConfigurationName = "WebserverConfig.localhost"
        azureVMLocation = "${azurerm_resource_group.rg.location}"
        AzureVMResourceGroup = "${azurerm_resource_group.rg.name}"
        }
        Register-AzAutomationDscNode @params 
   EOT
   interpreter = ["pwsh", "-Command"]
  }

  #Remove Virtual Machine from Azure DSC when destroying.
  provisioner "local-exec" {
    when = destroy
    command = <<EOT
        Get-AzAutomationDscNode -ResourceGroupName "rg-terraformaa" -AutomationAccountName "aa-terraformdemo" -Name "${self.name}" | Unregister-AzAutomationDscNode -force
    EOT
   interpreter = ["pwsh", "-Command"]
  }

}