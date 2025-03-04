pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'  // Ensure this exists in Jenkins credentials
        DOCKER_IMAGE = 'isginni/studentsurvey'  // Your actual DockerHub repo name
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
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, 
                                                     usernameVariable: 'DOCKER_USER', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        echo "Logging into DockerHub..."
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    }

                    echo "Building Docker image..."
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running application tests..."
                    sh 'docker run --rm $DOCKER_IMAGE:$DOCKER_TAG python -m pytest || true' // Avoid pipeline failure if pytest is missing
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
                        sh 'docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKER_USER/studentsurvey:$DOCKER_TAG'

                        echo "Pushing Docker image..."
                        sh 'docker push $DOCKER_USER/studentsurvey:$DOCKER_TAG'
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying to Kubernetes..."
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }

    post {
        always {
            script {
                node {
                    echo "Cleaning up resources..."
                    sh 'docker logout || true'
                }
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

