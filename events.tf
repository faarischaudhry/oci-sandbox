locals {
  oci_services = {

    # ── AI / Data ────────────────────────────────────────────────────────────
    "ai-data-platform" = {
      display_name = "AI Data Platform"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.aidataplatform\", \"condition\": \"LIKE\"}]}"
    }
    "ai-anomaly-detection" = {
      display_name = "AI Service - Anomaly Detection"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.aianomalydetection\", \"condition\": \"LIKE\"}]}"
    }
    "ai-biometric" = {
      display_name = "AI Service - Biometric"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.aibiometric\", \"condition\": \"LIKE\"}]}"
    }
    "ai-forecasting" = {
      display_name = "AI Service - Forecasting"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.aiforecasting\", \"condition\": \"LIKE\"}]}"
    }
    "ai-language" = {
      display_name = "AI Service - Language"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.ailanguage\", \"condition\": \"LIKE\"}]}"
    }
    "ai-speech" = {
      display_name = "AI Service - Speech"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.aispeech\", \"condition\": \"LIKE\"}]}"
    }

    # ── API / Integration ─────────────────────────────────────────────────────
    "api-gateway" = {
      display_name = "API Gateway"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.apigateway\", \"condition\": \"LIKE\"}]}"
    }
    "api-platform" = {
      display_name = "API Platform"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.apiplatform\", \"condition\": \"LIKE\"}]}"
    }
    "integration" = {
      display_name = "Integration"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.integration\", \"condition\": \"LIKE\"}]}"
    }

    # ── Analytics ─────────────────────────────────────────────────────────────
    "analytics" = {
      display_name = "Analytics"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.analytics\", \"condition\": \"LIKE\"}]}"
    }
    "analytics-warehouse" = {
      display_name = "Analytics Warehouse"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.analyticswarehouse\", \"condition\": \"LIKE\"}]}"
    }

    # ── Application ───────────────────────────────────────────────────────────
    "application-configuration" = {
      display_name = "Application Configuration"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.appconfiguration\", \"condition\": \"LIKE\"}]}"
    }
    "application-dependency-management" = {
      display_name = "Application Dependency Management"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.adm\", \"condition\": \"LIKE\"}]}"
    }
    "application-migration" = {
      display_name = "Application Migration"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.applicationmigration\", \"condition\": \"LIKE\"}]}"
    }

    # ── Artifact / Registry ───────────────────────────────────────────────────
    "artifact-registry" = {
      display_name = "Artifact Registry"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.artifacts\", \"condition\": \"LIKE\"}]}"
    }

    # ── Autonomous / Recovery ─────────────────────────────────────────────────
    "autonomous-linux" = {
      display_name = "Autonomous Linux"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.autonomouslinux\", \"condition\": \"LIKE\"}]}"
    }
    "autonomous-recovery-service" = {
      display_name = "Autonomous Recovery Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.recoveryservice\", \"condition\": \"LIKE\"}]}"
    }

    # ── ATA ───────────────────────────────────────────────────────────────────
    "ata" = {
      display_name = "ATA"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.ata\", \"condition\": \"LIKE\"}]}"
    }

    # ── Bastion / Batch ───────────────────────────────────────────────────────
    "bastion" = {
      display_name = "Bastion"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.bastion\", \"condition\": \"LIKE\"}]}"
    }
    "batch" = {
      display_name = "Batch"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.batch\", \"condition\": \"LIKE\"}]}"
    }

    # ── Big Data / Blockchain ─────────────────────────────────────────────────
    "big-data-service" = {
      display_name = "Big Data Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.bigdataservice\", \"condition\": \"LIKE\"}]}"
    }
    "blockchain-platform" = {
      display_name = "Blockchain Platform"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.blockchain\", \"condition\": \"LIKE\"}]}"
    }

    # ── Block Volume ──────────────────────────────────────────────────────────
    "block-volume" = {
      display_name = "Block Volume"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.blockvolume\", \"condition\": \"LIKE\"}]}"
    }

    # ── Budgets ───────────────────────────────────────────────────────────────
    "budgets" = {
      display_name = "Budgets"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.budgets\", \"condition\": \"LIKE\"}]}"
    }

    # ── Cloud Guard ───────────────────────────────────────────────────────────
    "cloud-guard" = {
      display_name = "Cloud Guard"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.cloudguard\", \"condition\": \"LIKE\"}]}"
    }

    # ── Compartments ──────────────────────────────────────────────────────────
    "compartments" = {
      display_name = "Compartments"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.identity.compartment\", \"condition\": \"LIKE\"}]}"
    }

    # ── Compute ───────────────────────────────────────────────────────────────
    "compute" = {
      display_name = "Compute"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.computeapi\", \"condition\": \"LIKE\"}]}"
    }

    # ── Content and Experience ────────────────────────────────────────────────
    "content-and-experience" = {
      display_name = "Content and Experience"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.contentmanagement\", \"condition\": \"LIKE\"}]}"
    }

    # ── Data ──────────────────────────────────────────────────────────────────
    "data-catalog" = {
      display_name = "Data Catalog"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.datacatalog\", \"condition\": \"LIKE\"}]}"
    }
    "data-flow" = {
      display_name = "Data Flow"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.dataflow\", \"condition\": \"LIKE\"}]}"
    }
    "data-infrastructure-cloud-at-customer" = {
      display_name = "Data Infrastructure Cloud at Customer"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.exacc\", \"condition\": \"LIKE\"}]}"
    }
    "data-integration" = {
      display_name = "Data Integration"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.dataintegration\", \"condition\": \"LIKE\"}]}"
    }
    "data-intelligence-foundation" = {
      display_name = "Data Intelligence Foundation"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.dataintelligence\", \"condition\": \"LIKE\"}]}"
    }
    "data-lake" = {
      display_name = "Data Lake"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.datalake\", \"condition\": \"LIKE\"}]}"
    }
    "data-protection" = {
      display_name = "Data Protection"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.dataprotection\", \"condition\": \"LIKE\"}]}"
    }
    "data-safe" = {
      display_name = "Data Safe"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.datasafe\", \"condition\": \"LIKE\"}]}"
    }
    "data-science" = {
      display_name = "Data Science"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.datascience\", \"condition\": \"LIKE\"}]}"
    }
    "data-transfer-service" = {
      display_name = "Data Transfer Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.datatransfer\", \"condition\": \"LIKE\"}]}"
    }

    # ── Database ──────────────────────────────────────────────────────────────
    "database" = {
      display_name = "Database"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.database\", \"condition\": \"LIKE\"}]}"
    }
    "database-management" = {
      display_name = "Database Management"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.databasemanagement\", \"condition\": \"LIKE\"}]}"
    }
    "database-migration-service" = {
      display_name = "Database Migration Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.databasemigration\", \"condition\": \"LIKE\"}]}"
    }
    "database-tools" = {
      display_name = "Database Tools"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.databasetools\", \"condition\": \"LIKE\"}]}"
    }
    "dataflow-interactive" = {
      display_name = "Dataflow Interactive"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.dataflowinteractive\", \"condition\": \"LIKE\"}]}"
    }

    # ── Delegate Access Control ───────────────────────────────────────────────
    "delegate-access-control" = {
      display_name = "Delegate Access Control"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.delegateaccesscontrol\", \"condition\": \"LIKE\"}]}"
    }

    # ── DevOps ────────────────────────────────────────────────────────────────
    "devops-build" = {
      display_name = "DevOps Build"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.devops.buildpipeline\", \"condition\": \"LIKE\"}]}"
    }
    "devops-code-repository" = {
      display_name = "DevOps Code Repository"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.devops.repository\", \"condition\": \"LIKE\"}]}"
    }
    "devops-deploy" = {
      display_name = "DevOps Deploy"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.devops.deploymentpipeline\", \"condition\": \"LIKE\"}]}"
    }
    "devops-project" = {
      display_name = "DevOps Project"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.devops.project\", \"condition\": \"LIKE\"}]}"
    }

    # ── Digital ───────────────────────────────────────────────────────────────
    "digital-assistant" = {
      display_name = "Digital Assistant"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.digitalassistant\", \"condition\": \"LIKE\"}]}"
    }
    "digital-media-services" = {
      display_name = "Digital Media Services"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.digitalmedia\", \"condition\": \"LIKE\"}]}"
    }

    # ── Disaster Recovery / Discovery ─────────────────────────────────────────
    "disaster-recovery" = {
      display_name = "Disaster Recovery"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.disasterrecovery\", \"condition\": \"LIKE\"}]}"
    }
    "discovery-service" = {
      display_name = "Discovery Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.cloudbridge\", \"condition\": \"LIKE\"}]}"
    }

    # ── ExaCompute ────────────────────────────────────────────────────────────
    "exacompute-control-plane" = {
      display_name = "ExaCompute Control Plane"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.exainfrastructure\", \"condition\": \"LIKE\"}]}"
    }

    # ── File Storage ──────────────────────────────────────────────────────────
    "fsu" = {
      display_name = "FSU"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.fsu\", \"condition\": \"LIKE\"}]}"
    }
    "file-storage" = {
      display_name = "File Storage"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.filestorage\", \"condition\": \"LIKE\"}]}"
    }
    "file-storage-lustre" = {
      display_name = "File Storage with Lustre"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.lustre\", \"condition\": \"LIKE\"}]}"
    }

    # ── Functions ─────────────────────────────────────────────────────────────
    "functions" = {
      display_name = "Functions"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.functions\", \"condition\": \"LIKE\"}]}"
    }

    # ── Fusion / Galaxy / GlobalAccelerator ───────────────────────────────────
    "fusion-applications" = {
      display_name = "Fusion Applications"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.fusionapps\", \"condition\": \"LIKE\"}]}"
    }
    "galaxy-control-plane" = {
      display_name = "Galaxy Control Plane"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.galaxy\", \"condition\": \"LIKE\"}]}"
    }
    "global-accelerator" = {
      display_name = "GlobalAccelerator"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.globalaccelerator\", \"condition\": \"LIKE\"}]}"
    }
    "globally-distributed-database" = {
      display_name = "Globally Distributed Database"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.globaldistributeddatabase\", \"condition\": \"LIKE\"}]}"
    }

    # ── GoldenGate ────────────────────────────────────────────────────────────
    "goldengate" = {
      display_name = "GoldenGate"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.goldengate\", \"condition\": \"LIKE\"}]}"
    }

    # ── Hardware / Health ─────────────────────────────────────────────────────
    "hardware-fault" = {
      display_name = "Hardware Fault"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.hardwarefault\", \"condition\": \"LIKE\"}]}"
    }
    "health-checks" = {
      display_name = "Health Checks"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.healthchecks\", \"condition\": \"LIKE\"}]}"
    }

    # ── Identity ──────────────────────────────────────────────────────────────
    "identity" = {
      display_name = "Identity"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.identity\", \"condition\": \"LIKE\"}]}"
    }
    "identity-sign-on" = {
      display_name = "Identity SignOn"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.identitysignon\", \"condition\": \"LIKE\"}]}"
    }

    # ── Industry / IRCM ───────────────────────────────────────────────────────
    "industry-data-exchange" = {
      display_name = "Industry Data Exchange"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.industrydataexchange\", \"condition\": \"LIKE\"}]}"
    }
    "ircm-control-plane" = {
      display_name = "Integrated Revenue Cycle Management Control Plane"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.ircm\", \"condition\": \"LIKE\"}]}"
    }

    # ── Intelligent Data Lake / IoT ───────────────────────────────────────────
    "intelligent-data-lake" = {
      display_name = "Intelligent Data Lake"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.intelligentdatalake\", \"condition\": \"LIKE\"}]}"
    }
    "internet-of-things" = {
      display_name = "Internet of Things"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.iotmonitoring\", \"condition\": \"LIKE\"}]}"
    }

    # ── Java Management ───────────────────────────────────────────────────────
    "java-management" = {
      display_name = "Java Management"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.javamanagement\", \"condition\": \"LIKE\"}]}"
    }

    # ── Key Management ────────────────────────────────────────────────────────
    "key-management-service" = {
      display_name = "Key Management Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.keymanagement\", \"condition\": \"LIKE\"}]}"
    }

    # ── License Manager ───────────────────────────────────────────────────────
    "licensemanager" = {
      display_name = "License Manager"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.licensemanager\", \"condition\": \"LIKE\"}]}"
    }

    # ── Logging ───────────────────────────────────────────────────────────────
    "logging-analytics" = {
      display_name = "Logging Analytics"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.loganalytics\", \"condition\": \"LIKE\"}]}"
    }

    # ── Management Agent ──────────────────────────────────────────────────────
    "management-agent" = {
      display_name = "Management Agent"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.managementagent\", \"condition\": \"LIKE\"}]}"
    }

    # ── MySQL ─────────────────────────────────────────────────────────────────
    "mysql" = {
      display_name = "MySQL"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.mysql\", \"condition\": \"LIKE\"}]}"
    }

    # ── Network ───────────────────────────────────────────────────────────────
    "network-path-analyzer" = {
      display_name = "Network Path Analyzer"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.vnipathanalyzer\", \"condition\": \"LIKE\"}]}"
    }
    "network-firewall" = {
      display_name = "NetworkFirewall"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.networkfirewall\", \"condition\": \"LIKE\"}]}"
    }
    "networking" = {
      display_name = "Networking"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.virtualnetwork\", \"condition\": \"LIKE\"}]}"
    }

    # ── NoSQL / Notifications ─────────────────────────────────────────────────
    "nosql" = {
      display_name = "NoSQL"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.nosql\", \"condition\": \"LIKE\"}]}"
    }
    "notifications" = {
      display_name = "Notifications"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.ons\", \"condition\": \"LIKE\"}]}"
    }

    # ── Object Storage ────────────────────────────────────────────────────────
    "object-storage" = {
      display_name = "Object Storage"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.objectstorage\", \"condition\": \"LIKE\"}]}"
    }

    # ── OCI Cache / PostgreSQL / Resource Scheduler ───────────────────────────
    "oci-cache-service" = {
      display_name = "OCI Cache Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.cache\", \"condition\": \"LIKE\"}]}"
    }
    "oci-database-postgresql" = {
      display_name = "OCI Database with PostgreSQL"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.psql\", \"condition\": \"LIKE\"}]}"
    }
    "oci-resource-scheduler" = {
      display_name = "OCI Resource Scheduler"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.resourcescheduler\", \"condition\": \"LIKE\"}]}"
    }

    # ── OCI Control Center ────────────────────────────────────────────────────
    "oci-control-center" = {
      display_name = "Oci Control Center"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.controlcenter\", \"condition\": \"LIKE\"}]}"
    }

    # ── OCM Inventory / OKE ───────────────────────────────────────────────────
    "ocm-inventory" = {
      display_name = "OCM Inventory"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.ocm\", \"condition\": \"LIKE\"}]}"
    }
    "oke" = {
      display_name = "OKE"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.containerengine\", \"condition\": \"LIKE\"}]}"
    }

    # ── OMA / OMK ─────────────────────────────────────────────────────────────
    "oma" = {
      display_name = "OMA"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.oma\", \"condition\": \"LIKE\"}]}"
    }
    "omk" = {
      display_name = "OMK"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.omk\", \"condition\": \"LIKE\"}]}"
    }

    # ── OS Management ─────────────────────────────────────────────────────────
    "os-management-hub" = {
      display_name = "OS Management Hub"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.osmanagementhub\", \"condition\": \"LIKE\"}]}"
    }
    "osms" = {
      display_name = "OSMS"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.osmanagement\", \"condition\": \"LIKE\"}]}"
    }

    # ── Operator Access Control ───────────────────────────────────────────────
    "operator-access-control" = {
      display_name = "Operator Access Control"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.operatoraccesscontrol\", \"condition\": \"LIKE\"}]}"
    }

    # ── Oracle Health / Mobile Hub / Roving Edge ──────────────────────────────
    "oracle-health-env-management" = {
      display_name = "Oracle Health Environment Management"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.oraclehealth\", \"condition\": \"LIKE\"}]}"
    }
    "oracle-mobile-hub" = {
      display_name = "Oracle Mobile Hub"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.mobilehub\", \"condition\": \"LIKE\"}]}"
    }
    "oracle-roving-edge" = {
      display_name = "Oracle Roving Edge Infrastructure"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.rovingedge\", \"condition\": \"LIKE\"}]}"
    }

    # ── Private Service Access ────────────────────────────────────────────────
    "private-service-access" = {
      display_name = "Private Service Access"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.privateserviceaccess\", \"condition\": \"LIKE\"}]}"
    }

    # ── Process Automation ────────────────────────────────────────────────────
    "process-automation" = {
      display_name = "Process Automation"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.processautomation\", \"condition\": \"LIKE\"}]}"
    }

    # ── Query Service / Registry ──────────────────────────────────────────────
    "query-service" = {
      display_name = "Query Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.queryservice\", \"condition\": \"LIKE\"}]}"
    }
    "registry" = {
      display_name = "Registry"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.registry\", \"condition\": \"LIKE\"}]}"
    }

    # ── Resource Manager ──────────────────────────────────────────────────────
    "resource-manager" = {
      display_name = "Resource Manager"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.resourcemanager\", \"condition\": \"LIKE\"}]}"
    }

    # ── Secure Desktops ───────────────────────────────────────────────────────
    "secure-desktops" = {
      display_name = "Secure Desktops"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.desktops\", \"condition\": \"LIKE\"}]}"
    }

    # ── Service Enablement ────────────────────────────────────────────────────
    "self" = {
      display_name = "Service Enablement Lifecycle Framework (SELF)"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.self\", \"condition\": \"LIKE\"}]}"
    }

    # ── Service Mesh ──────────────────────────────────────────────────────────
    "service-mesh" = {
      display_name = "ServiceMesh"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.servicemesh\", \"condition\": \"LIKE\"}]}"
    }

    # ── Streaming ─────────────────────────────────────────────────────────────
    "streaming-kafka" = {
      display_name = "Streaming with Apache Kafka"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.streaming\", \"condition\": \"LIKE\"}]}"
    }

    # ── Subscription Pricing ──────────────────────────────────────────────────
    "subscription-pricing-service" = {
      display_name = "Subscription Pricing Service"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.subscriptionpricing\", \"condition\": \"LIKE\"}]}"
    }

    # ── Tagging ───────────────────────────────────────────────────────────────
    "tagging" = {
      display_name = "Tagging"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.tagging\", \"condition\": \"LIKE\"}]}"
    }

    # ── VMware / Visual Builder ───────────────────────────────────────────────
    "vmware-solution" = {
      display_name = "VMware Solution"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.ocvs\", \"condition\": \"LIKE\"}]}"
    }
    "visual-builder-studio" = {
      display_name = "Visual Builder Studio"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.visualbuilder\", \"condition\": \"LIKE\"}]}"
    }

    # ── Vulnerability Scanning ────────────────────────────────────────────────
    "vulnerability-scanning" = {
      display_name = "Vulnerability Scanning"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.vulnerabilityscanning\", \"condition\": \"LIKE\"}]}"
    }

    # ── Web Application ───────────────────────────────────────────────────────
    "web-application-acceleration" = {
      display_name = "Web Application Acceleration"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.waa\", \"condition\": \"LIKE\"}]}"
    }
    "web-application-firewall" = {
      display_name = "Web Application Firewall"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.waf\", \"condition\": \"LIKE\"}]}"
    }

    # ── WebLogic ──────────────────────────────────────────────────────────────
    "weblogic-management" = {
      display_name = "WebLogic Management"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.weblogic\", \"condition\": \"LIKE\"}]}"
    }

    # ── Zero Trust ────────────────────────────────────────────────────────────
    "zero-trust-packet-routing" = {
      display_name = "Zero Trust Packet Routing"
      condition    = "{\"eventType\": [{\"value\": \"com.oraclecloud.zerotrust\", \"condition\": \"LIKE\"}]}"
    }
  }
}

resource "oci_events_rule" "service_rules" {
  for_each = local.oci_services

  compartment_id = oci_identity_compartment.security.id
  display_name = each.value.display_name
  is_enabled = true
  condition = each.value.condition

  actions {
    actions {
      action_type = "ONS"
      is_enabled = true
      topic_id = oci_ons_notification_topic.test_notification_topic.id
    }
  }
}