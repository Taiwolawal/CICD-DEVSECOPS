#!/bin/bash

echo ".........----------------#################._.-.-INSTALL-.-._.#################----------------........."


echo ".........----------------#################._.-.-MAVEN-.-._.#################----------------........."
sudo apt update -y
sudo apt install maven -y
mvn -version


echo ".........----------------#################._.-.-Jenkins-.-._.#################----------------........."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword


echo ".........----------------#################._.-.-Sonarqube-.-._.#################----------------........."
sudo docker run -d --name sonarqube -p 9000:9000 sonarqube



echo ".........----------------#################._.-.-Kubectl-.-._.#################----------------........."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client


echo ".........----------------#################._.-.-Docker-.-._.#################----------------........."
sudo apt-get update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
sudo apt update -y
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
sudo chmod 777 /var/run/docker.sock  


echo ".........----------------#################._.-.-Trivy-.-._.#################----------------........."
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy


echo ".........----------------#################._.-.-KubeSec-.-._.#################----------------........."
curl -LO "https://github.com/controlplaneio/kubesec/releases/latest/download/kubesec-linux-amd64"
chmod +x kubesec-linux-amd64
sudo mv kubesec-linux-amd64 /usr/local/bin/kubesec
kubesec version





