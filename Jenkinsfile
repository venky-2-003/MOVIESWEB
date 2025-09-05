pipeline {
    agent any

    environment {
        IMAGE_NAME = "moviesweb"
        DOCKERHUB_CREDENTIALS = "dockerhub-creds" // Jenkins stored credentials ID
        DOCKERHUB_REPO = "yourdockerhubusername/moviesweb" 
        SWARM_SERVICE = "moviesweb_service"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yourusername/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
            }
        }

        stage('Tag and Push Image') {
            steps {
                script {
                    sh "docker tag ${IMAGE_NAME} ${DOCKERHUB_REPO}:latest"
                    sh "docker push ${DOCKERHUB_REPO}:latest"
                }
            }
        }

        stage('Deploy to Docker Swarm') {
            steps {
                script {
                    // Check if service exists
                    def exists = sh(script: "docker service ls --filter name=${SWARM_SERVICE} -q", returnStdout: true).trim()
                    if (exists) {
                        echo "Updating existing Swarm service..."
                        sh "docker service update --image ${DOCKERHUB_REPO}:latest ${SWARM_SERVICE}"
                    } else {
                        echo "Creating new Swarm service..."
                        sh "docker service create --name ${SWARM_SERVICE} -p 8088:80 ${DOCKERHUB_REPO}:latest"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "MOVIESWEB deployed successfully via Docker Swarm!"
        }
        failure {
            echo "Deployment failed. Check logs."
        }
    }
}
