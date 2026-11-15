# manual-lab-setup Specification

## Purpose

Define los requisitos de configuración base para el entorno de laboratorio, incluyendo la distribución de teclado en español, la creación de la red vboxnet0 en VirtualBox y el bloqueo de cloud-init para la persistencia de Netplan.

## Requirements

### Requirement: Configuración de Idioma y Distribución de Teclado
The system SHALL provide explicit steps to configure Spanish keyboard layout and locales on Ubuntu Server nodes to prevent typographical errors during command execution.

#### Scenario: Teclado configurado en español
- **WHEN** el alumno inicia sesión en las VMs de Ubuntu Server
- **THEN** ejecuta `localectl set-x11-keymap es pc105` y `loadkeys es`, permitiendo escribir caracteres especiales como tildes, guiones, barras y tuberías sin discrepancias de teclado.

### Requirement: Creación de Red Virtual vboxnet0 en VirtualBox
The system SHALL detail the manual creation of the Host-Only network `vboxnet0` in VirtualBox before creating the virtual machines.

#### Scenario: Red sólo-anfitrión disponible antes del aprovisionamiento
- **WHEN** el alumno accede a Herramientas de VirtualBox -> Redes
- **THEN** crea la red `vboxnet0` con rango `192.168.56.0/24` y configura cada VM con el Adaptador 1 en NAT y el Adaptador 2 en Host-Only con modo promiscuo en Permitir todo.

### Requirement: Persistencia de Red Netplan y Bloqueo de Cloud-Init
The system SHALL specify the deactivation of cloud-init network configuration and the static IP assignment in Netplan file 50-cloud-init.yaml.

#### Scenario: Configuración de red persistente entre reinicios
- **WHEN** se crea `/etc/cloud/cloud-init.disabled` y se configura `/etc/netplan/50-cloud-init.yaml`
- **THEN** `netplan apply` asigna `192.168.56.10/24` en master y `192.168.56.11/24` en worker1, manteniéndose invariable tras reiniciar la VM.
