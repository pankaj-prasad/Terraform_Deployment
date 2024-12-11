output "network_interface_private_ip" {
  description = "private ip address of the vm nics"
  value = azurerm_network_interface.demo-netintf.private_ip_address
}
output "server_host_name" {
    description = "host name of the server"
    value = azurerm_virtual_machine.demo-vm.name
  
}