pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDS = credentials('docker_credentials')
        DOCKER_IMAGE = 'isginni/studentsurvey'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Ishan-gulkotwar/645_HW2_Survey.git', branch: 'master'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                sh 'echo $DOCKER_HUB_CREDS_PSW | docker login -u $DOCKER_HUB_CREDS_USR --password-stdin'
                sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl set image deployment/studentsurvey-deployment studentsurvey=${DOCKER_IMAGE}:${DOCKER_TAG}'
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
        }
    }
}