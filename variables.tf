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
