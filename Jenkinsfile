pipeline {
    agent any

    environment {
        IMAGE_NAME = 'html-resume'
        HOST_PORT = '8081'
        CONTAINER_PORT = '80'
        SONARQUBE_SCANNER = 'SonarQube Scanner'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/johnzama/resume21.git', credentialsId: 'resume-github-pat'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh "${SONARQUBE_SCANNER} -Dsonar.projectKey=resume-project -Dsonar.sources=."
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
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
                    sh "docker stop ${IMAGE_NAME} || true && docker rm ${IMAGE_NAME} || true"
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

