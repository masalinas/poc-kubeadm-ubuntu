# -*- mode: ruby -*-
# vi: set ft=ruby :

# =============================================================================
# CURSO DE KUBERNETES: CAPÍTULO 1 - INSTALACIÓN DE INFRAESTRUCTURA PRODUCTIVA
# Vagrantfile para despliegue automatizado de cluster K8s v1.31 en VirtualBox
# =============================================================================

Vagrant.configure("2") do |config|
  # Imagen base oficial de Ubuntu Server 22.04 LTS (Jammy Jellyfish)
  config.vm.box = "ubuntu/jammy64"

  # Carpeta compartida para intercambio de kubeconfig y token de unión
  config.vm.synced_folder "./configs", "/vagrant_configs", create: true

  # Deshabilitar comprobación de actualizaciones de box para mayor velocidad
  config.vm.box_check_update = false

  # ===========================================================================
  # 1. NODO MASTER (Plano de Control)
  # ===========================================================================
  config.vm.define "k8s-master" do |master|
    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: "192.168.56.10"

    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
      vb.cpus = 2
      vb.memory = 3072
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
    end

    # Aprovisionamiento secuencial: Común del SO seguido de inicialización Master
    master.vm.provision "shell", path: "scripts/common.sh"
    master.vm.provision "shell", path: "scripts/master.sh"
  end

  # ===========================================================================
  # 2. NODO WORKER (Nodo de Trabajo)
  # ===========================================================================
  config.vm.define "k8s-worker1" do |worker|
    worker.vm.hostname = "k8s-worker1"
    worker.vm.network "private_network", ip: "192.168.56.11"

    worker.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-worker1"
      vb.cpus = 2
      vb.memory = 2048
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
    end

    # Aprovisionamiento secuencial: Común del SO seguido de unión al cluster
    worker.vm.provision "shell", path: "scripts/common.sh"
    worker.vm.provision "shell", path: "scripts/worker.sh"
  end
end
