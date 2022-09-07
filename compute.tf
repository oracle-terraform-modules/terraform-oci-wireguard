resource "oci_core_instance" "wireguard" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id

  agent_config {

    are_all_plugins_disabled = true
    is_management_disabled   = true
    is_monitoring_disabled   = true


  }

  create_vnic_details {
    assign_public_ip = var.wireguard_type == "public" ? true : false
    display_name     = var.label_prefix == "none" ? "wireguard-vnic" : "${var.label_prefix}-wireguard-vnic"
    hostname_label   = "wireguard"
    subnet_id        = oci_core_subnet.wireguard.id
  }

  display_name = var.label_prefix == "none" ? "wireguard" : "${var.label_prefix}-wireguard"

  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    network_type     = "PARAVIRTUALIZED"
  }

  # prevent the wireguard from destroying and recreating itself if the image ocid changes 
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }

  metadata = {
    ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : (var.ssh_public_key_path != "none") ? file(var.ssh_public_key_path) : ""
    user_data           = data.cloudinit_config.wireguard.rendered
  }

  shape = lookup(var.wireguard_shape, "shape", "VM.Standard.E2.2")

  dynamic "shape_config" {
    for_each = length(regexall("Flex", lookup(var.wireguard_shape, "shape", "VM.Standard.E3.Flex"))) > 0 ? [1] : []
    content {
      ocpus         = max(1, lookup(var.wireguard_shape, "ocpus", 1))
      memory_in_gbs = (lookup(var.wireguard_shape, "memory", 4) / lookup(var.wireguard_shape, "ocpus", 1)) > 64 ? (lookup(var.wireguard_shape, "ocpus", 1) * 4) : lookup(var.wireguard_shape, "memory", 4)
    }
  }

  source_details {
    boot_volume_size_in_gbs = lookup(var.wireguard_shape, "boot_volume_size", 50)
    source_type             = "image"
    source_id               = local.wireguard_image_id
  }

  state = var.wireguard_state

  timeouts {
    create = "60m"
  }

}
