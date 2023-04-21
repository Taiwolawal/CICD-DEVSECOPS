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

   /*  stage('Unit Tests: JUnit') {
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
              sh "trivy config ."
              sh "bash trivy-dockerfile-image-scan.sh"
              sh "trivy fs Dockerfile"
            }
          }
        )      
      }
    }  */

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

    stage('Push Changed Deployment File to Git'){
      steps{
        script{
          sh """
            git config --global user.name "Taiwolawal"
            git config --global user.email "taiwolawal360@gmail.com"
            git add deployment.yaml
            git commit -m "updated deployment file"
          """
          withCredentials([gitUsernamePassword(credentialsId: 'Github', gitToolName: 'Default')]) {
            sh "git push https://github.com/Taiwolawal/CICD-DEVSECOPS.git main"
          }
          
        }
      }
    } 

  }

  /* 
  post {
        always {
          junit 'target/surefire-reports/*.xml' 
          jacoco execPattern: 'target/jacoco.exec' 
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
          publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP HTML Report', reportTitles: 'OWASP ZAP HTML Report'])
        }
    } */

 } 


