pipeline {
  agent any

  stages {

    stage('Git Checkout'){
        steps{
            script {
                git branch: 'main', url: 'https://github.com/Taiwolawal/CICD-DEVSECOPS.git'
            }
        }
    }
    
    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archiveArtifacts 'target/*.jar'
      }
    }

    stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
    }



    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv(credentialsId: 'sonar-token') {
            sh "mvn clean verify sonar:sonar \
                -Dsonar.projectKey=DevSecOps \
                -Dsonar.projectName='DevSecOps' \
                -Dsonar.host.url=http://13.41.145.102:9000 \
                -Dsonar.token=sqp_35af92fa9aa7b2b7afbd04f97d0f0dcf45cf80d2"
        }
      }
    }
    
  }

  post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
    }
 }   
