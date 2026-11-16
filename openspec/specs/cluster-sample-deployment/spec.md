# cluster-sample-deployment Specification

## Purpose

Define los requisitos funcionales, procedimientos de despliegue y criterios de verificación para ejecutar una carga de trabajo de prueba (Nginx), exponerla mediante un servicio NodePort y validar la conectividad HTTP externa a través de las IPs del cluster.

## Requirements

### Requirement: Despliegue e Inspección de la Carga de Trabajo Nginx
The system SHALL provide detailed instructions and verified terminal logs for deploying an Nginx workload and inspecting its associated deployment, replicaset, and pod resources.

#### Scenario: Despliegue e inspección de objetos en el namespace default
- **WHEN** el alumno ejecuta el comando `kubectl create deployment nginx-test --image=nginx` y consulta los recursos con `kubectl get deployments,rs,pods -o wide`
- **THEN** la guía detalla la creación del despliegue y muestra las salidas reales con estado `Running`, selector `app=nginx-test` y el nodo worker asignado.

### Requirement: Exposición de Carga de Trabajo mediante Servicio NodePort
The system SHALL document exposing the Nginx deployment through a NodePort service on port 80 and validating the assigned port in the 30000-32767 range across all cluster nodes.

#### Scenario: Creación e inspección del servicio NodePort
- **WHEN** el alumno ejecuta `kubectl expose deployment nginx-test --port=80 --type=NodePort` y comprueba el servicio con `kubectl get services -o wide`
- **THEN** la guía muestra el servicio creado con tipo NodePort, su IP de cluster y el puerto externo aleatorio asignado.

### Requirement: Validación de Acceso y Conectividad HTTP Externa
The system SHALL guide the student on verifying HTTP connectivity to the deployed service from an external browser or shell using either the master or worker node Host-Only IP.

#### Scenario: Petición HTTP exitosa vía cURL y navegador
- **WHEN** el usuario realiza una petición HTTP contra `192.168.56.10:<NodePort>` o `192.168.56.11:<NodePort>` usando `curl` o un navegador web
- **THEN** el servicio responde con código 200 OK y devuelve la página HTML estándar de bienvenida de Nginx ("Welcome to nginx!").

### Requirement: Acceso Temporal mediante Port-Forward y Limpieza de Recursos
The system SHALL document configuring a temporary port forward using kubectl port-forward for testing and provide commands for deleting the deployed resources.

#### Scenario: Redirección de puerto con kubectl port-forward
- **WHEN** el alumno ejecuta `kubectl port-forward deployment/nginx-test 8080:80 --address 0.0.0.0`
- **THEN** el comando redirige el tráfico del puerto 8080 hacia el puerto 80 del deployment para pruebas directas.

#### Scenario: Eliminación de recursos de prueba
- **WHEN** el alumno finaliza la práctica y ejecuta `kubectl delete deployment,svc nginx-test`
- **THEN** Kubernetes elimina tanto el deployment como el servicio liberando los recursos del cluster.
