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

resource "terraform_data" "cluster" {
  connection {
    host     = var.rke2_server_ips[0]
    type     = "ssh"
    user     = var.rke2_node_ssh_username
    password = var.rke2_node_ssh_password_plain

    bastion_host        = var.bastion_host
    bastion_user        = var.bastion_user
    bastion_private_key = file(var.bastion_ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /etc/rancher/rke2/rke2.yaml ]; do echo 'Waiting for kubeconfig to be ready...'; sleep 5; done"
    ]
  }

  provisioner "local-exec" {
    command = <<CMD
      rm -rf ${var.asset_path} && \
      mkdir -p ${var.asset_path} && \
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.rke2_node_ssh_username}@${var.rke2_server_ips[0]} "sudo cp -a /etc/rancher/rke2/rke2.yaml /tmp/rke2.yaml && sudo chown rancher.rancher /tmp/rke2.yaml" && \
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.rke2_node_ssh_username}@${var.rke2_server_ips[0]}:/tmp/rke2.yaml ${var.asset_path}/ && \
      sed -i "" -e "s/127.0.0.1/${var.rke2_server_ips[0]}/g" ${var.asset_path}/rke2.yaml
CMD
  }
}
