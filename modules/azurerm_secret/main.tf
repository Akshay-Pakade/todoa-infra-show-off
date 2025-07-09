data "azurerm_key_vault" "keyvault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_key_vault_secret" "username" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = data.azurerm_key_vault.keyvault.id
  }