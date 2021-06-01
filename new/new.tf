provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "volt" {
  name     = "StorageAccount-ResourceGroup"
  location = "east us"
}
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "volt" {
  name                        = "pushpenvault"
  location                    = azurerm_resource_group.volt.location
  resource_group_name         = azurerm_resource_group.volt.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "list", "create", "delete", "update"
    ]

    secret_permissions = [
      "Get", "list", "delete", "set"
    ]
  }
}
resource "azurerm_storage_account" "volt" {
  name                     = "abcd12345"
  resource_group_name      = azurerm_resource_group.volt.name
  location                 = azurerm_resource_group.volt.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "volt" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.volt.name
  container_access_type = "private"
}
