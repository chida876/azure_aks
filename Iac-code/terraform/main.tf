terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "aksbh"
    storage_account_name = "case4sa"
    container_name       = "containerbh"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "d22f2ddf6-14f7-47a6-839c-519af4933770"
  client_id       = "4fb5acf6-26df-4106-914c-c86cd5786a53"
  tenant_id       = "061063d8-e9e3-44dc-bef9-1dbe159ed745"
  client_secret   = "966ffe92-7bbf-4d2e-a0f4-aa47fa39f93e"
}


data "azurerm_resource_group" "rg" {
  name = "aksbh"
}


resource "azurerm_service_plan" "plan" {
  name                = "${var.planname}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku_name            = "S1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "app" {
  name                = "${var.appname}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = true
  }
}