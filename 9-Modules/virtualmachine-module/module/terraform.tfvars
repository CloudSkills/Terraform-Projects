system = "terraexample"
servername = "vmterraform"
location = "westus2"
admin_username = "cloudadmin"
admin_password = "P@ssw0rd2020"
vm_size = "Standard_D2s_v3"
vnet_address_space = ["10.0.0.0/16","10.1.0.0/16"]
os = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
}
disk_size_gb = "32,64"