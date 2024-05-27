# Setup microk8s
sudo snap install microk8s --classic --channel=1.26/stable
sudo apt-get install dbus
sudo usermod -a -G microk8s $USER
newgrp microk8s
sudo chown -f -R $USER ~/.kube
sudo microk8s enable dns hostpath-storage ingress metallb:10.64.140.43-10.64.140.49 rbac

# Setup  Juju
sudo snap install juju --classic --channel=3.1/stable
mkdir -p ~/.local/share

# Jezeli nie uda się wpiąć w juju przy wykorzystaniu komend, to kroki poniżej należy wykonać ręcznie
sudo -i
sudo microk8s config | juju add-k8s my-k8s --client
juju bootstrap my-k8s uk8sx
juju add-model kubeflow


# Deploy stage
sudo sysctl fs.inotify.max_user_instances=1280
sudo sysctl fs.inotify.max_user_watches=655360
juju deploy kubeflow --trust  --channel=1.8/stable