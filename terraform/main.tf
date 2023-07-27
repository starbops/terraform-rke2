terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://imp@frostfangs.internal.zespre.com/system?sshauth=privkey&keyfile=/Users/starbops/.ssh/id_rsa"
}

resource "libvirt_pool" "rke2" {
  name = "rke2"
  type = "dir"
  path = var.rke2_pool_path
}

resource "libvirt_volume" "os_image" {
  name   = "os-image"
  pool   = libvirt_pool.rke2.name
  source = var.os_image
  format = "qcow2"
}

resource "libvirt_network" "rke2_network" {
  name   = "rke2-network"
  mode   = "bridge"
  bridge = "br0"
}

resource "libvirt_volume" "rke2_server" {
  count          = length(var.rke2_server_ips)
  name           = "rke2-server-${count.index}"
  base_volume_id = libvirt_volume.os_image.id
  pool           = libvirt_pool.rke2.name
  size           = var.rke2_server_disk
  format         = "qcow2"
}

resource "libvirt_cloudinit_disk" "server_init" {
  count = length(var.rke2_server_ips)
  name  = "server-init-${count.index}.iso"
  user_data = templatefile("${path.cwd}/templates/cloud_init_server.tftpl", {
    HOSTNAME               = format("%v-%v", var.rke2_server_name, count.index)
    RKE2_NODE_SSH_USERNAME = var.rke2_node_ssh_username
    RKE2_NODE_SSH_PASSWORD = var.rke2_node_ssh_password
    RKE2_NODE_IP_ADDRESS   = var.rke2_server_ips[count.index]
    RKE2_SERVER_JOIN_IP    = var.rke2_server_ips[0]
    RKE2_JOIN_TOKEN        = var.rke2_join_token
  })
  network_config = templatefile("${path.cwd}/templates/network.tftpl", {
    RKE2_NODE_IP_ADDRESS = element(var.rke2_server_ips, count.index)
    RKE2_NODE_NETMASK    = var.rke2_node_netmask
    RKE2_NODE_GATEWAY    = var.rke2_node_gateway
  })
  pool = libvirt_pool.rke2.name
}

resource "libvirt_domain" "domain_rke2_server" {
  count  = length(var.rke2_server_ips)
  name   = "${var.rke2_server_name}-${count.index}"
  vcpu   = var.rke2_server_vcpus
  memory = var.rke2_server_memory

  cloudinit = libvirt_cloudinit_disk.server_init[count.index].id

  network_interface {
    network_id = libvirt_network.rke2_network.id
    # hostname   = "${var.rke2_server_name}-${count.index}"
    # addresses  = [element(var.rke2_server_ips, count.index)]
    # wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }

  disk {
    volume_id = libvirt_volume.rke2_server[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    connection {
      host     = element(var.rke2_server_ips, count.index)
      type     = "ssh"
      user     = var.rke2_node_ssh_username
      password = var.rke2_node_ssh_password_plain
    }
    inline = [
      "cloud-init status --wait > /dev/null 2>&1",
    ]
  }
}

resource "libvirt_volume" "rke2_agent" {
  count          = length(var.rke2_agent_ips)
  name           = "rke2-agent-${count.index}"
  base_volume_id = libvirt_volume.os_image.id
  pool           = libvirt_pool.rke2.name
  size           = var.rke2_agent_disk
  format         = "qcow2"
}

resource "libvirt_cloudinit_disk" "agent_init" {
  count = length(var.rke2_agent_ips)
  name  = "agent-init-${count.index}.iso"
  user_data = templatefile("${path.cwd}/templates/cloud_init_agent.tftpl", {
    HOSTNAME               = format("%v-%v", var.rke2_agent_name, count.index)
    RKE2_NODE_SSH_USERNAME = var.rke2_node_ssh_username
    RKE2_NODE_SSH_PASSWORD = var.rke2_node_ssh_password
    RKE2_SERVER_JOIN_IP    = element(var.rke2_server_ips, 0)
    RKE2_JOIN_TOKEN        = var.rke2_join_token
  })
  network_config = templatefile("${path.cwd}/templates/network.tftpl", {
    RKE2_NODE_IP_ADDRESS = element(var.rke2_agent_ips, count.index)
    RKE2_NODE_NETMASK    = var.rke2_node_netmask
    RKE2_NODE_GATEWAY    = var.rke2_node_gateway
  })
  pool = libvirt_pool.rke2.name
}

resource "libvirt_domain" "domain_rke2_agent" {
  count  = length(var.rke2_agent_ips)
  name   = "${var.rke2_agent_name}-${count.index}"
  vcpu   = var.rke2_agent_vcpus
  memory = var.rke2_agent_memory

  cloudinit = libvirt_cloudinit_disk.agent_init[count.index].id

  network_interface {
    network_id = libvirt_network.rke2_network.id
    # hostname   = "${var.rke2_agent_name}-${count.index}"
    # addresses  = [element(var.rke2_agent_ips, count.index)]
    # wait_for_lease = true
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_port = "1"
    target_type = "virtio"
  }

  disk {
    volume_id = libvirt_volume.rke2_agent[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  provisioner "remote-exec" {
    connection {
      host     = element(var.rke2_agent_ips, count.index)
      type     = "ssh"
      user     = var.rke2_node_ssh_username
      password = var.rke2_node_ssh_password_plain
    }
    inline = [
      "cloud-init status --wait > /dev/null 2>&1",
    ]
  }
}
