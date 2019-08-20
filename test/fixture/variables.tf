variable "rgid" {}

variable "environment" {}

variable "location" {}

variable "create_date" {}

variable "subscription_id" {}

variable "tenant_id" {}

variable "resource_group_name" {
  description = "Azure resource group name that holds the application insights instance."
}

variable "test_url" {
  description = "URL to test. Ex: https://www.example.com/testme"
}
