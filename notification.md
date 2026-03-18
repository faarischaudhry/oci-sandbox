resource "oci_ons_notification_topic" "test_notification_topic" {
    # Required
    compartment_id = "ocid1.compartment.oc1..aaaaaaaa2ipyqhgat7gbkiqsqniivd4smro7n4xh4qfgq7hu5phwtjpij44q"
    name = "Sandbox Notification"

   # Optional
   # defined_tags = {"Operations.CostCenter"= "42"}
   # description = var.notification_topic_description
   # freeform_tags = {"Department"= "Finance"}
}
