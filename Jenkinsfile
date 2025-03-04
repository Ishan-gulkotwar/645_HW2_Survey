pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker_credentials'  // Ensure this exists in Jenkins credentials
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Checking out code from GitHub..."
                    checkout scm
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, 
                                                     usernameVariable: 'DOCKER_USER', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        echo "Logging into Docker..."
                        sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
                    }
                    
                    echo "Building Docker image..."
                    sh 'docker build -t my-app:latest .'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running application tests..."
                    sh 'docker run --rm my-app:latest pytest'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, 
                                                     usernameVariable: 'DOCKER_USER', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        echo "Tagging Docker image..."
                        sh 'docker tag my-app:latest $DOCKER_USER/my-app:latest'

                        echo "Pushing Docker image..."
                        sh 'docker push $DOCKER_USER/my-app:latest'
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Cleaning up resources..."
                sh 'docker logout || true'
            }
        }
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}
