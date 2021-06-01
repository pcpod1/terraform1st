data "azurerm_key_vault" "volt" {
  name                = "pushpenvault"
  resource_group_name = "StorageAccount-ResourceGroup"
}
data "azurerm_key_vault_secret" "volt" {
  name         = "adminaccess"
  key_vault_id = data.azurerm_key_vault.volt.id
}
