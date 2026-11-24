pipeline {
    agent any

    environment {
        IMAGE_NAME = "devsecops-telemetry-api"
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
        // Optional: Set your Discord/Slack webhook URL in Jenkins Credentials or leave empty for safe simulation
        CHATOPS_WEBHOOK = ""
    }

    stages {
        stage('1. Source Checkout') {
            steps {
                checkout scm
                echo "Source code checked out successfully for Build #${env.BUILD_NUMBER}"
            }
        }

        stage('2. Automated Unit & Sanity Tests') {
            steps {
                echo "Executing isolated unit tests inside lightweight Node container..."
                sh '''
                    docker run --rm -v "$PWD/app":/app -w /app node:20-alpine sh -c "npm install --silent && npm test"
                '''
            }
        }

        stage('3. Multi-Stage Docker Build') {
            steps {
                echo "Building optimized multi-stage production image..."
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('4. DevSecOps Security Scan (Trivy)') {
            steps {
                echo "Scanning container image for HIGH and CRITICAL CVEs..."
                sh '''
                    docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        aquasec/trivy:latest image \
                        --severity HIGH,CRITICAL \
                        --exit-code 1 \
                        --no-progress \
                        ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        always {
            echo "Cleaning up local dangling images to preserve disk capacity..."
            sh "docker image prune -f || true"
        }
        success {
            echo "Pipeline succeeded! Image ${IMAGE_NAME}:${IMAGE_TAG} passed all tests and security gates."
            script {
                if (env.CHATOPS_WEBHOOK?.trim()) {
                    sh """
                        curl -s -X POST -H "Content-Type: application/json" \
                        -d '{"content": "✅ **[CI/CD SUCCESS]** Build #${env.BUILD_NUMBER} passed Trivy security gates!"}' \
                        ${env.CHATOPS_WEBHOOK}
                    """
                }
            }
        }
        failure {
            echo "Pipeline FAILED! Check console logs for test or security vulnerability details."
            script {
                if (env.CHATOPS_WEBHOOK?.trim()) {
                    sh """
                        curl -s -X POST -H "Content-Type: application/json" \
                        -d '{"content": "🚨 **[CI/CD FAILED]** Build #${env.BUILD_NUMBER} was blocked by quality or Trivy security gates!"}' \
                        ${env.CHATOPS_WEBHOOK}
                    """
                }
            }
        }
    }
}
