# Description
Configurar el host para conectarse al cluster de kubernetes

Nos bajamos el .kube/config del master a local
scp <usuario>@192.168.56.10:~/.kube/config ./

Editamos nuestro config local y añadimos el cluster, user y el contexo (union de cluster y user) y ponemos como contexto por defecto al de nuestro nuevo cluster:
```shell
kubernetes-admin@kubernetes
```

Tras editar nuestro config local ya podemos acceder a nuestro nuevo cluster con comandos como los siguientes
```shell
$ kubectl cluster-info
Kubernetes control plane is running at https://192.168.56.10:6443
CoreDNS is running at https://192.168.56.10:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

$ kubectl get nodes -o wide
NAME          STATUS   ROLES           AGE   VERSION    INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
k8s-master    Ready    control-plane   49m   v1.31.14   192.168.56.10   <none>        Ubuntu 22.04.5 LTS   5.15.0-203-generic   containerd://2.2.1
k8s-worker1   Ready    <none>          21m   v1.31.14   192.168.56.11   <none>        Ubuntu 22.04.5 LTS   5.15.0-203-generic   containerd://2.2.1
```
