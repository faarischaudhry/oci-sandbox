locals {
    database_compartment_name = "Database"
    network_compartment_name = "Networking"
    security_compartment_name = "Security"
    app_compartment_name = "ApplicationDevelopment"
    policy_scope = "Sandbox"
    admin_group_name_1 = "Team1"
    admin_group_name_2 = "Team2"
    network_admin_group_name = "NetworkAdmins"
    security_admin_group_name = "SecurityAdmins"
    admin_groups = ["Team1", "Team2"]
}

# Team 1 Policies

# DB Admin Grants
resource "oci_identity_policy" "team1DBPolicies" {
    compartment_id = oci_identity_compartment.database.id
    description = "Policies for Team 1 to manage/read resources in DB compartment"
    name = "team1DBPolicies"
    statements = [
        "allow group ${local.admin_group_name_1} to read all-resources in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage db-systems in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage db-nodes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage db-homes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage pluggable-databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage db-backups in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage alarms in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage metrics in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage cloudevents-rules in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        # CIS 1.2 - 1.14 Level 2
        "allow group ${local.admin_group_name_1} to manage object-family in compartment ${local.database_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name = 'TEAM1'}",
        "allow group ${local.admin_group_name_1} to manage instance-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage volume-family in compartment ${local.database_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name = 'TEAM1'}",
        "allow group ${local.admin_group_name_1} to manage file-family in compartment ${local.database_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name = 'TEAM1'}",
        "allow group ${local.admin_group_name_1} to manage orm-stacks in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage orm-jobs in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage orm-config-source-providers in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage ons-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage logging-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read audit-events in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read work-requests in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage bastion-session in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read instance-agent-plugins in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage data-safe-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to use vnics in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage keys in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to use key-delegate in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage secret-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'"
    ]
}

# DB/AppDev Admin Grants
resource "oci_identity_policy" "team1NetworkPolicies" {
    compartment_id = oci_identity_compartment.network.id
    description = "Policies for Team 1 to manage/read resources in Networking Compartment"
    name = "team1NetworkPolicies"
    statements = [ 
        "allow group ${join(",", local.admin_groups)} to read virtual-network-family in compartment ${local.network_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to use vnics in compartment ${local.network_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to manage private-ips in compartment ${local.network_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to use subnets in compartment ${local.network_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to use network-security-groups in compartment ${local.network_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to use load-balancers in compartment ${local.network_compartment_name}"
    ]
}

# DB/AppDev Admin Grants
resource "oci_identity_policy" "team1SecurityPolicies" {
    compartment_id = oci_identity_compartment.security.id
    description = "Policies for Team 1 to manage/read resources in Security Compartment"
    name = "team1SecurityPolicies"
    statements = [
        "allow group ${join(",", local.admin_groups)} to read vss-family in compartment ${local.security_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to use vaults in compartment ${local.security_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to read logging-family in compartment ${local.security_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to use bastion in compartment ${local.security_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to manage bastion-session in compartment ${local.security_compartment_name}",
        "allow group ${join(",", local.admin_groups)} to manage instance-images in compartment ${local.security_compartment_name}",
    ]
}

# AppDev Admin Grants
resource "oci_identity_policy" "team1AppDevPolicies" {
    compartment_id = oci_identity_compartment.appdev.id
    description = "Policies for Team 1 to manage/read resources in AppDev Compartment"
    name = "team1AppDevPolicies"
    statements = [
        "allow group ${local.admin_group_name_1} to read all-resources in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage functions-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage api-gateway-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage ons-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage streams in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage cluster-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage metrics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        # CIS 1.2 - 1.14 Level 2
        "allow group ${local.admin_group_name_1} to manage volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= 'TEAM1'}",
        "allow group ${local.admin_group_name_1} to manage object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= 'TEAM1'}",
        "allow group ${local.admin_group_name_1} to manage file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= 'TEAM1'}",
        "allow group ${local.admin_group_name_1} to manage repos in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage orm-jobs in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read audit-events in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read work-requests in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage bastion-session in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to read instance-agent-plugins in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to use key-delegate in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to manage secret-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.admin_group_name_1} to use vnics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'"
    ]
}

