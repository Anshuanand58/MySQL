locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.infra.*.name, azurerm_resource_group.infra.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.infra.*.location, azurerm_resource_group.infra.*.location, [""]), 0)
}

data "azurerm_resource_group" "infra" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "infra" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

data "azurerm_subnet" "infra" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg_name
  virtual_network_name = var.vnet_name
}

data "azurerm_private_dns_zone" "infra" {
  name                = var.private_dns_zone
  resource_group_name = var.private_dns_zone_rg
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "mysql" {
  name                = var.kv_pointer_name
  resource_group_name = var.kv_pointer_rg
}

resource "random_password" "mysql" {
  length  = 16
  special = false
  numeric = true
}
#Create Key Vault Secret
resource "azurerm_key_vault_secret" "mysql" {
  name         = var.mysqlserver_name
  value        = random_password.mysql.result
  key_vault_id = data.azurerm_key_vault.mysql.id
}


resource "azurerm_mysql_flexible_server" "infra" {
  name                         = var.mysqlserver_name
  resource_group_name          = local.resource_group_name
  location                     = local.location
  administrator_login          = var.admin_username
  administrator_password       = azurerm_key_vault_secret.mysql.value
  backup_retention_days        = var.backup_retention_days
  delegated_subnet_id          = data.azurerm_subnet.infra.id
  private_dns_zone_id          = data.azurerm_private_dns_zone.infra.id
  sku_name                     = var.sku
  version                      = var.mysqlversion
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  dynamic "storage" {
    for_each = var.autostorage == true ? [1] : []
    content {
      auto_grow_enabled = var.autostorage
      iops              = var.iops
      size_gb           = var.size_gb
    }
  }
  tags = var.tags
  depends_on = [
    data.azurerm_subnet.infra, data.azurerm_private_dns_zone.infra
  ]

  lifecycle {
    ignore_changes = [
      administrator_password, administrator_login, tags, zone
    ]
  }
}
