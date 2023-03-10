resource "azurerm_mysql_flexible_database" "mysql" {
  for_each            = var.databases
  name                = each.key
  resource_group_name = local.resource_group_name
  server_name         = azurerm_mysql_flexible_server.infra.name
  charset             = lookup(each.value, "charset", "utf8")
  collation           = lookup(each.value, "collation", "utf8_unicode_ci")
  depends_on = [
    azurerm_mysql_flexible_server.infra
  ]
}

resource "azurerm_mysql_flexible_server_configuration" "mysql-default" {
  for_each = var.server_parameters 

  name                = each.key
  resource_group_name = local.resource_group_name
  server_name         = azurerm_mysql_flexible_server.infra.name
  value               = each.value
  depends_on = [
    azurerm_mysql_flexible_server.infra
  ]
}