provider "libvirt" {
  uri = var.libvirt_uri
}

resource "libvirt_pool" "rke2" {
  name = "rke2"
  type = "dir"
  path = var.rke2_pool_path
}

resource "libvirt_volume" "os_image" {
  name   = "os-image"
  pool   = libvirt_pool.rke2.name
  source = pathexpand(var.os_image)
  format = "qcow2"
}

resource "libvirt_network" "rke2_network" {
  count     = var.bridge_mode ? 0 : 1
  name      = "rke2-network"
  addresses = ["${var.rke2_node_subnet}/${var.rke2_node_netmask}"]
  dhcp {
    enabled = false
  }
  dns {
    enabled = true
  }
}

resource "libvirt_network" "rke2_bridge_network" {
  count  = var.bridge_mode ? 1 : 0
  name   = "rke2-bridge-network"
  mode   = "bridge"
  bridge = var.bridge_name
}
