data "azurerm_subnet" "mysubnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}
data "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "username" {
  name         = var.secret_username
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "password" {
  name         = var.secret_password_name
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault" "keyvault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}






resource "azurerm_network_interface" "my_nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "myvm"{

    name = var.vm_name
    resource_group_name = var.resource_group_name
    admin_username = data.azurerm_key_vault_secret.username.value
    admin_password = data.azurerm_key_vault_secret.password.value
    location = var.location
    size = var.vm_size
    disable_password_authentication = false
   
    network_interface_ids = [azurerm_network_interface.my_nic.id]
 os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        }
    
        source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
        }
     }


