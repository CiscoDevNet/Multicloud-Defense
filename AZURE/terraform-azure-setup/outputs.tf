output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "app_id" {
  value = azuread_application.ciscomcd-controller.application_id
}

output "app_name" {
  value = azuread_application.ciscomcd-controller.display_name
}

output "secret_key" {
  value     = azuread_application_password.ciscomcd_controller_secret.value
  sensitive = true
}

output "subscription_ids" {
  value = local.subscription_guids_list
}

output "iam_role" {
  value = azurerm_role_definition.ciscomcd_controller_role.name
}
