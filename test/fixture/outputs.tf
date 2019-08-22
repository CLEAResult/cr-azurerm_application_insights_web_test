# Resource group outputs
#
output "resource_group_id" {
  value = module.rg.id
}

output "resource_group_reader_group_name" {
  value = module.rg.readerName
}

#
# Webtest outputs
#
output "test_id" {
  value = module.webtest.id
}

output "test_synthetic_id" {
  value = module.webtest.synthetic_monitor_id
}

