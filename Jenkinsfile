pipeline {
    agent any
    
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'  // Ensure this exists in Jenkins credentials
        DOCKER_IMAGE = 'isginni/studentsurvey'
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
                                                     usernameVariable: 'DOCKER_USER', 
                                                     passwordVariable: 'DOCKER_PASS')]) {
                        echo "Logging into DockerHub..."
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }

                    echo "Building Docker image..."
                    sh "docker build -t $DOCKER_IMAGE:latest ."
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo "Running application tests..."
                    sh 'echo "Tests temporarily skipped"'
                    // Once pytest is added to Docker image: sh "docker run --rm $DOCKER_IMAGE:latest python3 -m pytest"
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
                        sh "docker tag $DOCKER_IMAGE:latest $DOCKER_USER/$DOCKER_IMAGE:latest"

                        echo "Pushing Docker image..."
                        sh "docker push $DOCKER_USER/$DOCKER_IMAGE:latest"
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
                    echo "Deploying to Kubernetes..."
                    sh 'kubectl apply -f deployment.yaml'
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

