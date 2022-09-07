resource "oci_core_security_list" "wireguard" {
  compartment_id = var.compartment_id
  display_name   = var.label_prefix == "none" ? "wireguard" : "${var.label_prefix}-wireguard"

  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
  }

  dynamic "ingress_security_rules" {
    # allow ssh

    for_each = var.wireguard_access
    iterator = wireguard_access_iterator
    content {
      protocol = local.tcp_protocol
      source   = wireguard_access_iterator.value == "anywhere" ? local.anywhere : wireguard_access_iterator.value

      tcp_options {
        min = local.ssh_port
        max = local.ssh_port
      }
    }
  }

  dynamic "ingress_security_rules" {
    # allow udp

    for_each = var.wireguard_access
    iterator = wireguard_access_iterator
    content {
      protocol = local.udp_protocol
      source   = wireguard_access_iterator.value == "anywhere" ? local.anywhere : wireguard_access_iterator.value

      udp_options {
        min = local.wireguard_port
        max = local.wireguard_port
      }
    }
  }  
  vcn_id = var.vcn_id
}
