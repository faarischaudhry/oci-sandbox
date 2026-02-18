data "oci_identity_domain" "existing_domain" {
    domain_id = var.domain_id
}

resource "oci_identity_domains_group" "network_admins" {
    idcs_endpoint = data.oci_identity_domain.existing_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
    display_name = "NetworkAdmins"
}

resource "oci_identity_domains_group" "security_admins" {
    idcs_endpoint = data.oci_identity_domain.existing_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
    display_name = "SecurityAdmins"
}

resource "oci_identity_domains_group" "team1" {
    idcs_endpoint = data.oci_identity_domain.existing_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
    display_name = "Team1"
}

resource "oci_identity_domains_group" "team2" {
    idcs_endpoint = data.oci_identity_domain.existing_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
    display_name = "Team2"
}

/**
resource "oci_identity_domains_group" "team2" {
    idcs_endpoint = data.oci_identity_domain.existing_domain.url
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group"]
    display_name = "Team2"
}**/