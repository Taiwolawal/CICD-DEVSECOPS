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
 
  /*   stage('Static Code Analysis: Sonarqube') {
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
    } */

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
              sh "trivy config ."
              /* sh "bash trivy-dockerfile-image-scan.sh" */
            /* sh "trivy fs Dockerfile" */
            }
          }
        )      
      }
    }
  }
  
  post {
        always {
          junit 'target/surefire-reports/*.xml' 
          jacoco execPattern: 'target/jacoco.exec' 
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        }
    }

 } 


