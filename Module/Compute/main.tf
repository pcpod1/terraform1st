resource "azurerm_public_ip" "compute" {
  name                = "${var.ip_name}-ip"
  resource_group_name = var.name
  location            = var.location
  allocation_method   = "Static"
  sku = "standard"
}
resource "azurerm_network_interface" "compute" {
  name                = "${var.NIC_name}-interface"
  location            = var.location
  resource_group_name = var.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.compute.id
  }
}
resource "azurerm_network_security_group" "compute" {
  name                = "${var.vm_name}_SecurityGroup"
  location            = var.location
  resource_group_name = var.name
}
resource "azurerm_virtual_machine" "compute" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.name
  network_interface_ids = [azurerm_network_interface.compute.id]
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
    computer_name  = "${var.vm_name}-vm01"
    admin_username = "pushpend"
    admin_password = var.admin_password
  }
  os_profile_windows_config {
  }
 
}