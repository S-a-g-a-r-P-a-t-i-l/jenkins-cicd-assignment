
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Source code checked out successfully'
            }
        }

        stage('Build') {
            steps {
                echo 'Starting Maven Build'
                sh 'mvn clean compile'
            }
        }

        stage('Unit Testing') {
            steps {
                echo 'Running JUnit Test Cases'
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                echo 'Creating Application JAR'
                sh 'mvn package'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar',
                                 fingerprint: true
            }
        }
    }

    post {
        always {
            junit 'target/surefire-reports/*.xml'
        }

        success {
            echo 'Build and Testing Successful!'
        }

        failure {
            echo 'Build Failed!'
        }
    }
}
