# cluster-installation Specification

## Purpose

Define los requisitos funcionales, configuraciones de entorno y pasos de verificación para desplegar un cluster de Kubernetes de dos nodos utilizando kubeadm, containerd y Ubuntu Server 22.04 sobre VirtualBox.

## Requirements

### Requirement: Aprovisionamiento y Red de Máquinas Virtuales
The system SHALL document the minimum hardware requirements and dual network topology (NAT and Host-Only) for both the master and worker virtual machines, providing step-by-step visual guidance with screenshots and explanatory captions for VirtualBox network setup and node provisioning.

#### Scenario: Configuración de hardware y red de nodos
- **WHEN** el alumno provisiona las VMs en VirtualBox 7.0
- **THEN** la VM k8s-master dispone de al menos 2 vCPUs y 3 GB RAM, la VM k8s-worker1 dispone de al menos 2 vCPUs y 2 GB RAM, y ambas poseen un adaptador NAT y un adaptador Host-Only con direccionamiento estático en 192.168.56.0/24 sin solapamiento de MACs.

#### Scenario: Guía visual para la creación de red virtual sólo-anfitrión
- **WHEN** el alumno consulta el procedimiento de configuración de red en la sección 2.2
- **THEN** la documentación incluye la captura `step_00.png` ilustrando la creación de la red `vboxnet0` en la interfaz de VirtualBox junto con su explicación detallada.

#### Scenario: Guía visual paso a paso para la creación de VM master
- **WHEN** el alumno crea y configura la máquina virtual `k8s-master`
- **THEN** la sección 2.2 presenta ordenadamente las 20 capturas secuenciales (`step_01.png` a `step_20.png`) alojadas en `docs/images/master/` detallando hardware, adaptadores de red y cada pantalla del instalador de Ubuntu Server con notas explicativas al pie.

#### Scenario: Guía visual paso a paso para la creación de VM worker
- **WHEN** el alumno crea y configura la máquina virtual `k8s-worker1`
- **THEN** la sección 2.2 presenta ordenadamente las 20 capturas secuenciales (`step_01.png` a `step_20.png`) alojadas en `docs/images/worker/` detallando hardware, adaptadores de red y cada pantalla del instalador de Ubuntu Server con notas explicativas al pie.

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
The system SHALL guide Kubernetes Dashboard deployment, pod health verification, administrative service account creation with cluster-admin binding, token generation, secure proxy access, and visual verification with interface screenshots.

#### Scenario: Despliegue y verificación de componentes del Dashboard
- **WHEN** el alumno aplica el manifiesto oficial del Dashboard con `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml`
- **THEN** la guía detalla la creación de todos los recursos y verifica mediante `kubectl get pods -n kubernetes-dashboard` que los pods `kubernetes-dashboard` y `dashboard-metrics-scraper` están en estado Running.

#### Scenario: Creación y verificación de cuenta administrativa RBAC
- **WHEN** el alumno crea y aplica el manifiesto `dashboard-adminuser.yaml` vinculando la cuenta `admin-user` al rol `cluster-admin`
- **THEN** la guía confirma la creación del ServiceAccount y ClusterRoleBinding, y valida su existencia mediante `kubectl get serviceaccount admin-user -n kubernetes-dashboard`.

#### Scenario: Acceso web al Dashboard
- **WHEN** el alumno genera el token de autenticación con `kubectl -n kubernetes-dashboard create token admin-user`, ejecuta `kubectl proxy` y navega a la URL del proxy
- **THEN** la guía documenta el acceso por token, ilustra la pantalla de autenticación con `k8s_dashboard_login.png` y muestra la interfaz gráfica interna con los recursos del namespace mediante `k8s_dashboard.png`.
