terraform {
  required_providers {
    azurerm = {
      version = "~>3.0"
    }
  }
}
provider "azurerm" {
  features {}
}