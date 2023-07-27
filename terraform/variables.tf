### Common Configuration ###

variable "os_image" {
  description = "Base OS image for the RKE2 servers"
  default     = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

variable "rke2_pool_path" {
  description = "Path to the libvirt pool"
  default     = "/home/imp/libvirt/images/terraform-provider-libvirt-pool-rke2"
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

variable "rke2_join_token" {
  description = "Token used to join cluster"
  default     = "thisissecret"
}

variable "rke2_node_netmask" {
  description = "Subnet mask for RKE2 nodes"
  default     = "24"
}

variable "rke2_node_gateway" {
  description = "Gateway for RKE2 nodes"
  default     = "192.168.48.1"
}

### RKE2 Server Configuration ###

variable "rke2_server_name" {
  description = "Name of the RKE2 server"
  default     = "rke2-server"
}

variable "rke2_server_vcpus" {
  description = "Number of vCPUs to assign for each RKE2 server"
  default     = 2
}

variable "rke2_server_memory" {
  description = "Size of memory to allocate for each RKE2 server"
  default     = "2048"
}

variable "rke2_server_disk" {
  description = "Size of disk space to allocate for each RKE2 server"
  default     = "10737418240" #10GiB
}

variable "rke2_server_ips" {
  description = "List of RKE2 server IP addresses"
  type        = list(string)
  default     = ["10.10.0.1", "10.10.0.2", "10.10.0.3"]
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
  default     = ["10.10.10.1", "10.10.10.2"]
}
