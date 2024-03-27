resource "azuread_application" "ciscomcd-controller" {
  display_name = "${var.prefix}-ciscomcd-controller"
}

resource "azuread_service_principal" "ciscomcd-controller" {
  application_id = azuread_application.ciscomcd-controller.application_id
}

resource "azuread_application_password" "ciscomcd_controller_secret" {
  display_name          = "ciscomcd-controller-secret"
  end_date_relative     = "43800h" // 5 years
  application_object_id = azuread_application.ciscomcd-controller.object_id
}
