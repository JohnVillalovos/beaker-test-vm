#!/bin/bash

set -u
set -x
set -e

sudo virt-install \
           --name beaker-test \
           --location http://mirror.centos.org/centos/7/os/x86_64 \
           --memory 4096 \
           --vcpus 4 \
           --initrd-inject beaker.ks \
           --extra-args "ks=file:/beaker.ks ip=dhcp" \
           --os-type Linux \
           --os-variant rhel7 \
           --graphics vnc \
           --hvm \
           --virt-type kvm \
           --disk "size=20" \
           --check all=on \
           --debug \
           --network bridge=virbr1 \
           --noreboot


