resource "random_uuid" "parent" {}

resource "random_uuid" "test_guids" {
  count = length(var.list_of_test_urls)
  keepers = {
    url = var.list_of_test_urls[count.index]
  }
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
  geo_locations           = var.list_of_test_locations
  retry_enabled           = var.retry_enabled
  description             = var.description

  configuration = format("%s%s%s", 
    local.test_header, 
    join("", formatlist(local.replace_body, random_uuid.test_guids.*.result, random_uuid.test_guids.*.keepers.url)), 
    local.footer)
}

