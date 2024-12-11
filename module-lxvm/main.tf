
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
data "azurerm_subnet" "app-subnet" {
  name                 = var.subnet
  virtual_network_name = var.vnet-rg
  resource_group_name  = data.azurerm_resource_group.rg.name

}
resource "azurerm_network_interface" "demo-netintf" {
  name                = var.network_interface
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "demolinuxvm"
    subnet_id                     = data.azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}
resource "azurerm_network_security_group" "app-sg" {
  name                = var.network_security_group
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}
resource "azurerm_network_security_rule" "app-sg-rule" {
 # name                        = var.network_security_rule
  #priority                    = 100
 # direction                   = "Outbound"
  #access                      = "Allow"
  #protocol                    = "Tcp"
  #source_port_range           = "*"
  #destination_port_range      = "*"
  #source_address_prefix       = "*"
  #destination_address_prefix  = "*" 
  for_each                    = local.nsgrules
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.app-sg.name
}
resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
}
resource "azurerm_network_interface_security_group_association" "demoasso" {
  network_interface_id      = azurerm_network_interface.demo-netintf.id
  network_security_group_id = azurerm_network_security_group.app-sg.id
}
resource "azurerm_linux_virtual_machine" "demolinvm" {
  name                = "example-machine"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "window@1234" 
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.demo-netintf.id,
  ]

  #admin_ssh_key {
   # username   = "adminuser"
    #public_key = file("~/.ssh/id_rsa.pub")
 # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
