resource "oci_identity_compartment" "sandbox" {
    compartment_id = var.tenancy_ocid
    name           = "Sandbox"
    description    = "A compartment at any level in the compartment hierarchy to hold the below compartments"
}

resource "oci_identity_compartment" "network" {
    compartment_id = oci_identity_compartment.sandbox.id
    name           = "Networking"
    description    = "For all networking resources"
}

resource "oci_identity_compartment" "security" {
    compartment_id = oci_identity_compartment.sandbox.id
    name           = "Security"
    description    = "For all logging, key management, scanning, and notifications resources"
}

resource "oci_identity_compartment" "appdev" {
    compartment_id = oci_identity_compartment.sandbox.id
    name           = "Application Development"
    description    = "For application development related services, including Compute, Storage, Functions, Streams, API Gateway, etc"
}

resource "oci_identity_compartment" "database" {
    compartment_id = oci_identity_compartment.sandbox.id
    name           = "Database"
    description    = "For all database resources"
}

# Optional (Depends if Exadata Infrastructure already exists)
resource "oci_identity_compartment" "exadata" {
    compartment_id = oci_identity_compartment.sandbox.id
    name           = "ExadataInfrastructure"
    description    = "While preparing for deploying Exadata Cloud Service, customers can choose between creating a specific compartment or using the Database compartment"
}