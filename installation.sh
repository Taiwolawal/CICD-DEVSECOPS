#!/bin/bash

echo ".........----------------#################._.-.-INSTALL-.-._.#################----------------........."


echo ".........----------------#################._.-.-Java and MAVEN-.-._.#################----------------........."
sudo apt install openjdk-8-jdk -y
java -version
sudo apt install -y maven
mvn -v


echo ".........----------------#################._.-.-Kubectl-.-._.#################----------------........."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client


echo ".........----------------#################._.-.-Docker-.-._.#################----------------........."
sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo chmod 777 /var/run/docker.sock  
sudo usermod -a -G docker jenkins


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


echo ".........----------------#################._.-.-Jenkins-.-._.#################----------------........."
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


