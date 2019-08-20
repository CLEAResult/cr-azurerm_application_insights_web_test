provider "random" {
  version = "~> 2.1"
}

resource "random_id" "name" {
  byte_length = 8
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  version         = "~> 1.32.1"
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
  source                  = "../.."
  location                = var.location
  resource_group_name     = basename(module.rg.id)
  application_insights_id = azurerm_application_insights.test.id
  test_url                = "http://www.example.com"
}

# Test override GUID 
module "webtest2" {
  source                  = "../.."
  location                = var.location
  resource_group_name     = basename(module.rg.id)
  application_insights_id = azurerm_application_insights.test.id
  test_url                = "http://test.example.com"
  override_guid           = "CEDB65C5-EFA5-498B-A7AE-E1B8150C347F"
}

