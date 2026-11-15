# Spec Delta: vagrant-automation

## Purpose

Define los requisitos funcionales, especificaciones de infraestructura como código y scripts de aprovisionamiento para desplegar el cluster de Kubernetes de forma automatizada mediante Vagrant y VirtualBox.

## ADDED Requirements

### Requirement: Definición de Infraestructura con Vagrantfile
The system SHALL provide a multi-machine Vagrantfile defining k8s-master and k8s-worker1 using the ubuntu/jammy64 base box and VirtualBox provider.

#### Scenario: Creación de máquinas con recursos adecuados
- **WHEN** el alumno ejecuta `vagrant up`
- **THEN** se crean dos máquinas virtuales donde k8s-master tiene 2 vCPUs y 3072 MB de RAM con IP fija 192.168.56.10, y k8s-worker1 tiene 2 vCPUs y 2048 MB de RAM con IP fija 192.168.56.11, ambas con acceso a internet vía NAT.

### Requirement: Aprovisionamiento Automatizado del Sistema Operativo
The system SHALL provide an automated shell provisioning script that prepares swap, kernel modules, sysctl parameters, containerd, and Kubernetes packages on all nodes.

#### Scenario: Configuración desatendida de nodos
- **WHEN** Vagrant ejecuta el script de aprovisionamiento común
- **THEN** el swap queda deshabilitado permanentemente, los módulos de red cargados, containerd ejecutándose con cgroups en systemd y kubelet/kubeadm v1.31 instalados sin intervención interactiva.

### Requirement: Inicialización y Unión Automatizada del Cluster
The system SHALL automate cluster control plane initialization on the master node, export the join command to a shared folder, and execute it on the worker node.

#### Scenario: Cluster totalmente operativo tras vagrant up
- **WHEN** finaliza la ejecución de `vagrant up` en el equipo host
- **THEN** k8s-master ha inicializado el cluster con Flannel CNI, k8s-worker1 se ha unido exitosamente al cluster, y el archivo kubeconfig queda disponible para su uso desde el host.
