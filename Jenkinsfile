
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

        stage('SSH Connection Test') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'EC2_USER'
                    )
                ]) {
                    sh '''
                        echo "Connecting to EC2..."

                        ssh -i "$SSH_KEY" \
                            -o StrictHostKeyChecking=accept-new \
                            -o ConnectTimeout=15 \
                            "$EC2_USER@3.108.215.228" \
                            "echo 'Jenkins connected to EC2 successfully!' && java -version"
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                expression { params.DEPLOY_TO_EC2 == true }
            }
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'ec2-ssh-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'EC2_USER'
                    )
                ]) {
                    sh '''
                        chmod +x deploy/deploy.sh
                        export EC2_HOST="3.108.215.228"
                        bash deploy/deploy.sh
                    '''
                }
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true,
                  testResults: 'target/surefire-reports/*.xml'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
