provider "random" {
  version = "~> 2.1"
}

resource "random_id" "name" {
  byte_length = 8
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  version         = "~> 1.33.1"
}

provider "azuread" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  version         = "0.5.1"
}

module "rg" {
  source          = "git::https://github.com/clearesult/cr-azurerm_resource_group.git?ref=v1.2.2"
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  create_date     = var.create_date
  subscription_id = var.subscription_id
}

resource "azurerm_application_insights" "test" {
  name                = format("r%s", random_id.name.hex)
  location            = var.location
  resource_group_name = basename(module.rg.id)
  application_type    = "web"
}

module "webtest" {
  source                  = "../../"
  location                = var.location
  resource_group_name     = basename(module.rg.id)
  application_insights_id = azurerm_application_insights.test.id
  test_name               = "exampleapp-webtest"
  list_of_test_urls       = ["https://www.example.com"]
  retry_enabled           = true
  enabled                 = true
  frequency               = 300
  timeout                 = 60
  description             = "Really handy terraform webtest"
  parse_deps              = "False"
}

resource "azurerm_monitor_metric_alert" "test" {
  name                = "example-metricalert"
  resource_group_name = basename(module.rg.id)
  scopes              = ["${azurerm_application_insights.test.id}"]
  description         = "Action will be triggered when failed location threshold is 3 or more out of 5."
  auto_mitigate       = false
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "availabilityResults/count"
    aggregation      = "Count"
    operator         = "GreaterThanOrEqual"
    threshold        = 3

    dimension {
      name     = "availabilityResult/name"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "availabilityResult/success"
      operator = "Include"
      values   = [0]
    }
  }

  action {
    action_group_id = "${azurerm_monitor_action_group.test.id}"
  }
}

resource "azurerm_monitor_action_group" "test" {
  name                = "CriticalAlertsAction"
  resource_group_name = basename(module.rg.id)
  short_name          = "p0action"

  email_receiver {
    name          = "sendtoadmin"
    email_address = "user@example.com"
  }

  sms_receiver {
    name         = "oncallmsg"
    country_code = "1"
    phone_number = "5555551212"
  }

  webhook_receiver {
    name        = "callmyapiaswell"
    service_uri = "http://example.com/alert"
  }
}