# Root Grants
resource "oci_identity_policy" "team1SandboxPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Team 1 to manage/read resources in Sandbox Compartment"
    name = "team1SandboxPolicies"
    statements = [
        "allow group ${join(",", local.admin_groups)} to read app-catalog-listing in tenancy",
        "allow group ${join(",", local.admin_groups)} to read instance-images in tenancy",
        "allow group ${join(",", local.admin_groups)} to read repos in tenancy"
    ]
}

# Team 2 Policies

# DB Admin Grants
resource "oci_identity_policy" "team2DBPolicies" {
    compartment_id = oci_identity_compartment.database.id
    description = "Policies for Team 2 to manage/read resources in DB compartment"
    name = "team2DBPolcies"
    statements = [
        "allow group ${local.admin_group_name_2} to read all-resources in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage db-systems in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage db-nodes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage db-homes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage pluggable-databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage db-backups in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage alarms in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage metrics in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage cloudevents-rules in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        # CIS 2.2 - 2.24 Level 2
        "allow group ${local.admin_group_name_2} to manage object-family in compartment ${local.database_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name = 'TEAM2'}",
        "allow group ${local.admin_group_name_2} to manage instance-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage volume-family in compartment ${local.database_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name = 'TEAM2'}",
        "allow group ${local.admin_group_name_2} to manage file-family in compartment ${local.database_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name = 'TEAM2'}",
        "allow group ${local.admin_group_name_2} to manage orm-stacks in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage orm-jobs in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage orm-config-source-providers in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage ons-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage logging-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read audit-events in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read work-requests in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage bastion-session in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read instance-agent-plugins in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage data-safe-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to use vnics in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage keys in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to use key-delegate in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage secret-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'"
    ]
}

/**
# DB/AppDev Admin Grants
resource "oci_identity_policy" "team2NetworkPolicies" {
    compartment_id = oci_identity_compartment.network.id
    description = "Policies for Team 2 to manage/read resources in Networking Compartment"
    name = "team2NetworkPolicies"
    statements = [ 
        "allow group ${local.admin_group_name_2} to read virtual-network-family in compartment ${local.network_compartment_name}",
        "allow group ${local.admin_group_name_2} to use vnics in compartment ${local.network_compartment_name}",
        "allow group ${local.admin_group_name_2} to manage private-ips in compartment ${local.network_compartment_name}",
        "allow group ${local.admin_group_name_2} to use subnets in compartment ${local.network_compartment_name}",
        "allow group ${local.admin_group_name_2} to use network-security-groups in compartment ${local.network_compartment_name}",
        "allow group ${local.admin_group_name_2} to use load-balancers in compartment ${local.network_compartment_name}"
    ]
}

# DB/AppDev Admin Grants
resource "oci_identity_policy" "team2SecurityPolicies" {
    compartment_id = oci_identity_compartment.security.id
    description = "Policies for Team 2 to manage/read resources in Security Compartment"
    name = "team2SecurityPolicies"
    statements = [
        "allow group ${local.admin_group_name_2} to read vss-family in compartment ${local.security_compartment_name}",
        "allow group ${local.admin_group_name_2} to use vaults in compartment ${local.security_compartment_name}",
        "allow group ${local.admin_group_name_2} to read logging-family in compartment ${local.security_compartment_name}",
        "allow group ${local.admin_group_name_2} to use bastion in compartment ${local.security_compartment_name}",
        "allow group ${local.admin_group_name_2} to manage bastion-session in compartment ${local.security_compartment_name}",
        "allow group ${local.admin_group_name_2} to manage instance-images in compartment ${local.security_compartment_name}",
    ]
}
**/

# AppDev Admin Grants
resource "oci_identity_policy" "team2AppDevPolicies" {
    compartment_id = oci_identity_compartment.appdev.id
    description = "Policies for Team 2 to manage/read resources in AppDev Compartment"
    name = "team2AppDevPolicies"
    statements = [
        "allow group ${local.admin_group_name_2} to read all-resources in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage functions-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage api-gateway-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage ons-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage streams in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage cluster-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage metrics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        # CIS 2.2 - 2.24 Level 2
        "allow group ${local.admin_group_name_2} to manage volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= 'TEAM2'}",
        "allow group ${local.admin_group_name_2} to manage object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= 'TEAM2'}",
        "allow group ${local.admin_group_name_2} to manage file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= 'TEAM2'}",
        "allow group ${local.admin_group_name_2} to manage repos in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage orm-jobs in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read audit-events in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read work-requests in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage bastion-session in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to read instance-agent-plugins in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to use key-delegate in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to manage secret-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
        "allow group ${local.admin_group_name_2} to use vnics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'"
    ]
}

