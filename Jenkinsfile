
pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'DEPLOY_TO_EC2',
            defaultValue: false,
            description: 'Enable this only when EC2 is ready'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Source code checked out successfully'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Testing') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar',
                                 fingerprint: true
            }
        }

        stage('Deploy to EC2') {
            when {
                expression { params.DEPLOY_TO_EC2 == true }
            }
            steps {
                echo 'EC2 deployment will execute when configured'
                sh 'bash deploy/deploy.sh'
            }
        }
    }

    post {
        always {
            junit 'target/surefire-reports/*.xml'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
