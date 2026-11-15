# Description
Configurar la nueva interface de tipo Solo Anfitrion llamada enp0s8 recien creada en cada nodo: master y worker01

## Crear archivo de bloqueo para cloud-init
En cada node: master y worker1 ejecutar:
```shell
$ sudo touch /etc/cloud/cloud-init.disabled
```

## Añadir la interfaz enp0s8
En cada node: master y worker1 ejecutar:
```shell
$ sudo nano /etc/netplan/50-cloud-init.yaml
```

Añadir la interfaz enp0s8 para el node master, seleccionado la ip 192.168.56.10/24
```shell
network:
  ethernets:
    enp0s3:
      dhcp4: true
      optional: true
    enp0s8:
      dhcp4: false
      addresses:
      - 192.168.56.10/24
      optional: true
  version: 2
```

Añadir la interfaz enp0s8 para el node worker1, seleccionado la ip 192.168.56.11/24
```shell
network:
  ethernets:
    enp0s3:
      dhcp4: true
      optional: true
    enp0s8:
      dhcp4: false
      addresses:
      - 192.168.56.11/24
      optional: true
  version: 2
```

## Aplicar los cambios de red
Aplicar los cambios en cada nodo:
```shell
$ sudo netplan apply
```

## Check the new ip for the interface
Check for master node
```shell
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:f9:da:df brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 metric 100 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86121sec preferred_lft 86121sec
    inet6 fe80::a00:27ff:fef9:dadf/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:a2:c7:8f brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.10/24 brd 192.168.56.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea2:c78f/64 scope link
       valid_lft forever preferred_lft forever
```

Check for worker1 node
````shell
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:17:40:ea brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 metric 100 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86242sec preferred_lft 86242sec
    inet6 fe80::a00:27ff:fe17:40ea/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:34:ea:f7 brd ff:ff:ff:ff:ff:ff
    inet 192.168.56.11/24 brd 192.168.56.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe34:eaf7/64 scope link
       valid_lft forever preferred_lft forever
```
