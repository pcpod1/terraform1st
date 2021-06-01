output "vm_private_ip" {
    value = azurerm_network_interface.compute.private_ip_address
}
output "NIC_id" {
    value = azurerm_network_interface.compute.id
}
output "VM_id" {
    value = azurerm_virtual_machine.compute.id
}
output "NIC_name" {
    value = azurerm_network_interface.compute.name
}
output "NSG_name" {
    value = azurerm_network_security_group.compute.name
}
output "NSG_ID" {
    value = azurerm_network_security_group.compute.id
}
output "vm-public_ip" {
    value = azurerm_public_ip.compute.ip_address
}