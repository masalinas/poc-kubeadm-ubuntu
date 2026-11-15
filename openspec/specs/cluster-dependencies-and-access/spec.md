# cluster-dependencies-and-access Specification

## Purpose

Define los requisitos de dependencias esenciales del sistema para Kubernetes, el registro de salidas reales de consola de kubeadm y el procedimiento de fusión no destructivo del archivo kubeconfig en el equipo anfitrión.

## Requirements

### Requirement: Instalación de Dependencias conntrack y socat
The system SHALL mandate the installation of conntrack and socat on both control-plane and worker nodes before cluster initialization or join.

#### Scenario: Dependencias de red instaladas
- **WHEN** se ejecutan las comprobaciones previas de kubeadm
- **THEN** los paquetes `conntrack` y `socat` están instalados en el sistema operativo, permitiendo el correcto funcionamiento de iptables connection tracking y túneles de comunicación del API Server.

### Requirement: Inicialización y Unión con Verificación de Salidas Reales
The system SHALL provide realistic, complete terminal output logs for both `kubeadm init` and `kubeadm join` to serve as a benchmark for student verification.

#### Scenario: Contraste de ejecución contra salida esperada
- **WHEN** el alumno ejecuta `kubeadm init` o `kubeadm join`
- **THEN** la guía ilustra las fases de preflight, certificados, static pods y el comando exacto generado para la unión del worker.

### Requirement: Fusión No Destructiva de Kubeconfig en el Host
The system SHALL provide non-destructive merge procedures for kubectl configuration on the host machine to preserve existing cluster contexts.

#### Scenario: Conexión remota preservando clusters previos
- **WHEN** el alumno integra el nuevo cluster en `~/.kube/config`
- **THEN** se documenta tanto la edición manual de bloques (clusters, users, contexts) como la fusión automatizada con `kubectl config view --flatten`, estableciendo `kubernetes-admin@kubernetes` como contexto activo sin sobrescribir conexiones anteriores.
