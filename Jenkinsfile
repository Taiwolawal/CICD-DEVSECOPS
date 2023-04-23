pipeline {
  agent any

  environment{
    DOCKERHUB_USERNAME = "wizhubdocker8s"
    APP_NAME = "java-app-argo"
    IMAGE_TAG = "${BUILD_NUMBER}"
    IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
    DOCKER_CREDS = credentials('dockerhub')
    
  }

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

    stage('Integration Test: Maven'){
        steps{
         sh 'mvn verify -DskipUnitTests'
        }       
    }
 
    stage('Static Code Analysis: Sonarqube') {
      steps {
        withSonarQubeEnv(credentialsId: 'jenkins-sonar', installationName: 'sonar-api') {
          sh 'mvn clean package sonar:sonar' 
        }
      }   
    }

    stage('Quality Gate Check Status: Sonarqube'){
      steps{
        waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonar'
      }
    }

    stage('Build Artifact: Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts 'target/*.jar'
      }
    }

    stage('Vulnerability Scan'){
      steps{
        parallel(
          "Dependency Scan":{
            sh "mvn dependency-check:check"
          }, 
          "Dockerfile Scan":{
            script {
              sh "trivy config Dockerfile"
              //sh "bash trivy-dockerfile-image-scan.sh"
              sh "trivy fs Dockerfile"
            }
          }
        )      
      }
    }  

    stage('Docker Image Build'){
      steps{
          sh "docker build -t ${IMAGE_NAME} ."  
          sh "docker image tag ${IMAGE_NAME} ${IMAGE_NAME}:${IMAGE_TAG}"
          sh "docker image tag ${IMAGE_NAME} ${IMAGE_NAME}:latest"
      } 
    }

    stage('Docker Image Scan: Trivy'){
      steps{
          sh "trivy image ${IMAGE_NAME}:latest > scan.txt"
          sh "cat scan.txt"  
          //sh "bash trivy-image-scan.sh"
      }
    }

    stage('Docker Image Push: DockerHub'){
      steps{
          sh 'docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW'
          sh "docker image push ${IMAGE_NAME}:${IMAGE_TAG}"
          sh "docker image push ${IMAGE_NAME}:latest"               
      }      
    }

    stage('Docker Image Cleanup'){
      steps{
          sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}"
          sh "docker rmi ${IMAGE_NAME}:latest"
      }
    } 

    stage('Trigger CD Pipeline'){
      steps{
        sh "curl -v -k --user jenkins:117460c38498ed9515004d8120d2fb84c6 \
            -X POST _H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' \
            --data 'IMAGE_TAG=${IMAGE_TAG}' \
            'http://44.215.173.223:8080/job/DevSecOps-CD/buildWithParameters?Token=gitops-config'"
      }
    } 
  }

 } 


