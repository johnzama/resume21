pipeline {
    agent any

    environment {
        // Docker registry credentials ID in Jenkins
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials-id'
        // Your Docker Hub username or registry URL
        DOCKER_REGISTRY = 'your-dockerhub-username'
        // The name of your Docker image
        IMAGE_NAME = 'html-resume'
        // The port you want to map on your host machine
        HOST_PORT = '8081'
        // The internal container port (Nginx default is 80)
        CONTAINER_PORT = '80'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository containing the HTML resume and Dockerfile
                git branch: 'main', url: 'https://github.com/your-username/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub or your Docker registry
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    }

                    // Push the Docker image to the registry
                    sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    // Stop and remove any existing container with the same name
                    sh "docker stop ${IMAGE_NAME} || true && docker rm ${IMAGE_NAME} || true"

                    // Run the new Docker container
                    sh "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${IMAGE_NAME} ${DOCKER_REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}

