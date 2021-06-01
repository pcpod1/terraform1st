
resource "azurerm_resource_group" "project-test" {
  name     = var.resourse_group
  location = var.location_name
}
resource "azurerm_virtual_network" "project-test" {
  name                = var.vnet_name1
  location            = azurerm_resource_group.project-test.location
  resource_group_name = azurerm_resource_group.project-test.name
  address_space       = ["192.168.0.0/24"]
}
resource "azurerm_subnet" "front" {
  name                 = var.subnet_name1
  resource_group_name  = azurerm_resource_group.project-test.name
  virtual_network_name = azurerm_virtual_network.project-test.name
  address_prefixes     = ["192.168.0.128/25"]
}
module "test-vm" {
  source = "../../Module/compute"
  NIC_name = var.NIC_name1
  vm_name = var.VM_name1
  subnet_id = azurerm_subnet.front.id
  admin_password = data.azurerm_key_vault_secret.volt.value
  location = azurerm_resource_group.project-test.location
  name = azurerm_resource_group.project-test.name
  ip_name = "private123"
}
/*resource "azurerm_network_interface" "backend2" {
  name                = "${var.NIC_name1}-web"
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
resource "azurerm_network_security_rule" "project-test" {
  name                        = "test1234"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "${module.test-vm.vm-public_ip}/32"
  resource_group_name         = azurerm_resource_group.project.name
  network_security_group_name = module.test-vm.NSG_name
}
resource "azurerm_network_interface_security_group_association" "project-test" {
  network_interface_id      = module.test-vm.NIC_id
  network_security_group_id = module.test-vm.NSG_ID
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