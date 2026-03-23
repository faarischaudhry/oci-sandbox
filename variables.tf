variable "tenancy_ocid" {
    description = "OCID of the parent compartment (usually the tenancy OCID)"
    type        = string
}

variable "user_ocid" {
    description = "OCID of the user running terraform scripts"
    type        = string
}

variable "private_key_path" {
    description = "Path to private key"
    type        = string
}

variable "fingerprint" {
    description = "Copy and paste user fingerprint from OCI Console"
    type        = string
}

variable "region" {
    description = "Region where OCI tenancy exists"
    type        = string
}

variable "vcn_cidr_blocks" {
    description = "CIDR Blocks for Main VCN"
    type        = list(string)
}

variable "public_subnet_cidr" {
    description = "CIDR Block for Public Subnet"
    type        = string
}

variable "private_subnet1_cidr" {
    description = "CIDR Block for Private Subnet 1"
    type        = string
}

variable "private_subnet2_cidr" {
    description = "CIDR Block for Private Subnet 2"
    type        = string
}

variable "drg_id" {
    description = "OCID for existing DRG"
    type        = string
}

variable "availability_domain" {
    description = "AD for Sandbox enviorment"
    type        = string
}

variable "domain_id" {
    description = "OCID for OCI Identity Domain"
    type        = string 
}

variable "namespace" {
    description = "Tenancy Namespace"
    type        = string
}

variable "domain_name" {
    description = "Name for identity domain"
    type        = string
}

variable "group_names" {
    description = "Names for teams working within AppDev and DB"
    type        = list(string)
    default     = [ "Team1", "Team2" ] 
}

variable "create_internet_gateway" {
    description = "Whether to create an Internet Gateway. Set to false when routing traffic through a Hub VCN via DRG."
    type        = bool
    default     = true
}

variable "create_nat_gateway" {
    description = "Whether to create a NAT Gateway. Set to false when routing traffic through a Hub VCN via DRG."
    type        = bool
    default     = true
}

variable "create_exadata_subnets" {
    description = "Whether to create Exadata client and backup subnets."
    type        = bool
    default     = false
}

variable "exadata_client_subnet_cidr" {
    description = "CIDR block for the Exadata client subnet. Required if create_exadata_subnets is true."
    type        = string
    default     = null
}

variable "exadata_backup_subnet_cidr" {
    description = "CIDR block for the Exadata backup subnet. Required if create_exadata_subnets is true."
    type        = string
    default     = null
}

variable "create_exadata_compartment" {
    description = "Whether to create a dedicated Exadata compartment under the Sandbox compartment."
    type        = bool
    default     = false
}