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

variable "test_name" {
  description = "Name of azure web test resource.  Example: \"test1.example.com-webtest\""
}

variable "list_of_test_urls" {
  type        = list(string)
  description = "List of URLs to put in the availability tests.  Example: [\"https://test1.example.com\", \"https://test2.example.com/app\"]"
}

variable "parse_deps" {
  default     = "False"
  description = "Retrieve resources that are linked to by the test URL as part of the web test. Valid values are \"True\" or \"False\". Default value is \"False\"."
}

variable "list_of_test_locations" {
  type        = list(string)
  default     = ["us-ca-sjc-azr","us-tx-sn1-azr","us-il-ch1-azr","us-va-ash-azr","us-fl-mia-edge"]
  description = "List of Azure locations that will perform the specified web tests. Default is set to 5 US locations.  Microsoft recommendation is a minimum of 5 test locations with an alert threshold of N-2. Ref: https://docs.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability"
}

variable "test_body" {
  default = "<Request Method=\"GET\" Guid=\"%s\" Version=\"1.1\" Url=\"%s\" ThinkTime=\"0\" Timeout=\"300\" ParseDependentRequests=\"PARSEDEPS\" FollowRedirects=\"True\" RecordResult=\"True\" Cache=\"False\" ResponseTimeGoal=\"0\" Encoding=\"utf-8\" ExpectedHttpStatusCode=\"200\" ExpectedResponseUrl=\"\" ReportingName=\"\" IgnoreHttpStatusCode=\"False\" />"
  description = "WebTest XML Request body.  If overridden, make sure to retain all the string format() parameters needed by the local variable calculations."
}

variable "frequency" {
  default = 300
  description = "Interval in seconds between test runs for this WebTest. Default is 300."
}

variable "timeout" {
  default = 30
  description = "Seconds until this WebTest will timeout and fail. Default is 30."
}

variable "enabled" {
  default = true
  description = "Is the test actively being monitored."
}

variable "retry_enabled" {
  default = true
  description = "Allow for retries should this WebTest fail."
}

variable "description" {
  default = ""
  description = "Purpose/user defined descriptive test for this WebTest."
}

# Compute default name values
locals {
  env_id = lookup(module.naming.env-map, var.environment, "env")
  type = lookup(
    module.naming.type-map,
    "azurerm_application_insights",
    "typ",
  )

  header = "<WebTest Name=\"WebTest1\" Id=\"%s\" Enabled=\"True\" CssProjectStructure=\"\" CssIteration=\"\" Timeout=\"0\" WorkItemIds=\"\" xmlns=\"http://microsoft.com/schemas/VisualStudio/TeamTest/2010\" Description=\"%s\" CredentialUserName=\"\" CredentialPassword=\"\" PreAuthenticate=\"True\" Proxy=\"default\" StopOnError=\"False\" RecordedResultFile=\"\" ResultsLocale=\"\"><Items>"
  footer = "</Items></WebTest>"

  test_header   = format(local.header, random_uuid.parent.result, var.description)
  replace_body  = replace(var.test_body, "PARSEDEPS", var.parse_deps)
}


# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::https://github.com/CLEAResult/cr-azurerm-naming.git?ref=v1.1.0"
}

