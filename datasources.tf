# Copyright 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_id
  ad_number      = var.availability_domain
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}

data "oci_core_images" "oracle_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = lookup(var.wireguard_shape, "shape", "VM.Standard.E2.2")
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# cloud init for wireguard
data "cloudinit_config" "wireguard" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "wireguard.yaml"
    content_type = "text/cloud-config"
    content = templatefile(
      local.wireguard_template, {
        wireguard_conf     = local.wireguard_conf_template,
        wireguard_setup    = local.setup_wireguard_template,
        wireguard_timezone = var.wireguard_timezone,
        upgrade_wireguard  = var.upgrade_wireguard
      }
    )
  }
}

# Gets a list of VNIC attachments on the wireguard instance
data "oci_core_vnic_attachments" "wireguard_vnics_attachments" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  depends_on          = [oci_core_instance.wireguard]
  instance_id         = oci_core_instance.wireguard.id
}

# Gets the OCID of the first (default) VNIC on the wireguard instance
data "oci_core_vnic" "wireguard_vnic" {
  depends_on = [oci_core_instance.wireguard]
  vnic_id    = lookup(data.oci_core_vnic_attachments.wireguard_vnics_attachments.vnic_attachments[0], "vnic_id")
}

data "oci_core_instance" "wireguard" {
  depends_on  = [oci_core_instance.wireguard]
  instance_id = oci_core_instance.wireguard.id
}
