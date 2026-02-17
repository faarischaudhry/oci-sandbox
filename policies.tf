resource "oci_identity_policy" "network_admin_policy" {
    compartment_id = oci_identity_compartment.network.id
    name           = "network-admin-policy"
    description    = "Policy for NetworkAdmins group to manage network related services in the Networking compartment."

    statements = [
        # Full visibility
        "allow group NetworkAdmins to read all-resources in compartment Sandbox:Networking",

        # Core networking
        "allow group NetworkAdmins to manage virtual-network-family in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage dns in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage load-balancers in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage network-firewall-family in compartment Sandbox:Networking",

        # Monitoring & alerting
        "allow group NetworkAdmins to manage alarms in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage metrics in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage ons-family in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage cloudevents-rules in compartment Sandbox:Networking",

        # ORM (Resource Manager)
        "allow group NetworkAdmins to manage orm-stacks in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage orm-jobs in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage orm-config-source-providers in compartment Sandbox:Networking",

        # Audit & work requests
        "allow group NetworkAdmins to read audit-events in compartment Sandbox:Networking",
        "allow group NetworkAdmins to read work-requests in compartment Sandbox:Networking",

        # Compute & storage (no delete permissions)
        "allow group NetworkAdmins to manage instance-family in compartment Sandbox:Networking",
        "allow group NetworkAdmins to read instance-agent-plugins in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage volume-family in compartment Sandbox:Networking where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group NetworkAdmins to manage object-family in compartment Sandbox:Networking where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group NetworkAdmins to manage file-family in compartment Sandbox:Networking where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",

        # Bastion
        "allow group NetworkAdmins to manage bastion-session in compartment Sandbox:Networking",

        # Key management / secrets
        "allow group NetworkAdmins to manage keys in compartment Sandbox:Networking",
        "allow group NetworkAdmins to use key-delegate in compartment Sandbox:Networking",
        "allow group NetworkAdmins to manage secret-family in compartment Sandbox:Networking",
    ]
}

# --- Security compartment policy (cross-compartment access) ---
resource "oci_identity_policy" "network_admin_security_policy" {
    compartment_id = oci_identity_compartment.security.id
    name           = "network-admin-security-policy"
    description    = "Policy for NetworkAdmins group to access security resources needed for network operations (bastion, vaults, logging)."

    statements = [
        # Vulnerability scanning visibility
        "allow group NetworkAdmins to read vss-family in compartment Sandbox:Security",

        # Bastion access
        "allow group NetworkAdmins to use bastion in compartment Sandbox:Security",
        "allow group NetworkAdmins to manage bastion-session in compartment Sandbox:Security",

        # Vault access (for encryption keys used by networking resources)
        "allow group NetworkAdmins to use vaults in compartment Sandbox:Security",

        # VCN flow logs (log group lives in Security per logging.tf)
        "allow group NetworkAdmins to read logging-family in compartment Sandbox:Security",
    ]
}

# --- Root / tenancy-level policy ---
resource "oci_identity_policy" "network_admin_root_policy" {
    compartment_id = var.tenancy_ocid
    name           = "network-admin-root-policy"
    description    = "Root compartment policy for NetworkAdmins group."

    statements = [
        # ZPR & security attributes (tenancy-scoped)
        "allow group NetworkAdmins to read zpr-configuration in tenancy",
        "allow group NetworkAdmins to read zpr-policy in tenancy",
        "allow group NetworkAdmins to read security-attribute-namespace in tenancy",

        # General tenancy-level utilities (shared with other admin groups)
        "allow group NetworkAdmins to use cloud-shell in tenancy",
        "allow group NetworkAdmins to read usage-budgets in tenancy",
        "allow group NetworkAdmins to read usage-reports in tenancy",
        "allow group NetworkAdmins to read objectstorage-namespaces in tenancy",
        "allow group NetworkAdmins to read tag-namespaces in tenancy",
    ]
}

resource "oci_identity_policy" "security_admin_sandbox_policy" {
    compartment_id = oci_identity_compartment.sandbox.id
    name           = "security-admin-sandbox-policy"
    description    = "Policy for SecurityAdmins group to manage security-related services in the Sandbox enclosing compartment."

    statements = [
        # Tag management
        "allow group SecurityAdmins to manage tag-namespaces in compartment Sandbox",
        "allow group SecurityAdmins to manage tag-defaults in compartment Sandbox",

        # Container registry
        "allow group SecurityAdmins to manage repos in compartment Sandbox",

        # Read-only visibility across the enclosing compartment
        "allow group SecurityAdmins to read audit-events in compartment Sandbox",
        "allow group SecurityAdmins to read app-catalog-listing in compartment Sandbox",
        "allow group SecurityAdmins to read instance-images in compartment Sandbox",
        "allow group SecurityAdmins to inspect buckets in compartment Sandbox",
    ]
}

