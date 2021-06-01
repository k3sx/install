#!/bin/bash

# Front Matter
# set -x
set -o vi
swapoff -a

TOKEN=$2
RAND_TOKEN=${TOKEN:-`openssl rand -base64 48`}

# k3s
if (( $# < 1 )); then
  append=" --cluster-init"
  echo "curl -sfL https://raw.githubusercontent.com/k3sx/install/main/mi.sh | bash -s https://`hostname -I | awk '{print $2}'`:6443 $RAND_TOKEN"
else
  append=" --server https://$1:6443"
fi

# --tls-san `hostname -I | awk '{print $1}'` \

command="curl -sfL https://get.k3s.io | \
  INSTALL_K3S_CHANNEL=latest \
  INSTALL_K3S_VERSION=v1.21.0+k3s1 \
  sh -s - \
  --disable traefik \
  --disable servicelb \
  --token $RAND_TOKEN \
  --node-ip `hostname -I | awk '{print $2}'` \
  ${append}"

eval "$command"

# Helm
curl -sfL https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz | tar -xzvf -
mv linux-amd64/helm /usr/local/bin && rm -r linux-amd64

# k9s
curl -sfL https://github.com/derailed/k9s/releases/download/v0.24.9/k9s_Linux_x86_64.tar.gz \
  | tar -xzvf -
mv k9s /usr/local/bin

# tmux
apt update
apt install tmux -y

# minimal-vimrc
wget https://raw.githubusercontent.com/k3sx/minimal-vimrc/main/.vimrc

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> $HOME/.bashrc 

cat $KUBECONFIG
kubectl get nodes -o wide

exec bash
