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

    stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
    }

    stage('Mutation Test - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
    }

   post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
    }
}


}