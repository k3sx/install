#!/bin/sh

# Front Matter
set -x
set -o vi
swapoff -a

# k3s
curl -sfL https://get.k3s.io \
  | INSTALL_K3S_CHANNEL=latest INSTALL_K3S_VERSION=v1.21.0+k3s1 \
  sh -s - --disable servicelb --disable traefik
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.bashrc 
. $HOME/.bashrc

# Helm
curl -sfL https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz | tar -xzvf -
mv linux-amd64/helm /usr/local/bin && rm -r linux-amd64

# Apps
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.3.1/cert-manager.yaml
kubectl apply -f https://sunstone.dev/keel?tag=0.17.0-rc1

# k9s
curl -sfL https://github.com/derailed/k9s/releases/download/v0.24.9/k9s_Linux_x86_64.tar.gz \
  | tar -xzvf -
mv k9s /usr/local/bin

# minimal-vimrc
git clone https://github.com/k3sx/minimal-vimrc.git
mv minimal-vimrc/.vimrc . && rm -r minimal-vimrc

cat $KUBECONFIG
