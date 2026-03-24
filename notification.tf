# this be where notifications are
resource "oci_ons_notification_topic" "test_notification_topic" {
    #Required
    compartment_id = oci_identity_compartment.sandbox.id
    name = "test_notification_id"
}
