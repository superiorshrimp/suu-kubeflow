sudo apt update
echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> .bashrc
echo 'export CLUSTER_NAME=${cluster_name}' >> .bashrc
echo 'CLUSTER_REGION=${region}' >> .bashrc
source ~/.bashrc

cd ../../usr/bin
cp python3.10 python3.8
cd ../../home/ubuntu

git clone https://github.com/awslabs/kubeflow-manifests.git && cd kubeflow-manifests
sudo apt install make
sudo apt install unzip
make install-tools

sudo apt install python3-pip -y
python3 -m pip install --upgrade pip
python3 -m pip install -r tests/e2e/requirements.txt