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
        "allow group '${local.domain_name}'/'${each.key}' to manage db-systems in compartment ${local.database_compartment_name} where request.permission = 'DB_SYSTEM_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage db-systems in compartment ${local.database_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # db-nodes
        "allow group '${local.domain_name}'/'${each.key}' to manage db-nodes in compartment ${local.database_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # db-homes
        "allow group '${local.domain_name}'/'${each.key}' to manage db-homes in compartment ${local.database_compartment_name} where request.permission = 'DB_HOME_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage db-homes in compartment ${local.database_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # databases
        "allow group '${local.domain_name}'/'${each.key}' to manage databases in compartment ${local.database_compartment_name} where request.permission = 'DATABASE_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # pluggable-databases
        "allow group '${local.domain_name}'/'${each.key}' to manage pluggable-databases in compartment ${local.database_compartment_name} where request.permission = 'PLUGGABLE_DATABASE_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage pluggable-databases in compartment ${local.database_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # db-backups
        "allow group '${local.domain_name}'/'${each.key}' to manage db-backups in compartment ${local.database_compartment_name} where request.permission = 'DB_BACKUP_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage db-backups in compartment ${local.database_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # autonomous-database-family
        "allow group '${local.domain_name}'/'${each.key}' to manage autonomous-database-family in compartment ${local.database_compartment_name} where request.permission = 'AUTONOMOUS_DATABASE_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage autonomous-database-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # alarms
        "allow group '${local.domain_name}'/'${each.key}' to manage alarms in compartment ${local.app_compartment_name} where request.permission = 'ALARM_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",   

        # metrics
        "allow group '${local.domain_name}'/'${each.key}' to manage metrics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # cloudevents-rules
        "allow group '${local.domain_name}'/'${each.key}' to manage cloudevents-rules in compartment ${local.app_compartment_name} where request.permission = 'EVENTRULE_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        

        # CIS 1.2 - 1.14 Level 2

        # object-family
        "allow group '${local.domain_name}'/'${each.key}' to manage object-family in compartment ${local.app_compartment_name} where all {request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', any {request.permission = 'OBJECT_CREATE', request.permission = 'BUCKET_CREATE'}}",
        "allow group '${local.domain_name}'/'${each.key}' to manage object-family in compartment ${local.app_compartment_name} where all {request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= '${each.value}'}",
        
        # instance-family
        "allow group '${local.domain_name}'/'${each.key}' to manage instance-family in compartment ${local.app_compartment_name} where any {request.permission = 'INSTANCE_CREATE', request.permission = 'INSTANCE_IMAGE_CREATE', request.permission = 'CONSOLE_HISTORY_CREATE', request.permission = 'INSTANCE_CONSOLE_CONNECTION_CREATE', request.permission = 'VOLUME_ATTACHMENT_CREATE'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # volume-family
        "allow group '${local.domain_name}'/'${each.key}' to manage volume-family in compartment ${local.app_compartment_name} where all {request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', any {request.permission = 'VOLUME_CREATE', request.permission = 'VOLUME_ATTACHMENT_CREATE', request.permission = 'VOLUME_BACKUP_CREATE', request.permission = 'BOOT_VOLUME_BACKUP_CREATE', request.permission = 'BACKUP_POLICIES_CREATE', request.permission = 'BACKUP_POLICY_ASSIGNMENT_CREATE', request.permission = 'VOLUME_GROUP_CREATE', request.permission = 'VOLUME_GROUP_BACKUP_CREATE'}}",
        "allow group '${local.domain_name}'/'${each.key}' to manage volume-family in compartment ${local.app_compartment_name} where all {request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= '${each.value}'}",

        # file-family
        "allow group '${local.domain_name}'/'${each.key}' to manage file-family in compartment ${local.app_compartment_name} where all {request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', any {request.permission = 'EXPORT_SET_CREATE', request.permission = 'FILE_SYSTEM_CREATE', request.permission = 'FILESYSTEM_SNAPSHOT_POLICY_CREATE', request.permission = 'MOUNT_TARGET_CREATE', request.permission = 'OUTBOUND_CONNECTOR_CREATE', request.permission = 'REPLICATION_CREATE'}}",
        "allow group '${local.domain_name}'/'${each.key}' to manage file-family in compartment ${local.app_compartment_name} where all {request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= '${each.value}'}",

        # orm-stacks
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-stacks in compartment ${local.app_compartment_name} where request.permission = 'ORM_STACK_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",

        # orm-jobs
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-jobs in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # orm-config-source-providers
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-config-source-providers in compartment ${local.app_compartment_name} where request.permission = 'ORM_CONFIG_SOURCE_PROVIDER_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",

        # ons-family
        "allow group '${local.domain_name}'/'${each.key}' to manage ons-family in compartment ${local.database_compartment_name} where request.permission = 'ONS_TOPIC_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage ons-family in compartment ${local.database_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # logging-family
        "allow group '${local.domain_name}'/'${each.key}' to manage logging-family in compartment ${local.app_compartment_name} where any {request.permission = 'LOG_GROUP_CREATE', request.permission = 'UNIFIED_AGENT_CONFIG_CREATE'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
       
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
        "allow group '${local.domain_name}'/'${each.key}' to manage keys in compartment ${local.app_compartment_name} where request.permission = 'KEY_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
       
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
        "allow group '${local.domain_name}'/'${each.key}' to manage functions-family in compartment ${local.app_compartment_name} where any {request.permission = 'FN_APP_CREATE', request.permission = 'FN_FUNCTION_CREATE'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage functions-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # api-gateway-family
        "allow group '${local.domain_name}'/'${each.key}' to manage api-gateway-family in compartment ${local.app_compartment_name} where any {request.permission = 'API_GATEWAY_CREATE', request.permission = 'API_DEPLOYMENT_CREATE', request.permission = 'API_DEFINITION_CREATE', request.permission = 'API_CERTIFICATE_CREATE', request.permission = 'API_SDK_CREATE', request.permission = 'API_SUBSCRIBER_CREATE', request.permission = 'API_USAGE_PLAN_CREATE'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage api-gateway-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # ons-family
        "allow group '${local.domain_name}'/'${each.key}' to manage ons-family in compartment ${local.app_compartment_name} where request.permission = 'ONS_TOPIC_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage ons-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",

        # streams
        "allow group '${local.domain_name}'/'${each.key}' to manage streams in compartment ${local.app_compartment_name} where request.permission = 'STREAM_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage streams in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # cluster-family
        "allow group '${local.domain_name}'/'${each.key}' to manage cluster-family in compartment ${local.app_compartment_name} where any {request.permission = 'CLUSTER_CREATE', request.permission = 'CLUSTER_NODE_POOL_CREATE', request.permission = 'CLUSTER_VIRTUAL_NODE_POOL_CREATE', request.permission = 'CLUSTER_WORKLOAD_MAPPING_CREATE'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage cluster-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # alarms
        "allow group '${local.domain_name}'/'${each.key}' to manage alarms in compartment ${local.app_compartment_name} where request.permission = 'ALARM_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage alarms in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",   

        # metrics
        "allow group '${local.domain_name}'/'${each.key}' to manage metrics in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",
        
        # logging-family
        "allow group '${local.domain_name}'/'${each.key}' to manage logging-family in compartment ${local.app_compartment_name} where any {request.permission = 'LOG_GROUP_CREATE', request.permission = 'UNIFIED_AGENT_CONFIG_CREATE'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage logging-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # instance-family
        "allow group '${local.domain_name}'/'${each.key}' to manage instance-family in compartment ${local.app_compartment_name} where any {request.permission = 'INSTANCE_CREATE', request.permission = 'INSTANCE_IMAGE_CREATE', request.permission = 'CONSOLE_HISTORY_CREATE', request.permission = 'INSTANCE_CONSOLE_CONNECTION_CREATE', request.permission = 'VOLUME_ATTACHMENT_CREATE'}",
        "allow group '${local.domain_name}'/'${each.key}' to manage instance-family in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",


        # CIS 1.2 - 1.14 Level 2

        # volume-family
        "allow group '${local.domain_name}'/'${each.key}' to manage volume-family in compartment ${local.app_compartment_name} where all {request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', any {request.permission = 'VOLUME_CREATE', request.permission = 'VOLUME_ATTACHMENT_CREATE', request.permission = 'VOLUME_BACKUP_CREATE', request.permission = 'BOOT_VOLUME_BACKUP_CREATE', request.permission = 'BACKUP_POLICIES_CREATE', request.permission = 'BACKUP_POLICY_ASSIGNMENT_CREATE', request.permission = 'VOLUME_GROUP_CREATE', request.permission = 'VOLUME_GROUP_BACKUP_CREATE'}}",
        "allow group '${local.domain_name}'/'${each.key}' to manage volume-family in compartment ${local.app_compartment_name} where all {request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE', target.resource.tag.team.name= '${each.value}'}",

        # object-family
        "allow group '${local.domain_name}'/'${each.key}' to manage object-family in compartment ${local.app_compartment_name} where all {request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', any {request.permission = 'OBJECT_CREATE', request.permission = 'BUCKET_CREATE'}}",
        "allow group '${local.domain_name}'/'${each.key}' to manage object-family in compartment ${local.app_compartment_name} where all {request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE', target.resource.tag.team.name= '${each.value}'}",

        # file-family
        "allow group '${local.domain_name}'/'${each.key}' to manage file-family in compartment ${local.app_compartment_name} where all {request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', any {request.permission = 'EXPORT_SET_CREATE', request.permission = 'FILE_SYSTEM_CREATE', request.permission = 'FILESYSTEM_SNAPSHOT_POLICY_CREATE', request.permission = 'MOUNT_TARGET_CREATE', request.permission = 'OUTBOUND_CONNECTOR_CREATE', request.permission = 'REPLICATION_CREATE'}}",
        "allow group '${local.domain_name}'/'${each.key}' to manage file-family in compartment ${local.app_compartment_name} where all {request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT', target.resource.tag.team.name= '${each.value}'}",

        # repos
        "allow group '${local.domain_name}'/'${each.key}' to manage repos in compartment ${local.app_compartment_name} where request.permission = 'REPOSITORY_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage repos in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",

        # orm-stacks
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-stacks in compartment ${local.app_compartment_name} where request.permission = 'ORM_STACK_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-stacks in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",

        # orm-jobs
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-jobs in compartment ${local.app_compartment_name} where target.resource.tag.team.name= '${each.value}'",

        # orm-config-source-providers
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-config-source-providers in compartment ${local.app_compartment_name} where request.permission = 'ORM_CONFIG_SOURCE_PROVIDER_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage orm-config-source-providers in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",

        # audit-events
        "allow group '${local.domain_name}'/'${each.key}' to read audit-events in compartment ${local.app_compartment_name}",

        # work-requests
        "allow group '${local.domain_name}'/'${each.key}' to read work-requests in compartment ${local.app_compartment_name}",

        # bastion-session
        "allow group '${local.domain_name}'/'${each.key}' to manage bastion-session in compartment ${local.app_compartment_name}",

        # cloudevents-rules
        "allow group '${local.domain_name}'/'${each.key}' to manage cloudevents-rules in compartment ${local.app_compartment_name} where request.permission = 'EVENTRULE_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage cloudevents-rules in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
        # instance-agent-plugins
        "allow group '${local.domain_name}'/'${each.key}' to read instance-agent-plugins in compartment ${local.app_compartment_name}",

        # keys
        "allow group '${local.domain_name}'/'${each.key}' to manage keys in compartment ${local.app_compartment_name} where request.permission = 'KEY_CREATE'",
        "allow group '${local.domain_name}'/'${each.key}' to manage keys in compartment ${local.app_compartment_name} where target.resource.tag.team.name = '${each.value}'",
        
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