/**
# Root Grants
resource "oci_identity_policy" "team2SandboxPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Team 2 to manage/read resources in Sandbox Compartment"
    name = "team2SandboxPolicies"
    statements = [
        "allow group ${local.admin_group_name_2} to read app-catalog-listing in tenancy",
        "allow group ${local.admin_group_name_2} to read instance-images in tenancy",
        "allow group ${local.admin_group_name_2} to read repos in tenancy"
    ]
}**/

# Network Policies

# Root Grants
resource "oci_identity_policy" "networkRootPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Network Amdins to manage/read resources at root level"
    name = "networkRootPolicies"
    statements = [
        "allow group ${local.network_admin_group_name} to read zpr-configuration in tenancy",
        "allow group ${local.network_admin_group_name} to read zpr-policy in tenancy",
        "allow group ${local.network_admin_group_name} to read security-attribute-namespace in tenancy"
    ]
}

# Networking Grants
resource "oci_identity_policy" "networkNetworkingPolicies" {
    compartment_id = oci_identity_compartment.network.id
    description = "Policies for Network Amdins to manage/read resources in Networking Compartment"
    name = "networkNetworkingPolicies"
    statements = [
        "allow group ${local.network_admin_group_name} to read all-resources in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage virtual-network-family in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage dns in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage load-balancers in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage alarms in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage metrics in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage ons-family in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage orm-stacks in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage orm-jobs in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage orm-config-source-providers in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to read audit-events in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to read work-requests in compartment ${local.network_compartment_name}",
        # CIS 1.2 - 1.14 Level 2
        "allow group ${local.network_admin_group_name} to manage instance-family in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage volume-family in compartment ${local.network_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group ${local.network_admin_group_name} to manage object-family in compartment ${local.network_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group ${local.network_admin_group_name} to manage file-family in compartment ${local.network_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
        "allow group ${local.network_admin_group_name} to manage bastion-session in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage cloudevents-rules in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage alarms in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage metrics in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to read instance-agent-plugins in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage keys in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to use key-delegate in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage secret-family in compartment ${local.network_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage network-firewall-family in compartment ${local.network_compartment_name}"
    ]
}

# Security Grants
resource "oci_identity_policy" "networkSecurityPolicies" {
    compartment_id = oci_identity_compartment.security.id
    description = "Policies for Network Amdins to manage/read resources in Security Compartment"
    name = "networkSecurityPolicies"
    statements = [
        "allow group ${local.network_admin_group_name} to read vss-family in compartment ${local.security_compartment_name}",
        "allow group ${local.network_admin_group_name} to use bastion in compartment ${local.security_compartment_name}",
        "allow group ${local.network_admin_group_name} to manage bastion-session in compartment ${local.security_compartment_name}",
        "allow group ${local.network_admin_group_name} to use vaults in compartment ${local.security_compartment_name}",
        "allow group ${local.network_admin_group_name} to read logging-family in compartment ${local.security_compartment_name}"
    ]
}

# Security Policies

# Root Grants
resource "oci_identity_policy" "securityRootPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Security Amdins to manage/read resources at root level"
    name = "securityRootPolicies"
    statements = [
        "allow group ${local.security_admin_group_name} to manage cloudevents-rules in tenancy",
        "allow group ${local.security_admin_group_name} to manage cloud-guard-family in tenancy",
        "allow group ${local.security_admin_group_name} to read tenancies in tenancy",
        "allow group ${local.security_admin_group_name} to read objectstorage-namespaces in tenancy",
        "allow group ${local.security_admin_group_name} to use cloud-shell in tenancy",
        "allow group ${local.security_admin_group_name} to read usage-budgets in tenancy",
        "allow group ${local.security_admin_group_name} to read usage-reports in tenancy",
        "allow group ${local.security_admin_group_name} to manage zpr-configuration in tenancy",
        "allow group ${local.security_admin_group_name} to manage zpr-policy in tenancy",
        "allow group ${local.security_admin_group_name} to manage security-attribute-namespace in tenancy"
    ]
}

