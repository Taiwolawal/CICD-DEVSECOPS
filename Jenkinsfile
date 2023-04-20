pipeline {
  agent any

  environment{
    DOCKERHUB_USERNAME = "wizhubdocker8s"
    APP_NAME = "java-app-argo"
    IMAGE_TAG = "${BUILD_NUMBER}"
    IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
    /* DOCKER_CREDS = credentials('dockerhub') */
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
 
    stage('Static Code Analysis: Sonarqube') {
      steps {
        withSonarQubeEnv(credentialsId: 'jenkins-sonar') {
          sh 'mvn clean package sonar:sonar' 
        }
      }
    }

    stage('Quality Gate Check Status: Sonarqube'){
      steps{
        waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonar'
      }
    }
  }

  
 } 


