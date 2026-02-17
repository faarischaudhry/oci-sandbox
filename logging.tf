resource "oci_logging_log_group" "vcn_flow_logs" {
    compartment_id = oci_identity_compartment.security.id
    display_name   = "vcn-flow-log-group"
    description    = "Log group for VCN flow logs"
}

resource "oci_logging_log" "public_subnet_flow_log" {
    display_name = "public_subnet_flow_log"
    log_group_id = oci_logging_log_group.vcn_flow_log_group.id
    log_type = "SERVICE"
    is_enabled = true

    configuration {
        source {
            category = "all"
            resource = oci_core_subnet.public_subnet.id
            service = "flowlogs"
            source_type = "OCISERVICE"
        }
        compartment_id = oci_identity_compartment.security.id
    }
}

resource "oci_logging_log" "private_subent1_flow_log" {
    display_name = "private_subent1_flow_log"
    log_group_id = oci_logging_log_group.vcn_flow_log_group.id
    log_type = "SERVICE"
    is_enabled = true

    configuration {
        source {
            category = "all"
            resource = oci_core_subnet.private_subnet_1.id
            service = "flowlogs"
            source_type = "OCISERVICE"
        }
        compartment_id = oci_identity_compartment.security.id
    }
}

resource "oci_logging_log" "private_subent2_flow_log" {
    display_name = "private_subent2_flow_log"
    log_group_id = oci_logging_log_group.vcn_flow_log_group.id
    log_type = "SERVICE"
    is_enabled = true

    configuration {
        source {
            category = "all"
            resource = oci_core_subnet.private_subnet_2.id
            service = "flowlogs"
            source_type = "OCISERVICE"
        }
        compartment_id = oci_identity_compartment.security.id
    }
}

resource "oci_log_analytics_log_analytics_log_group" "vcn_flow_log_analytics_group" {
    compartment_id = oci_identity_compartment.security.id
    display_name = "vcn-flow-log-analytics-group"
    namespace = var.namespace
}

resource "oci_sch_service_connector" "vcn_flow_logs_to_log_analytics" {
    compartment_id = oci_identity_compartment.security.id
    display_name = "vcn_flow_logs_to_log_analytics"

    source {
        kind = "logging"
        log_sources {
            compartment_id = oci_identity_compartment.security.id
            log_group_id = oci_logging_log_group.vcn_flow_log_group.id
        }
    }

    target {
        kind = "loggingAnalytics"
        log_group_id = oci_log_analytics_log_analytics_log_group.vcn_flow_log_analytics_group.id
        log_source_identifier = "OCI VCN Flow Logs"
    }
}

resource "oci_identity_policy" "service_connector_log_analytics_policy" {
    compartment_id = var.tenancy_ocid
    name = "vcn-flow-logs-connector-policy"
    statements = [
        "allow any-user to read log-content in compartment id ${oci_identity_compartment.security.id} where all {request.principal.type='serviceconnector', request.principal.compartment.id='${oci_identity_compartment.security.id}'}",
        "allow any-user to {LOG_ANALYTICS_LOG_GROUP_UPLOAD_LOGS} in compartment id ${oci_identity_compartment.security.id} where all {request.principal.type='serviceconnector', request.principal.compartment.id='${oci_identity_compartment.security.id}'}"
    ]
    description = "Allows Service Connector Hub to write VCN flow logs to Log Analytics"
}