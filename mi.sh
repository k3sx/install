#!/bin/bash

# Front Matter
set -x
set -o vi
swapoff -a

# k3s
if (( $# < 2 )); then
  embed=" --token $1 --cluster-init"
else
  embed=" --token $1 --server https://$2:6443"
fi

command="curl -sfL https://get.k3s.io | \
  INSTALL_K3S_CHANNEL=latest \
  INSTALL_K3S_VERSION=v1.21.0+k3s1 \
  sh -s - \
  --node-external-ip $(hostname -I | grep -o '^\S\+') \
  --node-ip $(hostname -I | grep -o '\s\S\+\s') \
  --disable traefik \
  ${embed}"

eval "$command"

echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.bashrc 
source $HOME/.bashrc

# Helm
curl -sfL https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz | tar -xzvf -
mv linux-amd64/helm /usr/local/bin && rm -r linux-amd64

# k9s
curl -sfL https://github.com/derailed/k9s/releases/download/v0.24.9/k9s_Linux_x86_64.tar.gz \
  | tar -xzvf -
mv k9s /usr/local/bin

# minimal-vimrc
wget https://raw.githubusercontent.com/k3sx/minimal-vimrc/main/.vimrc

cat $KUBECONFIG
