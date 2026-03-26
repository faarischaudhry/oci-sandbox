locals {
    database_compartment_name = "Database"
    network_compartment_name = "Networking"
    security_compartment_name = "Security"
    app_compartment_name = "ApplicationDevelopment"
    sandbox_compartment_name = "Sandbox"
    network_admin_group_name = "NetworkAdmins"
    security_admin_group_name = "SecurityAdmins"
    domain_name = var.domain_name
    team_groups_upper = {
        for name in var.group_names : name => upper(name)
    }
    all_groups = toset(concat(
        var.group_names,
        [local.network_admin_group_name, local.security_admin_group_name]
    ))
}

# Tag Namespace Policies
resource "oci_identity_policy" "basicTenancyPermissions" {
    for_each = local.all_groups

    compartment_id = oci_identity_compartment.sandbox.id
    description    = "Basic tenancy permissions for ${each.key}"
    name           = "basicPermissions-${each.key}"
    statements = [
        "allow group '${local.domain_name}'/'${each.key}' to use cloud-shell in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to read usage-budgets in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to read usage-reports in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to read objectstorage-namespaces in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to read tag-namespaces in compartment ${local.sandbox_compartment_name}",
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# Test Policy
resource "oci_identity_policy" "test1" {
    for_each = local.team_groups_upper

    compartment_id = oci_identity_compartment.appdev.id
    description = "Policies for ${each.key} to manage/read resources in AppDev compartment"
    name = "${each.key}Test1Policies"
    statements = [
        "allow group ${local.domain_name}/${each.key} manage instance-family in compartment ${local.app_compartment_name} where request.permission = 'INSTANCE_CREATE'",
        "allow any-user to manage instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'"    
    ]

    depends_on = [oci_identity_domains_group.groups]
}

resource "oci_identity_policy" "test2" {
    for_each = local.team_groups_upper

    compartment_id = oci_identity_compartment.database.id
    description = "Policies for ${each.key} to manage/read resources in Database compartment"
    name = "${each.key}Test2Policies"
    statements = [
        "allow any-user to manage instance-family in compartment ${local.database_compartment_name} where request.principal.group.tag.team.name = '${each.value}'"   
    ]

    depends_on = [oci_identity_domains_group.groups]
}   

# Team 1 Policies

# DB Admin Grants
resource "oci_identity_policy" "teamDBPolicies" {
    for_each = local.team_groups_upper

    compartment_id = oci_identity_compartment.database.id
    description = "Policies for ${each.key} to manage/read resources in DB compartment"
    name = "${each.key}DBPolicies"
    statements = [
        # all-resources
        "allow group '${local.domain_name}'/'${each.key}' to read all-resources in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # db-systems
        "allow group '${local.domain_name}'/'${each.key}' to {DB_SYSTEM_CREATE} db-systems in compartment ${local.database_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use db-systems in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # db-systems perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {DB_SYSTEM_DELETE} db-systems in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # db-nodes
        "allow group '${local.domain_name}'/'${each.key}' to manage db-nodes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # db-homes
        "allow group '${local.domain_name}'/'${each.key}' to {DB_HOME_CREATE} db-homes in compartment ${local.database_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use db-homes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # db-homes perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {DB_HOME_DELETE} db-homes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # databases
        "allow group '${local.domain_name}'/'${each.key}' to {DATABASE_CREATE} databases in compartment ${local.database_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # databases perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {DATABASE_DELETE} databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # pluggable-databases
        "allow group '${local.domain_name}'/'${each.key}' to {PLUGGABLE_DATABASE_CREATE} pluggable-databases in compartment ${local.database_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use pluggable-databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # pluggable-databases perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {PLUGGABLE_DATABASE_DELETE} pluggable-databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # db-backups
        "allow group '${local.domain_name}'/'${each.key}' to {DB_BACKUP_CREATE} db-backups in compartment ${local.database_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use db-backups in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # db-backups perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {DB_BACKUP_DELETE} db-backups in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # autonomous-database-family
        "allow group '${local.domain_name}'/'${each.key}' to {AUTONOMOUS_DATABASE_CREATE} autonomous-database-family in compartment ${local.database_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # autonomous-database-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {AUTONOMOUS_DATABASE_DELETE, NETWORK_SECURITY_GROUP_UPDATE_MEMBERS} autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # alarms
        "allow group '${local.domain_name}'/'${each.key}' to {ALARM_CREATE} alarms in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # all alarms perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {ALARM_UPDATE, ALARM_DELETE, ALARM_MOVE} alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",   

        # metrics
        "allow group '${local.domain_name}'/'${each.key}' to manage metrics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # cloudevents-rules
        "allow group '${local.domain_name}'/'${each.key}' to {EVENTRULE_CREATE} cloudevents-rules in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # cloudevents-rules perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {EVENTRULE_DELETE, EVENTRULE_MODIFY} cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        

        # CIS 1.2 - 1.14 Level 2

        # object-family
        "allow group '${local.domain_name}'/'${each.key}' to {BUCKET_CREATE, OBJECT_CREATE} object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group '${local.domain_name}'/'${each.key}' to use object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= '${each.value}'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage objectstorage-namespaces in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        # object-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {BUCKET_DELETE, PAR_MANAGE, RETENTION_RULE_MANAGE, RETENTION_RULE_LOCK, OBJECT_DELETE, OBJECT_VERSION_DELETE, OBJECT_RESTORE, OBJECT_UPDATE_TIER} object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= '${each.value}'}",
        
        # instance-family
        "allow group '${local.domain_name}'/'${each.key}' to {INSTANCE_CREATE, INSTANCE_IMAGE_CREATE, CONSOLE_HISTORY_CREATE, INSTANCE_CONSOLE_CONNECTION_CREATE, VOLUME_ATTACHMENT_CREATE} instance-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        # all instance-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {INSTANCE_DELETE, INSTANCE_ATTACH_SECONDARY_VNIC, INSTANCE_DETACH_SECONDARY_VNIC, CONSOLE_HISTORY_CREATE, CONSOLE_HISTORY_DELETE, INSTANCE_CONSOLE_CONNECTION_CREATE, INSTANCE_CONSOLE_CONNECTION_DELETE, INSTANCE_IMAGE_DELETE, INSTANCE_IMAGE_MOVE, APP_CATALOG_LISTING_SUBSCRIBE, VOLUME_ATTACHMENT_DELETE} instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # volume-family
        "allow group '${local.domain_name}'/'${each.key}' to {VOLUME_CREATE, VOLUME_ATTACHMENT_CREATE, VOLUME_BACKUP_CREATE, BOOT_VOLUME_BACKUP_CREATE, BACKUP_POLICIES_CREATE, BACKUP_POLICY_ASSIGNMENT_CREATE, VOLUME_GROUP_CREATE, VOLUME_GROUP_BACKUP_CREATE} volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group '${local.domain_name}'/'${each.key}' to use volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= '${each.value}'}",
        # volume-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {VOLUME_DELETE, VOLUME_MOVE, VOLUME_ATTACHMENT_DELETE, VOLUME_BACKUP_DELETE, VOLUME_BACKUP_MOVE, BOOT_VOLUME_BACKUP_DELETE, BOOT_VOLUME_BACKUP_MOVE, BACKUP_POLICIES_DELETE, BACKUP_POLICY_ASSIGNMENT_DELETE, VOLUME_GROUP_UPDATE, VOLUME_GROUP_DELETE, VOLUME_GROUP_MOVE, VOLUME_GROUP_BACKUP_UPDATE, VOLUME_GROUP_BACKUP_DELETE, VOLUME_GROUP_BACKUP_MOVE} volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= '${each.value}'}",

        # file-family
        "allow group '${local.domain_name}'/'${each.key}' to {EXPORT_SET_CREATE, FILE_SYSTEM_CREATE, FILESYSTEM_SNAPSHOT_POLICY_CREATE, MOUNT_TARGET_CREATE, OUTBOUND_CONNECTOR_CREATE, REPLICATION_CREATE} file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
        "allow group '${local.domain_name}'/'${each.key}' to use file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= '${each.value}'}",
        # file-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {EXPORT_SET_UPDATE, EXPORT_SET_DELETE, FILE_SYSTEM_UPDATE, FILE_SYSTEM_DELETE, FILE_SYSTEM_MOVE, FILE_SYSTEM_CREATE_SNAPSHOT, FILE_SYSTEM_DELETE_SNAPSHOT, FILE_SYSTEM_CLONE, FILE_SYSTEM_REPLICATION_TARGET, FILESYSTEM_SNAPSHOT_POLICY_UPDATE, FILESYSTEM_SNAPSHOT_POLICY_MOVE, FILESYSTEM_SNAPSHOT_POLICY_DELETE, MOUNT_TARGET_UPDATE, MOUNT_TARGET_SHAPE_UPGRADE, MOUNT_TARGET_SHAPE_DOWNGRADE, MOUNT_TARGET_DELETE, MOUNT_TARGET_MOVE, OUTBOUND_CONNECTOR_UPDATE, OUTBOUND_CONNECTOR_DELETE, OUTBOUND_CONNECTOR_MOVE, REPLICATION_UPDATE, REPLICATION_DELETE, REPLICATION_MOVE} file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= '${each.value}'}",

        # orm-stacks
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_STACK_CREATE} orm-stacks in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_STACK_UPDATE, ORM_STACK_MOVE, ORM_STACK_DELETE} orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # orm-jobs
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-jobs in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # orm-config-source-providers
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_CONFIG_SOURCE_PROVIDER_CREATE} orm-config-source-providers in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # orm-config-source-providers perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_CONFIG_SOURCE_PROVIDER_UPDATE, ORM_CONFIG_SOURCE_PROVIDER_MOVE, ORM_CONFIG_SOURCE_PROVIDER_DELETE} orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # ons-family
        "allow group '${local.domain_name}'/'${each.key}' to {ONS_TOPIC_CREATE} ons-family in compartment ${local.database_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use ons-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # ons-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {ONS_TOPIC_MOVE, ONS_TOPIC_UPDATE, ONS_TOPIC_DELETE} ons-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # logging-family
        "allow group '${local.domain_name}'/'${each.key}' to {LOG_GROUP_CREATE, UNIFIED_AGENT_CONFIG_CREATE} logging-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # all logging-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {LOG_GROUP_DELETE, UNIFIED_AGENT_CONFIG_DELETE} logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
       
        # audit-events
        "allow group '${local.domain_name}'/'${each.key}' to read audit-events in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # work-requests
        "allow group '${local.domain_name}'/'${each.key}' to read work-requests in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # bastion-session
        "allow group '${local.domain_name}'/'${each.key}' to manage bastion-session in compartment ${local.database_compartment_name}",

        # instance-agent-plugins
        "allow group '${local.domain_name}'/'${each.key}' to read instance-agent-plugins in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # data-safe-family NO INFO IN DOCS
        "allow group '${local.domain_name}'/'${each.key}' to manage data-safe-family in compartment ${local.database_compartment_name}",
        
        # vnics
        "allow group '${local.domain_name}'/'${each.key}' to use vnics in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # keys
        "allow group '${local.domain_name}'/'${each.key}' to {KEY_CREATE} keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        "allow group '${local.domain_name}'/'${each.key}' to use keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # keys perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {KEY_UPDATE, KEY_ROTATE, KEY_DELETE, KEY_MOVE, KEY_IMPORT, KEY_BACKUP, KEY_RESTORE} keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
       
        # key-delegate
        "allow group '${local.domain_name}'/'${each.key}' to use key-delegate in compartment ${local.app_compartment_name}",
        
        # secret-family
        "allow group '${local.domain_name}'/'${each.key}' to manage secret-family in compartment ${local.app_compartment_name}",

        # autonomous-database-family
        "allow group '${local.domain_name}'/'${each.key}' to read autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # database-family
        "allow group '${local.domain_name}'/'${each.key}' to read database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# DB/AppDev Admin Grants
resource "oci_identity_policy" "teamNetworkPolicies" {
    for_each = local.team_groups_upper

    compartment_id = oci_identity_compartment.network.id
    description = "Policies for ${each.value} to manage/read resources in Networking Compartment"
    name = "${each.value}NetworkPolicies"
    statements = [ 
        "allow group '${local.domain_name}'/'${each.key}' to read virtual-network-family in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use vnics in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to manage private-ips in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use subnets in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use network-security-groups in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use load-balancers in compartment ${local.network_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# DB/AppDev Admin Grants
resource "oci_identity_policy" "teamSecurityPolicies" {
    for_each = local.team_groups_upper

    compartment_id = oci_identity_compartment.security.id
    description = "Policies for ${each.value} to manage/read resources in Security Compartment"
    name = "${each.value}SecurityPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${each.key}' to read vss-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use vaults in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to read logging-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use bastion in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to manage bastion-session in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to manage instance-images in compartment ${local.security_compartment_name}",
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# AppDev Admin Grants
resource "oci_identity_policy" "teamAppDevPolicies" {
    for_each = local.team_groups_upper

    compartment_id = oci_identity_compartment.appdev.id
    description = "Policies for Team 1 to manage/read resources in AppDev Compartment"
    name = "${each.value}AppDevPolicies"
    statements = [
        # all-resources
        "allow group '${local.domain_name}'/'${each.key}' to read all-resources in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # functions-family
        "allow group '${local.domain_name}'/'${each.key}' to {FN_APP_CREATE, FN_FUNCTION_CREATE} functions-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use functions-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # functions-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {FN_APP_DELETE, FN_APP_UPDATE, FN_FUNCTION_DELETE, FN_FUNCTION_UPDATE} functions-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # api-gateway-family
        "allow group '${local.domain_name}'/'${each.key}' to {API_GATEWAY_CREATE, API_DEPLOYMENT_CREATE, API_DEFINITION_CREATE, API_CERTIFICATE_CREATE, API_SDK_CREATE, API_SUBSCRIBER_CREATE, API_USAGE_PLAN_CREATE} api-gateway-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use api-gateway-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # api-gateway-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {API_GATEWAY_DELETE, API_GATEWAY_UPDATE, API_GATEWAY_MOVE, API_DEPLOYMENT_DELETE, API_DEPLOYMENT_MOVE, API_DEFINITION_DELETE, API_CERTIFICATE_DELETE, API_CERTIFICATE_UPDATE, API_CERTIFICATE_MOVE, API_SDK_DELETE, API_SUBSCRIBER_CREATE, API_SUBSCRIBER_DELETE, API_SUBSCRIBER_MOVE, API_USAGE_PLAN_DELETE, API_USAGE_PLAN_MOVE} api-gateway-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # ons-family
        "allow group '${local.domain_name}'/'${each.key}' to {ONS_TOPIC_CREATE} ons-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use ons-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # ons-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {ONS_TOPIC_MOVE, ONS_TOPIC_UPDATE, ONS_TOPIC_DELETE, ONS_SUBSCRIPTION_MOVE, ONS_TOPIC_SUBSCRIBE} ons-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # streams
        "allow group '${local.domain_name}'/'${each.key}' to {STREAM_CREATE} streams in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use streams in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # streams perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {STREAM_DELETE} streams in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # cluster-family
        "allow group '${local.domain_name}'/'${each.key}' to {CLUSTER_CREATE, CLUSTER_NODE_POOL_CREATE, CLUSTER_VIRTUAL_NODE_POOL_CREATE, CLUSTER_WORKLOAD_MAPPING_CREATE} cluster-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use cluster-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # cluster-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {CLUSTER_DELETE, CLUSTER_UPDATE, CLUSTER_MANAGE, CLUSTER_JOIN, CLUSTER_NODE_POOL_DELETE, CLUSTER_NODE_POOL_UPDATE, CLUSTER_VIRTUAL_NODE_POOL_UPDATE, CLUSTER_VIRTUAL_NODE_POOL_DELETE, CLUSTER_WORK_REQUEST_DELETE, CLUSTER_WORKLOAD_MAPPING_DELETE} cluster-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # alarms
        "allow group '${local.domain_name}'/'${each.key}' to {ALARM_CREATE} alarms in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # all alarms perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {ALARM_UPDATE, ALARM_DELETE, ALARM_MOVE} alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",   

        # metrics
        "allow group '${local.domain_name}'/'${each.key}' to manage metrics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # logging-family
        "allow group '${local.domain_name}'/'${each.key}' to {LOG_GROUP_CREATE, UNIFIED_AGENT_CONFIG_CREATE} logging-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # all logging-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {LOG_GROUP_DELETE, UNIFIED_AGENT_CONFIG_DELETE} logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # instance-family
        "allow group '${local.domain_name}'/'${each.key}' to {INSTANCE_CREATE, INSTANCE_IMAGE_CREATE, CONSOLE_HISTORY_CREATE, INSTANCE_CONSOLE_CONNECTION_CREATE, VOLUME_ATTACHMENT_CREATE} instance-family in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        # all instance-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {INSTANCE_DELETE, INSTANCE_ATTACH_SECONDARY_VNIC, INSTANCE_DETACH_SECONDARY_VNIC, CONSOLE_HISTORY_CREATE, CONSOLE_HISTORY_DELETE, INSTANCE_CONSOLE_CONNECTION_CREATE, INSTANCE_CONSOLE_CONNECTION_DELETE, INSTANCE_IMAGE_DELETE, INSTANCE_IMAGE_MOVE, APP_CATALOG_LISTING_SUBSCRIBE, VOLUME_ATTACHMENT_DELETE} instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",


        # CIS 1.2 - 1.14 Level 2

        # volume-family
        "allow group '${local.domain_name}'/'${each.key}' to {VOLUME_CREATE, VOLUME_ATTACHMENT_CREATE, VOLUME_BACKUP_CREATE, BOOT_VOLUME_BACKUP_CREATE, BACKUP_POLICIES_CREATE, BACKUP_POLICY_ASSIGNMENT_CREATE, VOLUME_GROUP_CREATE, VOLUME_GROUP_BACKUP_CREATE} volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group '${local.domain_name}'/'${each.key}' to use volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= '${each.value}'}",
        # volume-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {VOLUME_DELETE, VOLUME_MOVE, VOLUME_ATTACHMENT_DELETE, VOLUME_BACKUP_DELETE, VOLUME_BACKUP_MOVE, BOOT_VOLUME_BACKUP_DELETE, BOOT_VOLUME_BACKUP_MOVE, BACKUP_POLICIES_DELETE, BACKUP_POLICY_ASSIGNMENT_DELETE, VOLUME_GROUP_UPDATE, VOLUME_GROUP_DELETE, VOLUME_GROUP_MOVE, VOLUME_GROUP_BACKUP_UPDATE, VOLUME_GROUP_BACKUP_DELETE, VOLUME_GROUP_BACKUP_MOVE} volume-family in compartment ${local.app_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= '${each.value}'}",

        # object-family
        "allow group '${local.domain_name}'/'${each.key}' to {BUCKET_CREATE, OBJECT_CREATE} object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group '${local.domain_name}'/'${each.key}' to use object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= '${each.value}'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage objectstorage-namespaces in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        # object-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {BUCKET_DELETE, PAR_MANAGE, RETENTION_RULE_MANAGE, RETENTION_RULE_LOCK, OBJECT_DELETE, OBJECT_VERSION_DELETE, OBJECT_RESTORE, OBJECT_UPDATE_TIER} object-family in compartment ${local.app_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= '${each.value}'}",

        # file-family
        "allow group '${local.domain_name}'/'${each.key}' to {EXPORT_SET_CREATE, FILE_SYSTEM_CREATE, FILESYSTEM_SNAPSHOT_POLICY_CREATE, MOUNT_TARGET_CREATE, OUTBOUND_CONNECTOR_CREATE, REPLICATION_CREATE} file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
        "allow group '${local.domain_name}'/'${each.key}' to use file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= '${each.value}'}",
        # file-family perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {EXPORT_SET_UPDATE, EXPORT_SET_DELETE, FILE_SYSTEM_UPDATE, FILE_SYSTEM_DELETE, FILE_SYSTEM_MOVE, FILE_SYSTEM_CREATE_SNAPSHOT, FILE_SYSTEM_DELETE_SNAPSHOT, FILE_SYSTEM_CLONE, FILE_SYSTEM_REPLICATION_TARGET, FILESYSTEM_SNAPSHOT_POLICY_UPDATE, FILESYSTEM_SNAPSHOT_POLICY_MOVE, FILESYSTEM_SNAPSHOT_POLICY_DELETE, MOUNT_TARGET_UPDATE, MOUNT_TARGET_SHAPE_UPGRADE, MOUNT_TARGET_SHAPE_DOWNGRADE, MOUNT_TARGET_DELETE, MOUNT_TARGET_MOVE, OUTBOUND_CONNECTOR_UPDATE, OUTBOUND_CONNECTOR_DELETE, OUTBOUND_CONNECTOR_MOVE, REPLICATION_UPDATE, REPLICATION_DELETE, REPLICATION_MOVE} file-family in compartment ${local.app_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= '${each.value}'}",

        # repos
        "allow group '${local.domain_name}'/'${each.key}' to {REPOSITORY_CREATE} repos in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use repos in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        "allow group '${local.domain_name}'/'${each.key}' to {REPOSITORY_DELETE, REPOSITORY_UPDATE, REPOSITORY_MANAGE} repos in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # orm-stacks
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_STACK_CREATE} orm-stacks in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_STACK_UPDATE, ORM_STACK_MOVE, ORM_STACK_DELETE} orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # orm-jobs
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-jobs in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # orm-config-source-providers
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_CONFIG_SOURCE_PROVIDER_CREATE} orm-config-source-providers in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # orm-config-source-providers perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {ORM_CONFIG_SOURCE_PROVIDER_UPDATE, ORM_CONFIG_SOURCE_PROVIDER_MOVE, ORM_CONFIG_SOURCE_PROVIDER_DELETE} orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # audit-events
        "allow group '${local.domain_name}'/'${each.key}' to read audit-events in compartment ${local.app_compartment_name}",

        # work-requests
        "allow group '${local.domain_name}'/'${each.key}' to read work-requests in compartment ${local.app_compartment_name}",

        # bastion-session
        "allow group '${local.domain_name}'/'${each.key}' to manage bastion-session in compartment ${local.app_compartment_name}",

        # cloudevents-rules
        "allow group '${local.domain_name}'/'${each.key}' to {EVENTRULE_CREATE} cloudevents-rules in compartment ${local.app_compartment_name}",
        "allow group '${local.domain_name}'/'${each.key}' to use cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # cloudevents-rules perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {EVENTRULE_DELETE, EVENTRULE_MODIFY} cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # instance-agent-plugins
        "allow group '${local.domain_name}'/'${each.key}' to read instance-agent-plugins in compartment ${local.app_compartment_name}",

        # keys
        "allow group '${local.domain_name}'/'${each.key}' to {KEY_CREATE} keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        "allow group '${local.domain_name}'/'${each.key}' to use keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        # keys perms included in "manage" but not "use"
        "allow group '${local.domain_name}'/'${each.key}' to {KEY_UPDATE, KEY_ROTATE, KEY_DELETE, KEY_MOVE, KEY_IMPORT, KEY_BACKUP, KEY_RESTORE} keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # key-delegate
        "allow group '${local.domain_name}'/'${each.key}' to use key-delegate in compartment ${local.app_compartment_name}",
        
        # secret-family
        "allow group '${local.domain_name}'/'${each.key}' to manage secret-family in compartment ${local.app_compartment_name}",
        
        # vnics
        "allow group '${local.domain_name}'/'${each.key}' to use vnics in compartment ${local.app_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# Root Grants
/**
resource "oci_identity_policy" "${each.value}SandboxPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Team 1 to manage/read resources in Sandbox Compartment"
    name = "${each.value}SandboxPolicies"
    statements = [
        "allow group ${join(",", local.admin_groups)} to read app-catalog-listing in tenancy",
        "allow group ${join(",", local.admin_groups)} to read instance-images in tenancy",
        "allow group ${join(",", local.admin_groups)} to read repos in tenancy"
    ]
}
**/

/**
# Root Grants
resource "oci_identity_policy" "team2SandboxPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Team 2 to manage/read resources in Sandbox Compartment"
    name = "team2SandboxPolicies"
    statements = [
        "allow group ${local.domain_name}/${local.admin_group_name_2} to read app-catalog-listing in tenancy",
        "allow group ${local.domain_name}/${local.admin_group_name_2} to read instance-images in tenancy",
        "allow group ${local.domain_name}/${local.admin_group_name_2} to read repos in tenancy"
    ]
}**/

# Network Policies

# Root Grants
/**
resource "oci_identity_policy" "networkRootPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Network Admins to manage/read resources at root level"
    name = "networkRootPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read zpr-configuration in tenancy",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read zpr-policy in tenancy",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read security-attribute-namespace in tenancy"
    ]
}
**/

# Networking Grants
resource "oci_identity_policy" "networkNetworkingPolicies" {
    compartment_id = oci_identity_compartment.network.id
    description = "Policies for Network Admins to manage/read resources in Networking Compartment"
    name = "networkNetworkingPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read all-resources in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage virtual-network-family in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage dns in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage load-balancers in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage alarms in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage metrics in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage ons-family in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage orm-stacks in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage orm-jobs in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage orm-config-source-providers in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read audit-events in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read work-requests in compartment ${local.network_compartment_name}",
        # CIS 1.2 - 1.14 Level 2
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage instance-family in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage volume-family in compartment ${local.network_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage object-family in compartment ${local.network_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage file-family in compartment ${local.network_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage bastion-session in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage cloudevents-rules in compartment ${local.network_compartment_name}",
        # "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage alarms in compartment ${local.network_compartment_name}",
        # "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage metrics in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read instance-agent-plugins in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage keys in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to use key-delegate in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage secret-family in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage network-firewall-family in compartment ${local.network_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# Security Grants
resource "oci_identity_policy" "networkSecurityPolicies" {
    compartment_id = oci_identity_compartment.security.id
    description = "Policies for Network Admins to manage/read resources in Security Compartment"
    name = "networkSecurityPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read vss-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to use bastion in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to manage bastion-session in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to use vaults in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.network_admin_group_name}' to read logging-family in compartment ${local.security_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# Security Policies

# Root Grants
/**
resource "oci_identity_policy" "securityRootPolicies" {
    compartment_id = var.tenancy_ocid
    description = "Policies for Security Admins to manage/read resources at root level"
    name = "securityRootPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage cloudevents-rules in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage cloud-guard-family in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read tenancies in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read objectstorage-namespaces in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to use cloud-shell in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read usage-budgets in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read usage-reports in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage zpr-configuration in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage zpr-policy in tenancy",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage security-attribute-namespace in tenancy"
    ]
}
**/

# Sandbox Grants
resource "oci_identity_policy" "securitySandboxPolicies" {
    compartment_id = oci_identity_compartment.sandbox.id
    description = "Policies for Security Admins to manage/read resources in Sandbox compartment"
    name = "securitySandboxPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage tag-namespaces in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage tag-defaults in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage repos in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read audit-events in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read app-catalog-listing in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read instance-images in compartment ${local.sandbox_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to inspect buckets in compartment ${local.sandbox_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# Security Grants
resource "oci_identity_policy" "securitySecurityPolicies" {
    compartment_id = oci_identity_compartment.security.id
    description = "Policies for Security Admins to manage/read resources in Security compartment"
    name = "securitySecurityPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read all-resources in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage instance-family in compartment ${local.security_compartment_name}",
        # CIS 1.2 - 1.14 Level 2
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage volume-family in compartment ${local.security_compartment_name} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage object-family in compartment ${local.security_compartment_name} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage file-family in compartment ${local.security_compartment_name} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage vaults in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage keys in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage secret-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage logging-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage serviceconnectors in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage streams in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage ons-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage functions-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage waas-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage security-zone in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage orm-stacks in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage orm-jobs in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage orm-config-source-providers in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage vss-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read work-requests in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage bastion-family in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read instance-agent-plugins in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage cloudevents-rules in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage alarms in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage metrics in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to use key-delegate in compartment ${local.security_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage agcs-instance in compartment ${local.security_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# Network Grants
resource "oci_identity_policy" "securityNetworkPolicies" {
    compartment_id = oci_identity_compartment.network.id
    description = "Policies for Security Admins to manage/read resources in Network compartment"
    name = "securityNetworkPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read virtual-network-family in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to use subnets in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to use network-security-groups in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to use vnics in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to manage private-ips in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read keys in compartment ${local.network_compartment_name}",
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to use network-firewall-family in compartment ${local.network_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# AppDev Grants
resource "oci_identity_policy" "securityAppDevPolicies" {
    compartment_id = oci_identity_compartment.appdev.id
    description = "Security Admins can read keys in AppDev compartment"
    name = "securityAppDevPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read keys in compartment ${local.app_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}

# DB Grants
resource "oci_identity_policy" "securityDBPolicies" {
    compartment_id = oci_identity_compartment.database.id
    description = "Security Admins can read keys in Database compartment"
    name = "securityDBPolicies"
    statements = [
        "allow group '${local.domain_name}'/'${local.security_admin_group_name}' to read keys in compartment ${local.database_compartment_name}"
    ]

    depends_on = [oci_identity_domains_group.groups]
}