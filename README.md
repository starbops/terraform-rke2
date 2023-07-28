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

Tearing Down
------------

```sh
make tf-destroy
```
