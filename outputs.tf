# output "wireguard_public_ip" {
#   value = join(",", var.wireguard_type == "public" ? data.oci_core_vnic.wireguard_vnic.*.public_ip_address : data.oci_core_vnic.wireguard_vnic.*.private_ip_address )
# }

output "wireguard_conf" {
  value = local.peer_conf
}
