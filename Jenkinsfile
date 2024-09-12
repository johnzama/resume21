pipeline {
    agent any

    environment {
        IMAGE_NAME = 'html-resume'
        HOST_PORT = '8081'
        CONTAINER_PORT = '80'
        SONARQUBE_SCANNER = 'SonarQube Scanner' // The name of the SonarQube installation in Jenkins
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
                    withSonarQubeEnv('SonarQube') { // 'SonarQube' is the name configured in Jenkins
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

        // Other stages...
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

