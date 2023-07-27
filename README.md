Terraform RKE2
==============

Scaffold an RKE2 cluster with Libvirt/KVM in **bridge mode** using Terraform.

Prerequisites
-------------

Tested on Ubuntu 20.04 machines

```sh
sudo apt update
sudo apt install libvirt terraform
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
