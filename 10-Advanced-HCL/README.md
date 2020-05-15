## Module 10: Understanding Functions, Expressions, and Loops


#### Functions


Lower:
```
lower("TFStoragesta")
```

Replace:
```
replace("Luke likes CloudSkills", "likes", "loves")
```

```
replace("/subscriptions/f8c37571-4325-4a97-977b-7a216e64bae3/resourceGroups/rg-remotestatetfc", "/[0-9A-Fa-f]{8}-(?:[0-9A-Fa-f]{4}-){3}[0-9A-Fa-f]{12}/", "c1c37531-2355-4a57-947b-4e236e64bae3")
```

Min and Max:
```
max(32,64,99)
```
```
min (32,128,1024)
```

Split:
```
split("_","Standard_LRS")
```

Element:
```
element(split("_","Standard_LRS"), 0)
```

Coalesce:
```
coalesce("40", "50", "20")
```
```
coalesce( "", "50", "20")
```

Length:
```
length(["32GB", "64GB"])
```

Setproduct:
```
setproduct(["development", "staging", "production"], ["EastUS", "WestUS"])
```

File:
```
file("${path.module}/test.ps1")
```

#### Complex Expressions

Conditions:
```
condition ? true : false
```
```
resource "azurerm_virtual_machine" "main" {
  name                  = "MyVMName"
  location              = var.vm_location != "" ? var.vm_location : azurerm_resource_group.main.location
  ...
```

For Expressions:
```
data "azurerm_virtual_network" "example" {
  name                = "LukeLab-NC-Prod-Vnet"
  resource_group_name = "NetworkingTest-RG"
}

output "subnets" {
  value = [for s in data.azurerm_virtual_network.example.subnets : lower(s)]
}
```
```
data "azurerm_virtual_network" "example" {
  name                = "LukeLab-NC-Prod-Vnet"
  resource_group_name = "NetworkingTest-RG"
}

output "subnets" {
  value = {for s in data.azurerm_virtual_network.example.subnets : s => lower(s)}
}
```

```
data "azurerm_virtual_network" "example" {
  name                = "LukeLab-NC-Prod-Vnet"
  resource_group_name = "NetworkingTest-RG"
}

output "subnets" {
  value = [for s in data.azurerm_virtual_network.example.subnets : s if length(regexall("LukeApp[2-4]-NC-Prod-Subnet", s)) > 0]

}
```

Splat Expressions
```
data.azurerm_virtual_network.example[*].subnets[0]
```

#### Loops

Count
```
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  count = 3
  name     = "rg-MyResourceGroup-${count.index}"
  location = "West US 2"
}
```


```
provider "azurerm" {
  features {}
}

variable "bootdiag_storage" {
  type = bool
  description = "Enter the name of the boot diagnostic storage account if one is desired"
  default = false
}

resource "azurerm_resource_group" "rg" {

  name     = "rg-MyResourceGroup"
  location = "West US 2"
}

resource "azurerm_storage_account" "bootdiag" {
  count = var.bootdiag_storage ? 1 : 0

  name                     = "myterraformvmsadiag"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
```

For_each
```
provider "azurerm" {
  features {}
}

variable "inbound_rules" {
  type = map
  description = "A map of allowed inbound ports and their priority value"
  default = {
    101 = 3389
    102 = 22
    103 = 443

  }
}

resource "azurerm_resource_group" "rg" {

  name     = "rg-mytesourcegroup"
  location = "West US 2"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-mysecuritygroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each = var.inbound_rules
  name                        = "port_${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
```

Dynamic Blocks
```
variable "disk_size_gb" {
  description = "Size of disks in GBs. Choose multiple disks by comma separating each size"
  type        = string
  default = "64"
}

# Create virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = var.servername
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_D2s_v3"
...
  dynamic storage_data_disk {
    for_each = split(",", var.disk_size_gb)
      content {
        name              = "${var.servername}_datadisk_${storage_data_disk.key}"
        create_option     = "Empty"
        lun               = storage_data_disk.key
        disk_size_gb      = storage_data_disk.value
        managed_disk_type = "StandardSSD_LRS"
      }
  }
...
```