resource "oci_core_vcn" "main_vcn" {
    compartment_id = oci_identity_compartment.network.id
  	cidr_blocks    = var.vcn_cidr_blocks
  	display_name   = "main-vcn"
  	dns_label      = "mainvcn"
}

# Assuming DRG + Hub VCN + Hub VCN DRG Attachment exist
resource "oci_core_drg_attachment" "main_vcn_drg_attachment" {
  drg_id = var.drg_id

  network_details {
    id   = oci_core_vcn.main_vcn.id
    type = "VCN"
  }

  display_name = "main-vcn-drg-attachment"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  	compartment_id = oci_identity_compartment.network.id
  	vcn_id         = oci_core_vcn.main_vcn.id
  	display_name   = "internet-gateway"
  	enabled        = true
}

resource "oci_core_nat_gateway" "nat_gateway" {
  	compartment_id = oci_identity_compartment.network.id
  	vcn_id         = oci_core_vcn.main_vcn.id
  	display_name   = "nat-gateway"
}

resource "oci_core_route_table" "public_route_table" {
  	compartment_id = oci_identity_compartment.network.id
  	vcn_id         = oci_core_vcn.main_vcn.id
  	display_name   = "public-route-table"
  	route_rules {
    	network_entity_id = oci_core_internet_gateway.internet_gateway.id
    	destination       = "0.0.0.0/0"
    	destination_type  = "CIDR_BLOCK"
  	}
}

resource "oci_core_route_table" "private_route_table" {
  	compartment_id = oci_identity_compartment.network.id
  	vcn_id         = oci_core_vcn.main_vcn.id
  	display_name   = "private-route-table"
  	route_rules {
    	network_entity_id = oci_core_nat_gateway.nat_gateway.id
    	destination       = "0.0.0.0/0"
    	destination_type  = "CIDR_BLOCK"
  	}
}

resource "oci_core_security_list" "public_security_list" {
  	compartment_id = oci_identity_compartment.network.id
  	vcn_id         = oci_core_vcn.main_vcn.id
  	display_name   = "public-security-list"
  	egress_security_rules {
    	destination = "0.0.0.0/0"
    	protocol    = "all"
  	}
  	ingress_security_rules {
    	protocol = "6" # TCP
    	source   = "0.0.0.0/0"
    	tcp_options {
      		min = 22
      		max = 22
    	}
  	}
  	ingress_security_rules {
    	protocol = "6" 
    	source   = "0.0.0.0/0"
    	tcp_options {
      		min = 80
      		max = 80
    	}
  	}
  	ingress_security_rules {
    	protocol = "6" 
    	source   = "0.0.0.0/0"
    	tcp_options {
      		min = 443
      	    max = 443
    	}
  	}
}

resource "oci_core_security_list" "private_security_list" {
  	compartment_id = oci_identity_compartment.network.id
  	vcn_id         = oci_core_vcn.main_vcn.id
  	display_name   = "private-security-list"
  	egress_security_rules {
    	destination = "0.0.0.0/0"
    	protocol    = "all"
  	}
  	ingress_security_rules {
    	protocol = "all"
    	source   = "10.0.0.0/16"
  	}
}

resource "oci_core_subnet" "public_subnet" {
  	compartment_id             = oci_identity_compartment.network.id
  	vcn_id                     = oci_core_vcn.main_vcn.id
  	cidr_block                 = var.public_subnet_cidr
  	display_name               = "public-subnet"
  	dns_label                  = "public"
  	prohibit_public_ip_on_vnic = false
  	route_table_id             = oci_core_route_table.public_route_table.id
  	security_list_ids          = [oci_core_security_list.public_security_list.id]
  	availability_domain        = var.availability_domain
}

resource "oci_core_subnet" "private_subnet_1" {
	compartment_id             = oci_identity_compartment.network.id
  	vcn_id                     = oci_core_vcn.main_vcn.id
  	cidr_block                 = var.private_subnet1_cidr
  	display_name               = "private-subnet-1-dev"
  	dns_label                  = "privatedev1"
  	prohibit_public_ip_on_vnic = true
  	route_table_id             = oci_core_route_table.private_route_table.id
  	security_list_ids          = [oci_core_security_list.private_security_list.id]
  	availability_domain        = var.availability_domain
}

resource "oci_core_subnet" "private_subnet_2" {
  	compartment_id             = oci_identity_compartment.network.id
  	vcn_id                     = oci_core_vcn.main_vcn.id
  	cidr_block                 = var.private_subnet2_cidr
  	display_name               = "private-subnet-2-dev"
  	dns_label                  = "privatedev2"
  	prohibit_public_ip_on_vnic = true
  	route_table_id             = oci_core_route_table.private_route_table.id
  	security_list_ids          = [oci_core_security_list.private_security_list.id]
  	availability_domain        = var.availability_domain
}
