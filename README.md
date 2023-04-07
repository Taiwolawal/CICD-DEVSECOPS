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

#Jenkins


