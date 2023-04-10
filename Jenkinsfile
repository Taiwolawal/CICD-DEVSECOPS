pipeline {
  agent any

  stages {

    stage('Git Checkout'){
            steps{
            gitCheckout(
                branch: "main",
                url: "https://github.com/Taiwolawal/CICD-DEVSECOPS.git"
               )
            }
        }

    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }

    
    }
 }   
