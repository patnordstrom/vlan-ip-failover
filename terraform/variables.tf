variable "ha_node_labels" {
  type        = set(string)
  description = "Primary / backup instance labels"
  default     = ["ha-node-1", "ha-node-2"]
}

variable "test_client_node_label" {
  type        = string
  description = "The label for the test client node"
  default     = "test-client-node"
}

# The map below is dependent on the labels above
variable "node_vlan_ips" {
  type        = map(string)
  description = "The IP address assignments for the nodes in this example"
  default = {
    "ha-node-1"        = "10.0.0.1/24"
    "ha-node-2"        = "10.0.0.2/24"
    "test-client-node" = "10.0.0.3/24"
  }
}

variable "region" {
  type        = string
  description = "Linode region to deploy"
  default     = "us-ord"
}

variable "vlan_name" {
  type        = string
  description = "The name of the VLAN we will attach the nodes to"
  default     = "test-ip-failover-vlan"
}

variable "image_name" {
  type        = string
  description = "The image we will deploy all nodes with."
  # Only certain images are compatible with cloud-init by default.
  # Refer to the guide below for compatible platform provided images 
  # https://www.linode.com/docs/products/compute/compute-instances/guides/metadata/#availability
  default = "linode/ubuntu24.04"
}

variable "image_type" {
  type        = string
  description = "The image type to deploy all nodes with."
  default     = "g6-nanode-1"
}

# Configure the below via tfvars file, environment variables, etc.

variable "authorized_users" {
  type        = list(string)
  description = "List of users who has SSH keys imported into cloud manager who need access"
}

variable "allowed_ssh_user_ips" {
  type        = list(string)
  description = "List of IP addresses that can SSH into the server"
}