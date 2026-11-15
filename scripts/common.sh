#!/bin/bash
# =============================================================================
# scripts/common.sh: Configuración base del sistema para todos los nodos
# =============================================================================
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "==> [COMMON] 1. Configurando resolución en /etc/hosts..."
grep -q "k8s-master" /etc/hosts || cat <<EOF >> /etc/hosts
192.168.56.10 k8s-master
192.168.56.11 k8s-worker1
EOF

echo "==> [COMMON] 2. Desactivando memoria SWAP permanentemente..."
swapoff -a
sed -i '/^\/swap\.img/ s/^/#/' /etc/fstab

echo "==> [COMMON] 3. Cargando módulos de kernel necesarios (overlay, br_netfilter)..."
cat <<EOF > /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

echo "==> [COMMON] 4. Configurando parámetros sysctl de red y enrutamiento..."
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system > /dev/null

echo "==> [COMMON] 5. Instalando y configurando Containerd y dependencias de red..."
apt-get update -y > /dev/null
apt-get install -y containerd apt-transport-https ca-certificates curl gpg conntrack socat > /dev/null

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd > /dev/null

echo "==> [COMMON] 6. Instalando paquetes oficiales de Kubernetes v1.31 (pkgs.k8s.io)..."
K8S_REPO="https://pkgs.k8s.io/core:/stable:/v1.31/deb/"
KEYRING="/etc/apt/keyrings/kubernetes-apt-keyring.gpg"
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL "${K8S_REPO}Release.key" | gpg --dearmor --yes -o "${KEYRING}"
echo "deb [signed-by=${KEYRING}] ${K8S_REPO} /" > /etc/apt/sources.list.d/kubernetes.list

apt-get update -y > /dev/null
apt-get install -y kubelet kubeadm kubectl > /dev/null
apt-mark hold kubelet kubeadm kubectl > /dev/null

echo "==> [COMMON] Configuración base finalizada con éxito."
