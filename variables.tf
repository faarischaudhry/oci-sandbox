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