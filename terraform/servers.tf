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
    HOSTNAME                     = format("%v-%v", var.rke2_server_name, count.index)
    RKE2_NODE_SSH_USERNAME       = var.rke2_node_ssh_username
    RKE2_NODE_SSH_PASSWORD       = var.rke2_node_ssh_password
    RKE2_NODE_SSH_AUTHORIZED_KEY = var.rke2_node_ssh_authorized_key
    RKE2_NODE_IP_ADDRESS         = var.rke2_server_ips[count.index]
    RKE2_SERVER_JOIN_IP          = var.rke2_server_ips[0]
    RKE2_JOIN_TOKEN              = var.rke2_join_token
    RKE2_CHANNEL                 = var.rke2_channel
  })
  network_config = templatefile("${path.cwd}/templates/network_config.tftpl", {
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
    network_id     = var.bridge_mode ? libvirt_network.rke2_bridge_network[0].id : libvirt_network.rke2_network[0].id
    hostname       = "${var.rke2_server_name}-${count.index}"
    addresses      = [element(var.rke2_server_ips, count.index)]
    wait_for_lease = false
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

      bastion_host        = var.bastion_host
      bastion_user        = var.bastion_user
      bastion_private_key = file(var.bastion_ssh_private_key_path)
    }
    inline = [
      "cloud-init status --wait > /dev/null 2>&1",
    ]
  }
}
