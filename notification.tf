# this be where notifications are
resource "oci_ons_notification_topic" "test_notification_topic" {
    #Required
    compartment_id = ocid1.compartment.oc1..aaaaaaaa2ipyqhgat7gbkiqsqniivd4smro7n4xh4qfgq7hu5phwtjpij44q
    name = "test_notification_id"
}
