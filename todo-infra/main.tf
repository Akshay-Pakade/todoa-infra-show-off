module "azurerm_resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = "myapp-rg"
  location            = "Canada Central"
}

module "vnet" {
  depends_on = [ module.azurerm_resource_group ]
source = "../modules/virtual_network"
virtual_network_name = "myvnet"
resource_group_name = "myapp-rg"
location = "Canada Central"
address_space = ["10.0.0.0/16"]
}
module "vnet" {
  depends_on = [ module.azurerm_resource_group ]
source = "../modules/virtual_network"
virtual_network_name = "myvnet"
resource_group_name = "myapp-rg"
location = "Canada Central"
address_space = ["10.0.0.0/16"]
}
module "vnet" {
  depends_on = [ module.azurerm_resource_group ]
source = "../modules/virtual_network"
virtual_network_name = "myvnet"
resource_group_name = "myapp-rg"
location = "Canada Central"
address_space = ["10.0.0.0/16"]
}


module "key_vault" {
  depends_on = [ module.azurerm_resource_group ]
  source              = "../modules/key_vault"
  key_vault_name      = "akkitijori"
  location            = "Canada Central"
  resource_group_name = "myapp-rg"
  
}

module "secret_username" {
  depends_on = [ module.key_vault ]
  source              = "../modules/azurerm_secret"
  key_vault_name      = "akkitijori"
  resource_group_name = "myapp-rg"
  secret_name         = "vmusername"
  secret_value        = "ramadmin"
  
}

module "secret_password" {
  depends_on = [ module.key_vault ]
  source              = "../modules/azurerm_secret"
  key_vault_name      = "akkitijori"
  resource_group_name = "myapp-rg"
  secret_name         = "vmuserpassword"
  secret_value        = "akshay@123456"
  
}


module "public_ip" {
depends_on = [ module.azurerm_resource_group ]
  source              = "../modules/public_ip"
  pip_name            = "myapp-pip"
  location            = "Canada Central"
  resource_group_name = "myapp-rg"
  allocation_method   = "Static"
}

module "myvm"{
  depends_on = [ module.key_vault, module.secret_username, module.secret_password,module.vnet, module.public_ip, module.subnet ]
    source = "../modules/virtual_machine"
    nic_name = "mynic"
    location = "Canada Central"
    resource_group_name= "myapp-rg"
    subnet_name = "merasubnet"
    virtual_network_name = "myvnet"
    pip_name = "myapp-pip"
    vm_name = "myapp-vm"
    vm_size = "Standard_B1s"
    key_vault_name = "akkitijori"
    secret_username = "vmusername"
    secret_password_name = "vmuserpassword"
}

module "sql_server" {
  depends_on = [ module.azurerm_resource_group ]
  source              = "../modules/sql_server"
  resource_group_name = "myapp-rg"
  sql_server_name     = "myapp-sqlserver-akshay99"
  location = "Canada Central"
  administrator_login = "sqladmin"
  administrator_login_password = "akshayadmin@123456"
}

module "sql_database" {
  depends_on = [ module.sql_server ]
  
  source              = "../modules/database"
  sql_database_name       = "myappdb"
  resource_group_name  = "myapp-rg"
  sql_server_name     = "myapp-sqlserver-akshay99"

}