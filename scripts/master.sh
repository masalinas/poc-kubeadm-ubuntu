#!/bin/bash
# =============================================================================
# scripts/master.sh: Inicialización del Plano de Control (k8s-master)
# =============================================================================
set -euo pipefail

MASTER_IP="192.168.56.10"
POD_CIDR="10.244.0.0/16"

echo "==> [MASTER] 1. Pre-descargando imágenes del plano de control..."
kubeadm config images pull > /dev/null

echo "==> [MASTER] 2. Inicializando cluster de Kubernetes con kubeadm init..."
kubeadm init \
  --apiserver-advertise-address="${MASTER_IP}" \
  --pod-network-cidr="${POD_CIDR}" \
  --node-name k8s-master > /dev/null

echo "==> [MASTER] 3. Configurando credenciales kubeconfig para el usuario vagrant y root..."
mkdir -p /home/vagrant/.kube /root/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "==> [MASTER] 4. Exportando kubeconfig al directorio compartido para el host..."
mkdir -p /vagrant_configs
cp -i /etc/kubernetes/admin.conf /vagrant_configs/config
chmod 644 /vagrant_configs/config

echo "==> [MASTER] 5. Desplegando CNI Flannel con enlace forzado a la interfaz enp0s8..."
FLANNEL_URL="https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml"
curl -sSL "${FLANNEL_URL}" -o /tmp/kube-flannel.yml
sed -i 's/- --kube-subnet-mgr/- --kube-subnet-mgr\n        - --iface=enp0s8/' /tmp/kube-flannel.yml
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f /tmp/kube-flannel.yml > /dev/null

echo "==> [MASTER] 6. Desplegando Kubernetes Dashboard oficial..."
DASHBOARD_URL="https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml"
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f "${DASHBOARD_URL}" > /dev/null

# Crear ServiceAccount y ClusterRoleBinding para Dashboard
cat <<EOF | kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f - > /dev/null
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

echo "==> [MASTER] 7. Generando token para Kubernetes Dashboard..."
kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kubernetes-dashboard create token admin-user > /vagrant_configs/dashboard-token.txt
chmod 644 /vagrant_configs/dashboard-token.txt

echo "==> [MASTER] 8. Generando comando de unión automatizado para workers..."
kubeadm token create --print-join-command > /vagrant_configs/join.sh
chmod +x /vagrant_configs/join.sh

echo "==> [MASTER] ¡Plano de control inicializado y listo!"
