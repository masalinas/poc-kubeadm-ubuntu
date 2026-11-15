# Description
Antes de unir el nodo worker1 al cluster de kubernetes debo instalar unas dependecias

$ sudo apt-get update && sudo apt-get install -y conntrack socat

Ahora ya puedo unir el nodo worker1 al cluster kubernetes atraves del master utilzando las credentiales obtenidas en pasos anteriores:
```shell
$ sudo kubeadm join 192.168.56.10:6443 --token 5yjuf0.zo38v6ts77dd8zjc  --discovery-token-ca-cert-hash sha256:3bf340abd39b6c6d30c33c163a9ceccc170567ea6f52f0007b59d3608f2a4e11
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-check] Waiting for a healthy kubelet at http://127.0.0.1:10248/healthz. This can take up to 4m0s
[kubelet-check] The kubelet is healthy after 1.001529458s
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
