pipeline {
  agent any

  environment{
    DOCKERHUB_USERNAME = "wizhubdocker8s"
    APP_NAME = "java-app-argo"
    IMAGE_TAG = "${BUILD_NUMBER}"
    IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
    DOCKER_CREDS = credentials('dockerhub')
    SONAR_CREDS = "jenkins-sonar"
  }

  stages {

    stage('Git Checkout'){
        steps{
            script {
                git branch: 'main', url: 'https://github.com/Taiwolawal/CICD-DEVSECOPS.git'
            }
        }
    }

    stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
    }

    stage('Integration Test Maven'){
        steps{
         sh 'mvn verify -DskipUnitTests'
        }
        
    }
 
  /*   stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv(installationName: 'sonar',credentialsId: 'sonar-token') {
            sh "mvn clean verify sonar:sonar \
                -Dsonar.projectKey=devsecops-numeric-application \
                -Dsonar.projectName='devsecops-numeric-application' \
                -Dsonar.host.url=http://13.41.145.102:9000"
        }
        timeout(time: 2, unit: 'MINUTES') {
          script {
          waitForQualityGate abortPipeline: true
           }
         }
      }
    } */

    stage('Build Artifact - Maven') {
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
              sh "trivy config ."
              sh "bash trivy-dockerfile-image-scan.sh"
            /* sh "trivy fs Dockerfile" */
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
          sh "bash trivy-image-scan.sh"
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

    stage('Update CD Pipeline With Image'){
      steps{

      }
    }

    stage('Update Deployment.yaml file'){
      steps{
        script{

          sh """
            cat deployment.yaml
            sed -i 's/${APP_NAME}.*/${APP_NAME}:${IMAGE_TAG}/g' deployment.yaml
            cat deployment.yaml
          """
        }        
      }
    }

    stage('Vulnerability Scan - Kubernetes'){
      steps{
        parallel(
          "Kubernetes Cluster Scan":{
            sh "trivy k8s --report summary cluster"
            sh "trivy k8s -n kube-system --report summary all"
          },
          "Scan YAML Files":{
            sh "kubesec scan deployment.yaml"
            sh "bash trivy-image-scan.sh"
          }
        )
      }
    }

    stage('Update Changed Deployment to Git'){
      steps{
        script{
          sh """
            git config --global user.name "Taiwolawal"
            git config --global user.email "taiwolawal360@gmail.com
            git add deployment.yaml
            git commit -m "updated deployment file"

         """
        }  
      }
    }

  }

  post {
        always {
          /* junit 'target/surefire-reports/*.xml' */
          jacoco execPattern: 'target/jacoco.exec'
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        }
    }
 } 


