Terraform RKE2
==============

Create an RKE2 cluster with Libvirt/KVM in bridge/NAT mode using Terraform.

Prerequisites
-------------

Tested on Ubuntu 20.04 machines

```sh
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```

```sh
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt update
$ sudo apt install terraform
$ terraform -v
Terraform v1.5.4
on linux_amd64
```

Firing Up
---------

```sh
make tf-init
make tf-plan
make tf-apply
```

Connect to one of the control plane nodes and execute the `kubectl` command to check the cluster info:

```sh
$ root@rke2-server-0:~# KUBECONFIG=/etc/rancher/rke2/rke2.yaml /var/lib/rancher/rke2/bin/kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:6443
CoreDNS is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/rke2-coredns-rke2-coredns:udp-53/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

Tearing Down
------------

```sh
make tf-destroy
```
