# Copyright 2019, 2021 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

# Protocols are specified as protocol numbers.
# https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml

locals {
  all_protocols = "all"

  anywhere = "0.0.0.0/0"

  wireguard_template = "${path.module}/cloudinit/wireguard.template.yaml"

  wireguard_image_id = data.oci_core_images.oracle_images.images.0.id

  # port numbers
  ssh_port       = 22
  wireguard_port = 51820

  # protocols
  tcp_protocol = 6
  udp_protocol = 17

  # we expect the wireguard to be in the first cidr block in the list of cidr blocks
  vcn_cidr = element(data.oci_core_vcn.vcn.cidr_blocks, 0)

  setup_wireguard_template = base64gzip(
    templatefile("${path.module}/scripts/wireguard.template.sh", {}
    )
  )
  wireguard_conf_template = base64gzip(
    templatefile("${path.module}/conf/wg.template.conf", {}
    )
  )
}
