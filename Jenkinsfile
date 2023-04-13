pipeline {
  agent any

  environment{
    DOCKERHUB_USERNAME = "wizhubdocker8s"
    APP_NAME = "java-app-argo"
    IMAGE_TAG = "${BUILD_NUMBER}"
    IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
    DOCKER_CREDS = "dockerhub"
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

    stage('Docker Image Build'){
      steps{
        script{
          docker_image = docker.build "${IMAGE_NAME}"
        }
      } 
    }

   stage('Docker Image Scan: trivy '){
      steps{
        script{
          trivy image ${DOCKERHUB_USERNAME}/${APP_NAME}:latest > scan.txt
          cat scan.txt    
        }
      }
    }

   stage('Docker Image Push : DockerHub '){
      steps{
        script{
          withCredentials([usernamePassword(credentialsId: 'dockerhub', 
          passwordVariable: 'PASSWORD', 
          usernameVariable: 'USER')]) {
          docker login -u '$USER' -p '$PASSWORD'
          docker image push ${DOCKERHUB_USERNAME}/${APP_NAME}:${IMAGE_TAG}
          docker image push ${DOCKERHUB_USERNAME}/${APP_NAME}:latest
          }           
        }
      }      
    } 

    stage('Docker Image Cleanup'){
      steps{
        script{
          docker rmi ${DOCKERHUB_USERNAME}/${APP_NAME}:${IMAGE_TAG}
          docker rmi ${DOCKERHUB_USERNAME}/${APP_NAME}:latest
        }
      }
    }
        
  }

  post {
        always {
          /* junit 'target/surefire-reports/*.xml' */
          jacoco execPattern: 'target/jacoco.exec'
        }
    }
 } 


