pipeline {
  agent any

  environment{
    DOCKERHUB_USERNAME = "wizhubdocker8s"
    APP_NAME = "java-app-argo"
    IMAGE_TAG = "${BUILD_NUMBER}"
    IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${APP_NAME}"
    DOCKER_CREDS = "dockerhub"
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
 
/*     stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv(installationName: 'sonar',credentialsId: 'sonar-token') {
            sh "mvn clean verify sonar:sonar \
                -Dsonar.projectKey=DevSecOps \
                -Dsonar.projectName='DevSecOps' \
                -Dsonar.host.url=http://13.41.145.102:9000 \
                -Dsonar.token=sqp_35af92fa9aa7b2b7afbd04f97d0f0dcf45cf80d2"
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
  }

  post {
        always {
          /* junit 'target/surefire-reports/*.xml' */
          jacoco execPattern: 'target/jacoco.exec'
        }
    }
 } 


