variable "resource_group_location" {
  type        = string
  default     = "westus"
  description = "Location of the resource group."
}
variable "resource_group_name" {
  type        = string
  default     = "rg"
  description = "name of the resource group."
}
variable "vnet-rg" {
  type        = string
  default     = "vnet"
  description = "name of the virtual network."
}
variable "subnet" {
  type        = string
  default     = "snet"
  description = "name of the resource group."
}
variable "network_security_group" {
  type        = string
  default     = "app-sg"
  description = "name of the resource group."
}
variable "network_security_rule" {
  type        = string
  default     = "testdemo"
  description = "name of the resource group."
}
variable "network_interface" {
  type        = string
  default     = "demo-netintf"
  description = "name of the resource group."
}
variable "virtual_machine" {
  type        = string
  default     = "demo-vm"
  description = "name of the resource group."
}
/*variable "storage_account_name" {
  type        = string
  default     = "bandkharo"
  description = "name of the storage account."
}*/
