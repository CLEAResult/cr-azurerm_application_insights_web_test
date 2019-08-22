# cr-azurerm_application_insights_web_test

Creates an Azure application insights web test using default values.

# Required Input Variables

* `resource_group_name` - resource group name holding the application insights instance
* `application_insights_id` - azure resource ID of the application insights instance
* `test_name` - name of webtest that will show up in Azure portal
* `list_of_test_urls` - list of web URLs to test

# Optional Input Variable

* `frequency` - seconds between each test run; default 300
* `enabled` - is test eanbled? default true
* `timeout` - seconds before a lack of response is logged as failed; default 30
* `description` - more verbose description of this test
* `list_of_test_locations` - list of azure-specific identifiers of test locations - default is five US locations
* `test_body` - override web test XML body for a singled <Request /> - see variables description for more info
* `retry_enabled` - is retry logic enabled before logging test as failed? default false

# Example

See `test/fixture/*.tf`.

# Alerts

This module only creates availability tests in an Application Insights resource.  It does not set a threshold alert for failed tests.
This should be done with metric alerts and action groups, such as [https://www.terraform.io/docs/providers/azurerm/r/monitor_metric_alert.html](https://www.terraform.io/docs/providers/azurerm/r/monitor_metric_alert.html).
