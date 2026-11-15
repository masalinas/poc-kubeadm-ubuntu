# cluster-installation Specification

## Purpose

Define los requisitos funcionales, configuraciones de entorno y pasos de verificación para desplegar un cluster de Kubernetes de dos nodos utilizando kubeadm, containerd y Ubuntu Server 22.04 sobre VirtualBox.

## Requirements

### Requirement: Aprovisionamiento y Red de Máquinas Virtuales
The system SHALL document the minimum hardware requirements and dual network topology (NAT and Host-Only) for both the master and worker virtual machines.

#### Scenario: Configuración de hardware y red de nodos
- **WHEN** el alumno provisiona las VMs en VirtualBox 7.0
- **THEN** la VM k8s-master dispone de al menos 2 vCPUs y 3 GB RAM, la VM k8s-worker1 dispone de al menos 2 vCPUs y 2 GB RAM, y ambas poseen un adaptador NAT y un adaptador Host-Only con direccionamiento estático en 192.168.56.0/24 sin solapamiento de MACs.

### Requirement: Preparación del Sistema Operativo y Dependencias Base
The system SHALL specify permanent swap disabling, network kernel module loading, and sysctl parameter configuration on all cluster nodes.

#### Scenario: Verificación de configuración del host
- **WHEN** se ejecutan las comprobaciones previas en cualquier nodo
- **THEN** el comando `swapon --show` devuelve vacío, los módulos `overlay` y `br_netfilter` están cargados, y `net.ipv4.ip_forward` es igual a 1.

### Requirement: Configuración de Runtime Containerd y Repositorios Kubernetes
The system SHALL detail containerd installation with SystemdCgroup support and installation of kubeadm, kubelet, and kubectl from the pkgs.k8s.io repository.

#### Scenario: Validación de containerd y kubeadm
- **WHEN** se verifica el estado de containerd y kubeadm
- **THEN** containerd se ejecuta con `SystemdCgroup = true` y los paquetes kubelet, kubeadm y kubectl corresponden a la versión 1.31 fijados con apt-mark hold.

### Requirement: Inicialización del Plano de Control y Despliegue de CNI
The system SHALL detail cluster initialization with kubeadm init binding to the Host-Only IP, setting pod CIDR, and applying Flannel CNI configured for that interface.

#### Scenario: Cluster master listo
- **WHEN** se completa kubeadm init y se aplica el manifiesto CNI Flannel
- **THEN** el nodo k8s-master alcanza el estado Ready y el comando `kubectl get nodes` reporta el nodo como maestro operativo.

### Requirement: Incorporación del Nodo Worker y Configuración de Kubectl Remoto
The system SHALL detail worker node join procedure with cluster tokens and export of kubeconfig credentials for remote management from the physical host.

#### Scenario: Cluster completo y gestión remota
- **WHEN** el worker ejecuta kubeadm join y el host copia el archivo kubeconfig
- **THEN** `kubectl get nodes` ejecutado desde el host Ubuntu 20.04 muestra ambos nodos k8s-master y k8s-worker1 en estado Ready.

### Requirement: Despliegue y Acceso al Dashboard de Kubernetes
The system SHALL guide Kubernetes Dashboard installation, administrative service account creation with cluster-admin binding, and token-based access via kubectl proxy.

#### Scenario: Acceso web al Dashboard
- **WHEN** el usuario inicia `kubectl proxy` y accede con el token generado
- **THEN** el panel gráfico de Kubernetes es accesible desde el navegador del host y permite visualizar el estado del cluster.
