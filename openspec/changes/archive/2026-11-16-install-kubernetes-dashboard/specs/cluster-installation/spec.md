# Spec Delta: cluster-installation

## MODIFIED Requirements

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
