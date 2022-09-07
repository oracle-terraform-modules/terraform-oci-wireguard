resource "oci_core_subnet" "wireguard" {
  cidr_block                 = cidrsubnet(local.vcn_cidr, var.newbits, var.netnum)
  compartment_id             = var.compartment_id
  display_name               = var.label_prefix == "none" ? "wireguard" : "${var.label_prefix}-wireguard"
  dns_label                  = "wg"
  prohibit_public_ip_on_vnic = var.wireguard_type == "public" ? false : true
  route_table_id             = var.wireguard_type == "public" ? var.ig_route_id : var.nat_route_id
  security_list_ids          = [oci_core_security_list.wireguard.id]
  vcn_id                     = var.vcn_id
}
