pipeline {
    agent any

    environment {
        IMAGE_NAME = 'html-resume'  // Name of your Docker image
        HOST_PORT = '8081'          // Host port to map the Docker container
        CONTAINER_PORT = '80'       // Internal container port
        SONARQUBE_SCANNER = 'SonarQube Scanner'  // The name of the SonarQube scanner configured in Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository containing the HTML resume and Dockerfile
                git branch: 'main', url: 'https://github.com/johnzama/resume21.git', credentialsId: 'resume-github-pat'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    withSonarQubeEnv('SonarQube') {  // Replace 'SonarQube' with the name of your SonarQube server in Jenkins
                        sh "${SONARQUBE_SCANNER} -Dsonar.projectKey=resume-project -Dsonar.sources=."
                    }
                }
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

        stage('Trivy Scan') {
            steps {
                script {
                    // Run Trivy scan on the Docker image
                    sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}:${BUILD_NUMBER}"
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

