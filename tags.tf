resource "oci_identity_tag_namespace" "team_tags" {
    compartment_id = oci_identity_compartment.sandbox.id
    name = "team"
    description = "Team-based tags for resource ownership and access control"
    is_retired = false
}

resource "oci_identity_tag" "team_name" {
    tag_namespace_id = oci_identity_tag_namespace.team_tags.id
    name = "name"
    description = "Team name for resource ownership - MANDATORY"
    is_cost_tracking = true
    validator {
        validator_type = "ENUM"
        values = ["TEAM1", "TEAM2"]
    }
}

resource "oci_identity_tag_default" "appdev_team_name" {
    compartment_id = oci_identity_compartment.appdev.id
    tag_definition_id = oci_identity_tag.team_name.id
    value = "TEAM1"
    is_required = true
}

resource "oci_identity_tag_default" "database_team_name" {
    compartment_id = oci_identity_compartment.database.id
    tag_definition_id = oci_identity_tag.team_name.id
    value = "TEAM1"
    is_required = true
}