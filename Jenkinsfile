
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

stage('SSH Credentials Test') {
    steps {
        withCredentials([
            sshUserPrivateKey(
                credentialsId: 'ec2-ssh-key',
                keyFileVariable: 'SSH_KEY',
                usernameVariable: 'EC2_USER'
            )
        ]) {
            sh '''
                test -s "$SSH_KEY"
                echo "SSH private key loaded successfully!"
                echo "SSH username: $EC2_USER"
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
                export EC2_HOST="YOUR_EC2_PUBLIC_IP"
                bash deploy/deploy.sh
            '''
        }
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