# Sandbox Grants
resource "oci_identity_policy" "securitySandboxPolicies" {
    compartment_id = oci_identity_compartment.sandbox.id
    description = "Policies for Security Amdins to manage/read resources in Sandbox compartment"
    name = "securitySandboxPolicies"
    statements = [
        "allow group ${local.security_admin_group_name} to manage tag-namespaces in ${local.policy_scope}",
        "allow group ${local.security_admin_group_name} to manage tag-defaults in ${local.policy_scope}",
        "allow group ${local.security_admin_group_name} to manage repos in ${local.policy_scope}",
        "allow group ${local.security_admin_group_name} to read audit-events in ${local.policy_scope}",
        "allow group ${local.security_admin_group_name} to read app-catalog-listing in ${local.policy_scope}",
        "allow group ${local.security_admin_group_name} to read instance-images in ${local.policy_scope}",
        "allow group ${local.security_admin_group_name} to inspect buckets in ${local.policy_scope}"
    ]
}

# Security Grants
resource "oci_identity_policy" "securitySecurityPolicies" {
    compartment_id = oci_identity_compartment.security.id
    description = "Policies for Security Amdins to manage/read resources in Security compartment"
    name = "securitySecurityPolicies"
    statements = [
        "allow group ${local.security_admin_group_name} to read all-resources in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage instance-family in compartment ${local.security_compartment_name}",
        # CIS 1.2 - 1.14 Level 2
        "allow group ${local.security_admin_group_name} to manage volume-family in compartment ${local.security_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group ${local.security_admin_group_name} to manage object-family in compartment ${local.security_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group ${local.security_admin_group_name} to manage file-family in compartment ${local.security_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
        "allow group ${local.security_admin_group_name} to manage vaults in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage keys in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage secret-family in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage logging-family in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage serviceconnectors in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage streams in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage ons-family in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage functions-family in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage waas-family in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage security-zone in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage orm-stacks in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage orm-jobs in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage orm-config-source-providers in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage vss-family in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to read work-requests in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage bastion-family in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to read instance-agent-plugins in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage cloudevents-rules in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage alarms in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage metrics in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to use key-delegate in compartment ${local.security_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage agcs-instance in compartment ${local.security_compartment_name}"
    ]
}

# Network Grants
resource "oci_identity_policy" "securityNetworkPolicies" {
    compartment_id = oci_identity_compartment.network.id
    description = "Policies for Security Amdins to manage/read resources in Network compartment"
    name = "securityNetworkPolicies"
    statements = [
        "allow group ${local.security_admin_group_name} to read virtual-network-family in compartment ${local.network_compartment_name}",
        "allow group ${local.security_admin_group_name} to use subnets in compartment ${local.network_compartment_name}",
        "allow group ${local.security_admin_group_name} to use network-security-groups in compartment ${local.network_compartment_name}",
        "allow group ${local.security_admin_group_name} to use vnics in compartment ${local.network_compartment_name}",
        "allow group ${local.security_admin_group_name} to manage private-ips in compartment ${local.network_compartment_name}",
        "allow group ${local.security_admin_group_name} to read keys in compartment ${local.network_compartment_name}",
        "allow group ${local.security_admin_group_name} to use network-firewall-family in compartment ${local.network_compartment_name}"
    ]
}

# AppDev Grants
resource "oci_identity_policy" "securityAppDevPolicies" {
    compartment_id = oci_identity_compartment.appdev.id
    description = "Policies for Security Amdins to manage/read resources in AppDev compartment"
    name = "securityAppDevPolicies"
    statements = [
        "allow group ${local.security_admin_group_name} to read keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.security_admin_group_name} to read keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
    ]
}

# DB Grants
resource "oci_identity_policy" "securityDBPolicies" {
    compartment_id = oci_identity_compartment.database.id
    description = "Policies for Security Amdins to manage/read resources in Database compartment"
    name = "securityDBPolicies"
    statements = [
        "allow group ${local.security_admin_group_name} to read keys in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM1'",
        "allow group ${local.security_admin_group_name} to read keys in compartment ${local.database_compartment_name} where target.resource.tag.team.name= 'TEAM2'",
    ]
}