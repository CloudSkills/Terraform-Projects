output "pip" {
    description = "Public IP Address of Virtual Machine"
    value = azurerm_public_ip.publicip.ip_address
}