
resource "azurerm_resource_group" "project" {
  name     = var.resourse_group_name
  location = var.location_name
}
resource "azurerm_virtual_network" "project" {
  name                = var.vnet_name
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "backend1" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.project.name
  address_prefixes     = ["10.0.1.0/24"]
}
module "web-vm" {
  source = "../../Module/compute"
  NIC_name = var.NIC_name
  vm_name = var.VM_name
  subnet_id = azurerm_subnet.backend1.id
  admin_password = data.azurerm_key_vault_secret.volt.value
  location = azurerm_resource_group.project.location
  name = azurerm_resource_group.project.name
  ip_name = "public123"

}

/*resource "azurerm_network_interface" "backend2" {
  name                = "${var.NIC_name}-web"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.backend1.id
    private_ip_address_allocation = "Dynamic"
  }
}
*/
/*resource "azurerm_network_security_group" "project" {
  name                = "privateSecurityGroup1"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
}
*/
resource "azurerm_network_security_rule" "project" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${module.web-vm.vm-public_ip}/32"
  resource_group_name         = azurerm_resource_group.project.name
  network_security_group_name = module.web-vm.NSG_name
}
resource "azurerm_network_interface_security_group_association" "project" {
  network_interface_id      = module.web-vm.NIC_id
  network_security_group_id = module.web-vm.NSG_ID
}
/*resource "azurerm_virtual_machine" "project" {
  name                  = "web-vm"
  location              = azurerm_resource_group.project.location
  resource_group_name   = azurerm_resource_group.project.name
  network_interface_ids = [azurerm_network_interface.backend2.id]
  vm_size               = "Standard_B2s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "webosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "web-vm"
    admin_username = "pushpend"
    admin_password = "Spider@123"
  }
  os_profile_windows_config {
  }
 
}
*/