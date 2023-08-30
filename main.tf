terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resourceGroupDeploy" {
  name     = "jonathanRG"
  location = "East Us 2"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_account" "functionStorage" {
  name                     = "linuxFunctionAppSt"
  resource_group_name      = azurerm_resource_group.resourceGroupDeploy.name
  location                 = azurerm_resource_group.resourceGroupDeploy.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "appServicePlan" {
  name                = "jonAppPlan"
  resource_group_name = azurerm_resource_group.resourceGroupDeploy.name
  location            = azurerm_resource_group.resourceGroupDeploy.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "functionApp" {
  name                          = "jonFunctionApp"
  resource_group_name           = azurerm_resource_group.resourceGroupDeploy.name
  location                      = azurerm_resource_group.resourceGroupDeploy.location
  storage_account_name          = azurerm_storage_account.functionStorage.name
  service_plan_id               = azurerm_service_plan.appServicePlan.id
  storage_uses_managed_identity = true
  identity {
    type = "SystemAssigned"
  }
}