# Design: Integración de Mejoras Prácticas en la Guía Manual

## Context

Ver `proposal.md` - Why. La experiencia práctica en laboratorio evidenció cinco puntos clave de fricción que deben ser integrados en la guía técnica y en el pipeline de generación del PDF para garantizar la total reproducibilidad del curso.

## Goals / Non-Goals

**Goals:**
- Estructurar de manera fluida y didáctica los nuevos capítulos y pasos en la Sección 1 (Despliegue Manual).
- Asegurar que la configuración de red estática en Ubuntu 22.04 sea inmune a la reescritura automática por parte de `cloud-init`.
- Garantizar que los preflight checks de Kubernetes se ejecuten sin alertas instalando previamente `conntrack` y `socat`.
- Ofrecer una solución robusta y no destructiva para conectar el cliente `kubectl` del host anfitrión sin poner en riesgo clusters preexistentes.
- Mantener la coherencia entre la Sección 1 (Manual) y la Sección 2 (Vagrant), actualizando `scripts/common.sh` con las mismas dependencias.

**Non-Goals:**
- Modificar el direccionamiento IP de la arquitectura (`192.168.56.10` y `192.168.56.11` se mantienen como el estándar del curso).
- Reemplazar Netplan por otro gestor de red en Ubuntu Server.

## Decisions

### Decisión 1: Reorganización Secuencial de la Sección 1
- **Elección:** Reorganizar la Sección 1 en el siguiente orden lógico:
  - *Paso 2.1:* Creación previa de la red `vboxnet0` en VirtualBox (antes de crear las VMs).
  - *Paso 2.2:* Creación y dimensionamiento de las máquinas virtuales (Master y Worker).
  - *Paso 2.3:* Configuración inicial: teclado y locale en español (`localectl` y `loadkeys`).
  - *Paso 2.4:* Red persistente: bloqueo de `cloud-init` y configuración de Netplan (`50-cloud-init.yaml`).
  - *Paso 2.5:* Desactivación de SWAP, módulos de kernel (`overlay`, `br_netfilter`) y sysctl.
  - *Paso 2.6:* Runtime `containerd` y dependencias base del cluster (`conntrack`, `socat`).
  - *Paso 2.7:* Herramientas Kubernetes v1.31 (`pkgs.k8s.io`).
  - *Paso 2.8:* Inicialización del Master (`kubeadm init`), Flannel CNI e integración de registros reales.
  - *Paso 2.9:* Unión del Worker (`kubeadm join`) con dependencias previas y registros reales.
  - *Paso 2.10:* Conexión remota desde el Host mediante fusión de `kubeconfig` (Merge manual y CLI).
  - *Paso 2.11:* Despliegue y acceso a Kubernetes Dashboard.
- **Razón:** Sigue la cronología real que experimenta el alumno desde que abre VirtualBox hasta que administra el cluster desde su terminal local.

### Decisión 2: Desactivación de Cloud-Init para Persistencia de Red
- **Elección:** Aplicar `sudo touch /etc/cloud/cloud-init.disabled`.
- **Razón:** Ubuntu Server 22.04 reescribe la configuración de red a través de su generador cloud-init si no se deshabilita de manera explícita, lo que provocaría la pérdida de la IP estática `192.168.56.x` en reinicios posteriores. La creación de este archivo bloquea cloud-init por completo.

### Decisión 3: Incorporación de `conntrack` y `socat`
- **Elección:** Añadir `sudo apt-get install -y conntrack socat` en el paso de preparación de dependencias de ambos nodos.
- **Razón:** `conntrack` es requerido internamente por `kube-proxy` para la gestión de tablas NAT de netfilter, mientras que `socat` es requerido por el API Server para túneles y comandos remotos (`kubectl exec`, `kubectl port-forward`).

### Decisión 4: Estrategia de Fusión de Kubeconfig en el Host (No Destructiva)
- **Elección:** En lugar de `scp ... ~/.kube/config`, documentar:
  1. Descarga a un archivo temporal `master-kubeconfig`.
  2. Método manual: Copia de los bloques `cluster`, `user` y `context`.
  3. Método automatizado de fusión:
     ```bash
     KUBECONFIG=~/.kube/config:./master-kubeconfig kubectl config view --flatten > ~/.kube/config.new
     mv ~/.kube/config.new ~/.kube/config
     ```
  4. Activación del contexto: `kubectl config use-context kubernetes-admin@kubernetes`.
- **Razón:** Evita incidentes graves en equipos de alumnos o instructores que ya gestionan otros entornos de trabajo.

## Risks / Trade-offs

- **[Risk] Complejidad en la fusión manual de kubeconfig** → *Mitigation*: Se proporcionan ambos métodos: el manual (para comprender la estructura interna de Kubernetes) y el comando automatizado con `kubectl config view --flatten`.
- **[Risk] Discrepancia entre la guía manual y los scripts de Vagrant** → *Mitigation*: Se actualiza `scripts/common.sh` para incluir también `conntrack` y `socat`.
