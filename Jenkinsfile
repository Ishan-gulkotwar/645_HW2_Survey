pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_IMAGE_NAME = 'studentsurvey'
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Checking out code from GitHub..."
                    // Changed from 'main' to 'master'
                    git url: 'https://github.com/Ishan-gulkotwar/645_HW2_Survey.git', branch: 'master'
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
                        // Also tag with build number for versioning
                        sh "docker tag $DOCKER_USER/$DOCKER_IMAGE_NAME:latest $DOCKER_USER/$DOCKER_IMAGE_NAME:build-$BUILD_NUMBER"
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
                        // Also push the versioned tag
                        sh "docker push $DOCKER_USER/$DOCKER_IMAGE_NAME:build-$BUILD_NUMBER"
                    }
                }
            }
        }
        
        stage('Install kubectl') {
            steps {
                sh '''
                if ! [ -x "$(command -v kubectl)" ]; then
                  echo "kubectl not found, installing..."
                  curl -LO "https://dl.k8s.io/release/stable.txt"
                  curl -LO "https://dl.k8s.io/release/$(cat stable.txt)/bin/linux/amd64/kubectl"
                  chmod +x kubectl
                  sudo mv kubectl /usr/local/bin/ || mkdir -p $HOME/bin && mv kubectl $HOME/bin/ && export PATH=$PATH:$HOME/bin
                  kubectl version --client
                else
                  echo "kubectl already installed"
                  kubectl version --client
                fi
                '''
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                        echo "Deploying to Kubernetes..."
                        // Apply the deployment configuration
                        sh "kubectl --kubeconfig=$KUBECONFIG apply -f deployment.yaml"
                        // Update the image to use the latest build
                        sh "kubectl --kubeconfig=$KUBECONFIG set image deployment/studentsurvey-deployment studentsurvey=$DOCKER_USER/$DOCKER_IMAGE_NAME:build-$BUILD_NUMBER"
                        // Apply any service configuration if needed
                        sh "[ -f service.yaml ] && kubectl --kubeconfig=$KUBECONFIG apply -f service.yaml || echo 'No service.yaml found, skipping'"
                        // Check deployment status
                        sh "kubectl --kubeconfig=$KUBECONFIG rollout status deployment/studentsurvey-deployment"
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
                // Clean up local docker images to save space
                sh 'docker system prune -f || true'
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
