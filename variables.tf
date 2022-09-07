# general oci parameters
variable "tenancy_id" {
  description = "The tenancy id where to create the resources"
  type        = string
}

variable "compartment_id" {
  description = "The compartment id in which to create the resources"
  type        = string
}

variable "label_prefix" {
  description = "A string that will be prepended to all resources"
  type        = string
  default     = "none"
}

# network parameters
variable "availability_domain" {
  description = "The AD in which to place the WireGuard host"
  default     = 1
  type        = number
}

variable "wireguard_access" {
  description = "A list of CIDR blocks to which access to WireGuard will be restricted to. *anywhere* is equivalent to 0.0.0.0/0 and allows ssh access from anywhere."
  default     = ["anywhere"]
  type        = list(any)
}

variable "ig_route_id" {
  description = "The route id to the Internet Gateway"
  type        = string
  default     = ""
}

variable "nat_route_id" {
  description = "The route id to the NAT Gateway"
  type        = string
  default     = ""
}

variable "netnum" {
  description = "0-based index of the WireGuard subnet when the VCN's CIDR is masked with the corresponding newbit value."
  default     = 3
  type        = number
}

variable "newbits" {
  description = "The difference between the VCN's netmask and the desired WireGuard subnet mask"
  default     = 13
  type        = number
}

variable "vcn_id" {
  description = "The id of the VCN to use when creating the WireGuard resources."
  type        = string
}

# wireguard host parameters
variable "wireguard_image_id" {
  description = "Provide an image id for the WireGuard host or leave as Oracle."
  default     = "Oracle"
  type        = string
}

variable "wireguard_os_version" {
  description = "Oracle Linux version"
  default     = "9"
  type        = string
}

variable "wireguard_shape" {
  description = "The shape of WireGuard instance."
  default = {
    shape = "VM.Standard.E4.Flex", ocpus = 1, memory = 4, boot_volume_size = 50
  }
  type = map(any)
}

variable "wireguard_state" {
  description = "The target state for the instance. Could be set to RUNNING or STOPPED. (Updatable)"
  default     = "RUNNING"
  type        = string
}

variable "wireguard_timezone" {
  description = "The preferred timezone for the WireGuard host."
  default     = "Australia/Sydney"
  type        = string
}

variable "wireguard_type" {
  description = "Whether to make the WireGuard host public or private."
  default     = "public"
  type        = string
}

variable "ssh_public_key" {
  description = "The content of the ssh public key used to ssh to the WireGuard host. Set this or the ssh_public_key_path"
  default     = ""
  type        = string
}

variable "ssh_public_key_path" {
  description = "The path to the ssh public key used to access the WireGuard host. Set this or the ssh_public_key"
  default     = ""
  type        = string
}

variable "upgrade_wireguard" {
  description = "Whether to upgrade the WireGuard host after provisioning. It's useful to set this to false during development/testing so that the host is provisioned faster."
  default     = true
  type        = bool
}
