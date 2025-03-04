pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = credentials('docker_credentials')
        DOCKER_IMAGE = 'isginni/studentsurvey'
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout Code') {
        steps {
            script {
                echo "Checking out code from GitHub..."
                git branch: 'master', url: 'https://github.com/Ishan-gulkotwar/645_HW2_Survey.git'
            }
        }
    }

        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker_credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    }
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Pipeline Failed!"
        }
    }
}

