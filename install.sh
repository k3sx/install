#!/bin/sh

# Front Matter
set -x
swapoff -a

# k3s
curl -sfL https://get.k3s.io | \
  INSTALL_K3S_CHANNEL=latest INSTALL_K3S_VERSION=v1.21.0+k3s1 \
  sh -s - --disable servicelb --disable traefik
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.bashrc 
source ~/.bashrc

# Helm
wget https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz
tar -xzvf helm-v3.5.4-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin

# Apps
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml
kubectl apply -f https://sunstone.dev/keel?tag=0.17.0-rc1

# k9s
wget https://github.com/derailed/k9s/releases/download/v0.24.9/k9s_Linux_x86_64.tar.gz
tar -xzvf k9s_Linux_x86_64.tar.gz
mv k9s /usr/local/bin
