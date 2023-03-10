variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = ""
}

variable "location" {
  description = "Location of resource group"
  type        = string
  default     = ""
}
variable "subnet_name" {
  description = "Subnet Name"
  type        = string
  default     = ""
}

variable "vnet_rg_name" {
  description = "VNET RG NAME"
  type        = string
  default     = ""
}

variable "vnet_name" {
  description = "VNET Name"
  type        = string
  default     = ""
}

variable "private_dns_zone" {
  description = "Private DNS Zone Name"
  type        = string
  default     = ""
}

variable "private_dns_zone_rg" {
  description = "Private DNS Zone RG"
  type        = string
  default     = ""
}


variable "sku" {
  description = "SKU for MySQL - Example = GP_Standard_D2ds_v4 "
  type        = string
  default     = ""
  /*Example = GP_Standard_D2ds_v4 */
}

variable "mysqlversion" {
  description = "MySQL Flexible Server Version - Supported Version = 5.7 & 8.0.21"
  type        = string
  default     = ""
  /*Supported Version = 5.7 & 8.0.21 */
}


variable "iops" {
  description = "IOPS for the MySQL Server Supported -  IOPS = 360 to upto 20000"
  type        = number
  default     = 1000
  /*Supported IOPS = 360 to upto 20000 */
}

variable "size_gb" {
  description = "MySQL Felxible Server Storage Size - Supported Storage = 20 to upto 16384  in GB"
  type        = number
  default     = 50
  /*Supported Storage = 20 to upto 16384  in GB*/
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "create_resource_group" {
  type        = bool
  default     = false
  description = "whether to create a resource group or not"
}

variable "kv_pointer_name" {
  description = "Name of key vault"
  type        = string
  default     = ""
  /*Example = GP_Standard_D2ds_v4 */
}

variable "kv_pointer_rg" {
  description = "Name of resource group for key vault"
  type        = string
  default     = ""
}

variable "kv_pointer_sqladmin_password" {
  description = "secrets for mysql username and password "
  type        = string
  default     = ""
}

variable "mysqlserver_name" {
  description = "Name my sql flexible server "
  type        = string
  default     = ""
}

variable "zone" {
  description = "Number of zones"
  type        = number
  default     = 1
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  default     = false
  description = "whether to enable geo redundant backup or not"
}

variable "autostorage" {
  type        = bool
  default     = false
  description = "whether to enable auto increment of storage for mysql"
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "server_parameters" {
  description = <<EOF
    Map of configuration options: https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-server-parameters. Merged with default_server_parameters local:
    ```
    log_bin_trust_function_creators = "ON"
    connect_timeout                 = 60
    interactive_timeout             = 28800
    wait_timeout                    = 28800
    ```
  EOF
  type        = map(string)
  default     = {}
}


variable "databases" {
  type        = map(map(string))
  description = "(Required) The name, collation, and character set of the MySQL database(s). (defaults: charset='utf8', collation='utf8_unicode_ci')"
  default     = {}
}

variable "admin_username" {
  description = "Name of admin usename of mysql"
  type        = string
  default     = ""
}

variable "high_availability" {
  description = "Name of admin usename of mysql"
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "Id of the storage"
  type        = string
}

variable "logs" {
  description = "Logs that needs to be enabled"
  type = list(object({
    name           = string,
    enabled        = bool,
    retention_days = optional(number),
  }))
  default = [
    {
      name           = "AuditEvent",
      enabled        = false,
      retention_days = 0,
    }
  ]
}

variable "metrics" {
  description = "metrics that needs to be enabled"
  type = list(object({
    name           = optional(string),
    enabled        = optional(bool),
    retention_days = optional(number),
  }))
  default = [
    {
      name           = "AllMetrics",
      enabled        = false,
      retention_days = 0,
    }
  ]
}
