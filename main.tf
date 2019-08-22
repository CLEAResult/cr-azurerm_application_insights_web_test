resource "random_uuid" "parent" {}

resource "random_uuid" "test_guids" {
  count = length(var.list_of_test_urls)
}

resource "azurerm_application_insights_web_test" "test" {
  name                    = var.test_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = var.application_insights_id
  kind                    = "ping"
  frequency               = var.frequency
  timeout                 = var.timeout
  enabled                 = var.enabled
  geo_locations           = ["us-tx-sn1-azr", "us-il-ch1-azr"]
  retry_enabled           = var.retry_enabled
  description             = var.description

  configuration = format("%s%s%s", local.test_header, join("", local.test_body), local.footer)
}

