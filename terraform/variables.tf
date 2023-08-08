### Common Configuration ###

variable "asset_path" {
  description = "Path for RKE2 cluster related assets in local"
  default     = "assets"
}

variable "libvirt_uri" {
  description = "URI of libvirtd"
  nullable    = false
}

variable "bastion_host" {
  description = "Bastion host IP address for accessing the resulting RKE2 cluster"
  default     = null
}

variable "bastion_user" {
  description = "SSH user name for the bastion host"
  default     = null
}

variable "bastion_ssh_private_key_path" {
  description = "SSH private key path for accessing bastion"
  default     = "~/.ssh/id_rsa"
}

variable "os_image" {
  description = "Base OS image for the RKE2 servers"
  default     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

variable "rke2_pool_path" {
  description = "Path to the libvirt pool"
  default     = "/tmp/terraform-provider-libvirt-pool-rke2"
}

variable "rke2_node_ssh_username" {
  description = "SSH username for the VMs"
  default     = "rancher"
}

variable "rke2_node_ssh_password_plain" {
  description = "SSH password for the VMs in plain text"
  default     = "password"
}

variable "rke2_node_ssh_password" {
  description = "SSH password for the VMs"
  default     = "$6$fs8dQUSzmh4$qNsGvfGuaOvikpPuByXSylfU.D8YbbzNYtNj0vFoI5Lj2x7jFXI1BhEl69QdPPytkvM1Vu6XpnMS9rDPrr7Uh0"
}

variable "rke2_node_ssh_authorized_key" {
  description = "SSH public key to be added to each node"
}

variable "rke2_join_token" {
  description = "Token used to join cluster"
  default     = "thisissecret"
}

variable "bridge_mode" {
  description = "Create RKE2 cluster in bridge mode"
  type        = bool
  default     = false
}

variable "bridge_name" {
  description = "Name of the bridge"
  default     = "br0"
}

variable "rke2_node_subnet" {
  description = "Subnet for RKE2 nodes"
  default     = "172.19.31.0"
}

variable "rke2_node_netmask" {
  description = "Netmask for RKE2 nodes"
  default     = "24"
}

variable "rke2_node_gateway" {
  description = "Gateway for RKE2 nodes"
  default     = "172.19.31.1"
}

### RKE2 Server Configuration ###

variable "rke2_server_name" {
  description = "Name of the RKE2 server"
  default     = "rke2-server"
}

variable "rke2_server_vcpus" {
  description = "Number of vCPUs to assign for each RKE2 server"
  default     = 4
}

variable "rke2_server_memory" {
  description = "Size of memory to allocate for each RKE2 server"
  default     = "4096"
}

variable "rke2_server_disk" {
  description = "Size of disk space to allocate for each RKE2 server"
  default     = "10737418240" #10GiB
}

variable "rke2_server_ips" {
  description = "List of RKE2 server IP addresses"
  type        = list(string)
  default     = ["172.19.31.10", "172.19.31.11", "172.19.31.12"]
}

### RKE2 Agent Configuration ###

variable "rke2_agent_name" {
  description = "Name of the RKE2 agent"
  default     = "rke2-agent"
}

variable "rke2_agent_vcpus" {
  description = "Number of vCPUs to assign for each RKE2 agent"
  default     = 2
}

variable "rke2_agent_memory" {
  description = "Size of memory to allocate for each RKE2 agent"
  default     = "1024"
}

variable "rke2_agent_disk" {
  description = "Size of disk space to allocate for each RKE2 agent"
  default     = "10737418240" #10GiB
}

variable "rke2_agent_ips" {
  description = "List of RKE2 agent IP addresses"
  type        = list(string)
  default     = ["172.19.31.20", "172.19.31.21"]
}
