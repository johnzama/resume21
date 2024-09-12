pipeline {
    agent any

    environment {
        IMAGE_NAME = 'html-resume'
        HOST_PORT = '8081'
        CONTAINER_PORT = '80'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Cloning the repository using GitHub credentials
                git branch: 'main', url: 'https://github.com/johnzama/resume21.git', credentialsId: 'resume-github-pat'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image locally
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    // Stop and remove any existing container with the same name
                    sh "docker stop ${IMAGE_NAME} || true && docker rm ${IMAGE_NAME} || true"

                    // Run the new Docker container
                    sh "docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name ${IMAGE_NAME} ${IMAGE_NAME}:${BUILD_NUMBER}"
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

