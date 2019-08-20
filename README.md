# cr-azurerm_application_insights_web_test

Creates an Azure application insights web test using default values.

# Required Input Variables

* `resource_group_name` - resource group name holding the application insights instance
* `application_insights_id` - azure resource ID of the application insights instance
* `test_url` - URL to test

# Optional Input Variable

* `override_guid` - supply your own web test GUID

# Example

See `test/fixture/*.tf`.
