data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
/*output "id" {
  value = data.azurerm_resource_group.rg.id
}*/
data "azurerm_subnet" "app-subnet"{
    name = var.subnet
    virtual_network_name = var.vnet-rg
    resource_group_name = data.azurerm_resource_group.rg.name

}
/*output "id" {
  value = data.azurerm_subnet.app-subnet
}*/
resource "azurerm_network_security_group" "app-sg" {
  name                = var.network_security_group
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}
resource "azurerm_network_security_rule" "app-sg-rule" {
  name                        = var.network_security_rule
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.app-sg.name
}
resource "azurerm_network_interface" "demo-netintf" {
  name                = var.network_interface
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "demovmconfiguration1"
    subnet_id                     = data.azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# create virtual machine
resource "azurerm_virtual_machine" "demo-vm" {
  name                  = var.virtual_machine
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.demo-netintf.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "demodisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "dev"
  }
}