# CICD-DEVSECOPS

CI/CD (Continuous Integration/Continuous Deployment) DevSecOps is a software development methodology that integrates the principles of security into the DevOps model. The DevOps methodology involves the collaboration between development and operations teams to automate the software delivery process, which includes building, testing, and deploying software quickly and efficiently.

In the context of DevSecOps, security practices are integrated into the entire software delivery lifecycle, from the early stages of development through to production deployment. This means that security is not an afterthought, but rather a fundamental part of the software development process.

DevSecOps aims to build a culture of security within organizations, by involving security teams early in the development process, and by embedding security testing and security validation into the CI/CD pipeline. The result is more secure software that is delivered more quickly and efficiently.

This project aims to fully integrate security in our DevOps pipeline and focus on:
- DevSecOps Approach
- Kubernetes Security Concepts
- HashiCorp Vault + Secret Injection into Kubernetes Pod
- Find Vulnerabilities in Dependencies, Dockerfile, Images, K8s Resources
- Unit Test, Mutation Test, SAST, DAST, Integration Test
- Integrate/Shifting Security Left within the DevOps Pipeline
- Fix/Patch Vulnerabilities in Dependencies, Dockerfile, Images, K8s Resources
- Monitoring Vulnerabilities and Kubernetes Cluster

![image](https://user-images.githubusercontent.com/50557587/230586192-cfd0fd65-57fd-4d25-a94a-b87826123533.png)

This is a typical workfflow a pipeline and security checks embedded in each stage.
![image](https://user-images.githubusercontent.com/50557587/230586453-65b1c833-d058-4f82-a725-b255b2fd7244.png)

In this project we will be deploying a Java based applcation into a kubernetes cluster making use of Jenkins for our continous integration and Argocd for continous deployment respectively.

## Setting up our DevOps Pipeline
We will be creating a jenkins server and a kubernetes cluster

# Jenkins Setup

<img width="1410" alt="image" src="https://user-images.githubusercontent.com/50557587/230592827-2e11fc69-85db-486f-aef9-b1eeebff0e09.png">

<img width="1012" alt="image" src="https://user-images.githubusercontent.com/50557587/230592922-f42e1c99-b8c7-4c12-8644-e55f7ec8d14a.png">

When our Jenkins server is up, we need ensure we have some installations done on the server that will be needed for our CICD pipeline to function properly. They are Git, Kubernetes CLI, kubectl,  Maven and Docker.

<img width="1361" alt="image" src="https://user-images.githubusercontent.com/50557587/230621941-05aa0d27-1ea2-4f6b-ae5e-f40683d49a9b.png">

Secuity group settings to allow ssh into the server, connect to jenkins server which opens on port 8080
<img width="1336" alt="image" src="https://user-images.githubusercontent.com/50557587/230622290-5bb9bae6-2515-4f48-aafa-566fc782073c.png">

Our Jenkins-server is up on running

<img width="1110" alt="image" src="https://user-images.githubusercontent.com/50557587/230624361-ff7d73a3-51ba-459e-b3f1-280a7fed09b7.png">

# Install Jenkins
Pre-requisites:
- Java (JDK)
````
sudo apt update
sudo apt install openjdk-11-jre
````

Verify Java is installed

``java -version ``

<img width="1091" alt="image" src="https://user-images.githubusercontent.com/50557587/230627131-aaafa007-69b6-47ac-b656-abd3f507233a.png">

Jenkins is up and running
<img width="1409" alt="image" src="https://user-images.githubusercontent.com/50557587/230627570-b00d52f1-9eba-49d0-a04a-88e465896f2e.png">







