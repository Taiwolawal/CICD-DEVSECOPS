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

    stage('Vulnerability Scan - Dockerfile and Maven'){
      steps{
        parallel(
          "Dependency Scan":{
            sh "mvn dependency-check:check"
          }, 
          "Dockerfile Scan: Trivy":{
            script {
            trivy file:"Dockerfile",format:"json",output:"scan.json"
            def scanResults = readJSON file: "scan.json"
            echo "${scanResults.Vulnerabilities.length()} vulnerabilities found"
            }
          }
        )
        
      }
    }

    stage('Docker Image Build'){
      steps{
          sh "docker build -t ${DOCKERHUB_USERNAME}/${APP_NAME} ."  
          sh "docker image tag ${DOCKERHUB_USERNAME}/${APP_NAME} ${DOCKERHUB_USERNAME}/${APP_NAME}:${IMAGE_TAG}"
          sh "docker image tag ${DOCKERHUB_USERNAME}/${APP_NAME} ${DOCKERHUB_USERNAME}/${APP_NAME}:latest"
      } 
    }

   stage('Docker Image Scan: trivy'){
      steps{
          sh "trivy image ${DOCKERHUB_USERNAME}/${APP_NAME}:latest > scan.txt"
          sh "cat scan.txt"  
      }
    }

   stage('Docker Image Push : DockerHub'){
      steps{
          sh 'docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW'
          sh "docker image push ${DOCKERHUB_USERNAME}/${APP_NAME}:${IMAGE_TAG}"
          sh "docker image push ${DOCKERHUB_USERNAME}/${APP_NAME}:latest"               
      }      
    } 

    stage('Docker Image Cleanup'){
      steps{
          sh "docker rmi ${DOCKERHUB_USERNAME}/${APP_NAME}:${IMAGE_TAG}"
          sh "docker rmi ${DOCKERHUB_USERNAME}/${APP_NAME}:latest"
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


