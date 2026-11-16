# Spec Delta: cluster-installation

## MODIFIED Requirements

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
