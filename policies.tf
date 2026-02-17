resource "oci_identity_policy" "team1Policies" {
    compartment_id = oci_identity_compartment.appdev.id
    description = "Policies for Team 1 to manage resources in AppDev and DB"
    name = "team1Polcies"
    statements = [ 
        "allow group Team1 to manage database-family in compartment Database where target.resource.tag.team.name= 'TEAM1'",
        "allow group Team1 to manage instance-family in compartment AppDev where target.resource.tag.team.name= 'TEAM1'"
    ]
}

resource "oci_identity_policy" "team2Policies" {
    compartment_id = oci_identity_compartment.appdev.id
    description = "Policies for Team 2 to manage resources in AppDev and DB"
    name = "team2Policies"
    statements = [ 
        "allow group Team2 to manage database-family in compartment Database where target.resource.tag.team.name= 'TEAM2'",
        "allow group Team2 to manage instance-family in compartment AppDev where target.resource.tag.team.name= 'TEAM2'"
    ]
}