# --- Security compartment policy ---
resource "oci_identity_policy" "security_admin_policy" {
    compartment_id = oci_identity_compartment.security.id
    name           = "security-admin-policy"
    description    = "Policy for SecurityAdmins group to manage security resources in the Security compartment."

    statements = [
        # Full visibility
        "allow group SecurityAdmins to read all-resources in compartment Sandbox:Security",

        # Compute & storage (no delete permissions)
        "allow group SecurityAdmins to manage instance-family in compartment Sandbox:Security",
        "allow group SecurityAdmins to read instance-agent-plugins in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage volume-family in compartment Sandbox:Security where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
        "allow group SecurityAdmins to manage object-family in compartment Sandbox:Security where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
        "allow group SecurityAdmins to manage file-family in compartment Sandbox:Security where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",

        # Key management / secrets / vaults
        "allow group SecurityAdmins to manage vaults in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage keys in compartment Sandbox:Security",
        "allow group SecurityAdmins to use key-delegate in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage secret-family in compartment Sandbox:Security",

        # Logging & service connectors (VCN flow logs live here per logging.tf)
        "allow group SecurityAdmins to manage logging-family in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage serviceconnectors in compartment Sandbox:Security",

        # Streams, notifications, functions
        "allow group SecurityAdmins to manage streams in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage ons-family in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage functions-family in compartment Sandbox:Security",

        # Web application firewall & security zones
        "allow group SecurityAdmins to manage waas-family in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage security-zone in compartment Sandbox:Security",

        # ORM (Resource Manager)
        "allow group SecurityAdmins to manage orm-stacks in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage orm-jobs in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage orm-config-source-providers in compartment Sandbox:Security",

        # Vulnerability scanning & bastion
        "allow group SecurityAdmins to manage vss-family in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage bastion-family in compartment Sandbox:Security",

        # Monitoring & alerting
        "allow group SecurityAdmins to manage cloudevents-rules in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage alarms in compartment Sandbox:Security",
        "allow group SecurityAdmins to manage metrics in compartment Sandbox:Security",

        # Work requests
        "allow group SecurityAdmins to read work-requests in compartment Sandbox:Security",

        # Access Governance
        "allow group SecurityAdmins to manage agcs-instance in compartment Sandbox:Security",
    ]
}

# --- Networking compartment policy (cross-compartment access) ---
resource "oci_identity_policy" "security_admin_network_policy" {
    compartment_id = oci_identity_compartment.network.id
    name           = "security-admin-network-policy"
    description    = "Policy for SecurityAdmins group to access networking resources needed for security operations."

    statements = [
        # Network visibility & usage (for deploying security tooling into the VCN)
        "allow group SecurityAdmins to read virtual-network-family in compartment Sandbox:Networking",
        "allow group SecurityAdmins to use subnets in compartment Sandbox:Networking",
        "allow group SecurityAdmins to use network-security-groups in compartment Sandbox:Networking",
        "allow group SecurityAdmins to use vnics in compartment Sandbox:Networking",
        "allow group SecurityAdmins to manage private-ips in compartment Sandbox:Networking",

        # Network firewall & key visibility
        "allow group SecurityAdmins to use network-firewall-family in compartment Sandbox:Networking",
        "allow group SecurityAdmins to read keys in compartment Sandbox:Networking",
    ]
}

# --- Root / tenancy-level policy ---
resource "oci_identity_policy" "security_admin_root_policy" {
    compartment_id = var.tenancy_ocid
    name           = "security-admin-root-policy"
    description    = "Root compartment policy for SecurityAdmins group."

    statements = [
        # Cloud Guard (tenancy-scoped)
        "allow group SecurityAdmins to manage cloud-guard-family in tenancy",
        "allow group SecurityAdmins to manage cloudevents-rules in tenancy",

        # ZPR & security attributes (tenancy-scoped)
        "allow group SecurityAdmins to manage zpr-configuration in tenancy",
        "allow group SecurityAdmins to manage zpr-policy in tenancy",
        "allow group SecurityAdmins to manage security-attribute-namespace in tenancy",

        # General tenancy-level read
        "allow group SecurityAdmins to read tenancies in tenancy",
        "allow group SecurityAdmins to read objectstorage-namespaces in tenancy",
        "allow group SecurityAdmins to read tag-namespaces in tenancy",

        # General tenancy-level utilities (shared with other admin groups)
        "allow group SecurityAdmins to use cloud-shell in tenancy",
        "allow group SecurityAdmins to read usage-budgets in tenancy",
        "allow group SecurityAdmins to read usage-reports in tenancy",
    ]
}