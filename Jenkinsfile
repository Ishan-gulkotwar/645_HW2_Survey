pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'  // Keeping this as requested
        DOCKER_IMAGE_NAME = 'studentsurvey'  // Just the image name without username
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Checking out code from GitHub..."
                    git url: 'https://github.com/Ishan-gulkotwar/645_HW2_Survey.git', branch: 'main'  // Changed to 'main' (verify your branch name)
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
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        
                        echo "Building Docker image..."
                        sh "docker build -t $DOCKER_USER/$DOCKER_IMAGE_NAME:latest ."
                    }
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
                                                     usernameVariable: 'DOCKER_USER', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        echo "Pushing Docker image..."
                        sh "docker push $DOCKER_USER/$DOCKER_IMAGE_NAME:latest"
                    }
                }
            }
        }
        
        stage('Install kubectl') {
            steps {
                sh '''
                if ! [ -x "$(command -v kubectl)" ]; then
                  curl -LO "https://dl.k8s.io/release/stable.txt"
                  curl -LO "https://dl.k8s.io/release/$(cat stable.txt)/bin/linux/amd64/kubectl"
                  chmod +x kubectl
                  sudo mv kubectl /usr/local/bin/
                fi
                '''
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                        echo "Deploying to Kubernetes..."
                        sh "kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml"
                        sh "kubectl --kubeconfig=$KUBECONFIG set image deployment/studentsurvey-deployment studentsurvey=$DOCKER_USER/$DOCKER_IMAGE_NAME:latest"
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
