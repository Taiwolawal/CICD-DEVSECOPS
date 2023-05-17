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
- ec2 instance for our jenkins server with appropriate security settings
- Install jenkins, maven (to build java application), Kubernetes CLI (kubectl), and docker onto our jenkins server.

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

## Use case
![image](https://user-images.githubusercontent.com/50557587/230690630-cdb9d6bc-d2d2-4fbe-81cb-08d1c31db32b.png)









