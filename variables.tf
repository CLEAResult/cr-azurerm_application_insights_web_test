variable "location" {
  default     = "southcentralus"
  description = "Location for resources to be created"
}

variable "num" {
  default = "1"
}

variable "name_prefix" {
  default     = ""
  description = "Allows users to override the standard naming prefix.  If left as an empty string, the standard naming conventions will apply."
}

variable "environment" {
  default     = "dev"
  description = "Environment used in naming lookups"
}

variable "resource_group_name" {
  description = "Azure resource group name that holds the application insights instance."
}

variable "application_insights_id" {
  description = "Azure resource ID of the application insights instance that will perform these tests."
}

variable "override_guid" {
  default     = ""
  description = "Optional override for Terraform-created GUID. Used in test HTTP requests. Ex: 0CF14444-4A06-4B4D-8211-7C96C2B72A34"
}

variable "test_url" {
  description = "URL to test. Ex: https://www.example.com/testme"
}

# Compute default name values
locals {
  env_id = lookup(module.naming.env-map, var.environment, "env")
  type = lookup(
    module.naming.type-map,
    "azurerm_application_insights",
    "typ",
  )

  test_hostname = split("/", var.test_url)[2]
  test_guid     = var.override_guid != "" ? var.override_guid : random_uuid.test.result
}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.1.0"
}

