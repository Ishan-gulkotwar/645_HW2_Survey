pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        KUBECONFIG_CREDENTIALS_ID = 'kubernetes-config'
        DOCKER_USER = 'isginni'
        DOCKER_IMAGE_NAME = 'studentsurvey'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Checking out code from GitHub..."
                    git url: 'https://github.com/Ishan-gulkotwar/645_HW2_Survey.git', branch: 'master'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, 
                                                     usernameVariable: 'DOCKER_USER_CRED', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        echo "Logging into DockerHub..."
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER_CRED --password-stdin'
                    }
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_USER}/${DOCKER_IMAGE_NAME}:latest ."
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo "Running application tests..."
                    sh 'echo "Tests temporarily skipped"'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, 
                                                     usernameVariable: 'DOCKER_USER_CRED', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        echo "Tagging Docker image..."
                        sh "docker tag ${DOCKER_USER}/${DOCKER_IMAGE_NAME}:latest ${DOCKER_USER}/${DOCKER_IMAGE_NAME}:latest"
                        echo "Pushing Docker image..."
                        sh "docker push ${DOCKER_USER}/${DOCKER_IMAGE_NAME}:latest"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
                        echo "Deploying to Kubernetes..."
                        sh 'kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml'
                        sh 'kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml'
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
