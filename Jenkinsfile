pipeline {
    agent any

    environment {
        // Define image and container names for Docker
        IMAGE_NAME = 'react-vite-app'
        CONTAINER_NAME = 'react-vite-app-container'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out source code from SCM..."
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Build Production Docker Image') {
            steps {
                echo "Building PRODUCTION Docker image ${env.IMAGE_NAME} using Dockerfile.production..."
                // The 'docker' tool must be configured in your Jenkins Global Tool Configuration
                sh "docker build -f Dockerfile.production -t ${env.IMAGE_NAME} ."
            }
        }

        stage('Deploy Docker Container') {
            steps {
                echo "Deploying container ${env.CONTAINER_NAME} with production image..."

                // Stop and remove any existing container with the same name to prevent conflicts
                sh "docker stop ${env.CONTAINER_NAME} || true"
                sh "docker rm ${env.CONTAINER_NAME} || true"

                // Run the new container in detached mode
                sh """
                    docker run -d \\
                        --name "${env.CONTAINER_NAME}" \\
                        -p 7787:80 \\
                        -e NODE_ENV=production \\
                        --restart unless-stopped \\
                        "${env.IMAGE_NAME}"
                """
                echo "Container ${env.CONTAINER_NAME} started with production image, mapped to host port 7787."
            }
        }

        stage('Verify Deployment') {
            steps {
                // Wait a few seconds for the container to initialize completely
                sleep 15
                echo "Verifying container status..."
                sh "docker ps -f name=${env.CONTAINER_NAME}"
                echo "Verifying application health by curling the Nginx endpoint..."
                // The curl command will fail the pipeline if the server doesn't return a 2xx/3xx status
                sh "curl -f http://localhost:7787/ || exit 1"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed. Check the logs for details.'
        }
    }
}
