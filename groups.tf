data "oci_identity_domain" "existing_domain" {
    domain_id = var.domain_id
}

resource "oci_identity_domains_group" "sandbox_admins" {
    idcs_endpoint = data.oci_identity_domain.existing_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
    display_name = "SandboxAdmins"
}

resource "oci_identity_domains_group" "groups" {
    for_each = toset(var.group_names)
    idcs_endpoint = data.oci_identity_domain.existing_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
    display_name = each.value
}