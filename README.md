# CICD-DEVSECOPS

What is DevSecOps? DevSecOps is a software development methodology that integrates the principles of security into the DevOps model. The DevOps methodology involves the collaboration between development and operations teams to automate the software delivery process, which includes building, testing, and deploying software quickly and efficiently.

In the context of DevSecOps, security practices are integrated into the entire software delivery lifecycle, from the early stages of development through to production deployment. This means that security is not an afterthought, but rather a fundamental part of the software development process.

DevSecOps aims to build a culture of security within organizations, by involving security teams early in the development process, and by embedding security testing and security validation into the CI/CD pipeline. The result is more secure software that is delivered more quickly and efficiently.

This project aims to fully integrate security in our DevOps pipeline and focus on:
- DevSecOps Approach
- Kubernetes Security Concepts
- HashiCorp Vault + Secret Injection into Kubernetes Pod
- Find Vulnerabilities in Dependencies, Dockerfile, Images, K8s Resources
- Unit Test, SAST (Static Code Analysis), DAST, Integration Test
- Fix/Patch Vulnerabilities in Dependencies, Dockerfile, Images, K8s Resources
- Monitoring Vulnerabilities and Kubernetes Cluster

![image](https://user-images.githubusercontent.com/50557587/230586192-cfd0fd65-57fd-4d25-a94a-b87826123533.png)

This is a typical workflow pipeline and security checks embedded in each stage.
![image](https://user-images.githubusercontent.com/50557587/230586453-65b1c833-d058-4f82-a725-b255b2fd7244.png)

In this project we will be deploying a Java based applcation into a kubernetes cluster making use of Jenkins for our continous integration and Argocd for continous deployment respectively.

## Requirements
- ec2 instance of t3.medium for our jenkins server with appropriate security settings.
<!-- - The following installation are required on our jenkins server: jenkins, maven (to build java application), Kubernetes CLI (kubectl),docker, sonarqube (for code quality analysis). -->


## Setting up Jenkins Server
We need to install jenkins unto our ec2 instance which would act as our jenkins server for our CICD build
Run the below code 

```
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
```
- Perform initial jenkins set up from your browsers `http://<Jenkins-Server-Public-IP-Address-or-Public-DNS-Name>:8080`.
- You will prompted to provide a default admin password. Retrieve from your server `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`. 
- Configure jenkins to retrieve source code from your github repo by enabling webhook in your repository.

- Create a freestyle project on the Jenkins web console named DevSecOps-CI, and provide your code github repository.
- Now, our repo has been connected to the jenkins server to pull any change from repository and build.

## Setting up our CI pipeline
We need to ensure that we have a file named Jenkinsfile in our code, which gives a detail step of what we plan to do with our code.

Since we are working with a java based application, the following stages will be setup in our jenkinsfile to implement our continous integration.
- Checkout source code
- Unit test
- Integration test
- Static code analysis with quality gate check
- Build artifact
- Vulnerability Scan
- Docker image build
- Docker image scan
- Image push to Dockerhub
- Docker Image Cleanup
- Trigger CD pipeline

## Unit Test
When working a CICD pipeline, the first thing you would want to do with your code when there is a new change to the code is to run some form of basic test on it like 
unit test, which helps developer to detect bug or issue early in the development process. Since we are working with a java application we will run `mvn test`.

```
pipeline {
    agent any
    
    stages {

    stage('Clean Workspace'){
      steps{
        script{
          cleanWs()
        }
      }
    }

    stage('Checkout SCM'){
      steps{
        script{
          git credentialsId: 'Github',
          url: 'https://github.com/Taiwolawal/CICD-DEVSECOPS.git',
          branch: 'main'
        }
      }
    }

    stage('Unit Tests: JUnit') {
      steps {
        sh "mvn test"
      }
    }
        
    }
}

```

The first two stages are meant to 
- Cleanup a workspace before starting a new build to ensure a clean environment
- Checking out the source code from a Git repository in a Jenkins pipeline

![image](https://github.com/Taiwolawal/CICD-DEVSECOPS/assets/50557587/4a361789-8ba7-4b0d-a643-c1f18996686d)
![image](https://github.com/Taiwolawal/CICD-DEVSECOPS/assets/50557587/98a2da85-c55f-45ce-a1f2-96a9d22b8947)

After running our first test, it came out successfully, which implies our code is working fine as expected.

## Integration Test
The next stage we want to run our pipeline is integration test. 

```
stage('Integration Test: Maven'){
        steps{
         sh 'mvn verify -DskipUnitTests'
        }       
    }
```


The breakdown of the command are:

mvn: This is the command to invoke the Maven build tool.

verify: This is the Maven lifecycle phase that executes the integration tests along with other lifecycle phases such as compilation, packaging, and unit testing.

-DskipTests: This Maven property skips the execution of unit tests during the build. It ensures that only the integration tests are executed in this stage

The focus of this stage is to focus on testing the integration of different components or modules of your application.

## Static Code Analysis
We will setup SonarQube to run static code analysis on our code which helps to find bugs in the development cycle and set quality gate to ensure that standards are met and regulated in the project plus defining a set of threshold measures set on your project. 

Since we will be working with containerised application in this project we could set up a sonarqube container.

Install docker on our jenkins-server.

````
sudo apt-get update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
sudo apt update -y
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
sudo chmod 777 /var/run/docker.sock 
````

Set up Sonarqube as a container running on our jenkins server `sudo docker run -d --name sonarqube -p 9000:9000 sonarqube`. Ensure you open port 9000 on your jenkins-server.


Install necessary plugins required for sonarqube 








<img width="1361" alt="image" src="https://user-images.githubusercontent.com/50557587/230621941-05aa0d27-1ea2-4f6b-ae5e-f40683d49a9b.png">

Secuity group settings to allow ssh into the server, connect to jenkins server which opens on port 8080
<img width="1336" alt="image" src="https://user-images.githubusercontent.com/50557587/230622290-5bb9bae6-2515-4f48-aafa-566fc782073c.png">

Our Jenkins-server is up on running

<img width="1110" alt="image" src="https://user-images.githubusercontent.com/50557587/230624361-ff7d73a3-51ba-459e-b3f1-280a7fed09b7.png">

Run the installation.sh file, to install necessary setup required for the project such as jenkins, maven, kubectl, java and docker

<img width="1091" alt="image" src="https://user-images.githubusercontent.com/50557587/230627131-aaafa007-69b6-47ac-b656-abd3f507233a.png">

Jenkins is up and running
<img width="1409" alt="image" src="https://user-images.githubusercontent.com/50557587/230627570-b00d52f1-9eba-49d0-a04a-88e465896f2e.png">

Installation complete
<img width="1019" alt="image" src="https://user-images.githubusercontent.com/50557587/230652685-e0358e35-03f4-4578-b9e3-38c511407671.png">

We need to install some plugin needed by jenkins
- kubernetes-cli
- Blue-ocean (to display our pipeline properly)

We can test our pipeline running a small test

<img width="1373" alt="image" src="https://user-images.githubusercontent.com/50557587/230690006-a814a559-354d-4188-8be3-631982a78c29.png">

<img width="1392" alt="image" src="https://user-images.githubusercontent.com/50557587/230689824-23416b63-d532-4dce-b874-5341ee9e1941.png">

The error we got in the screenshot was mainly because we do not have a kubernetes cluster set up yet and we need to run it in the format below

<img width="760" alt="image" src="https://user-images.githubusercontent.com/50557587/230690480-4ed5f587-c392-4398-9b72-374404e36d0c.png">











