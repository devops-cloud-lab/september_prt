pipeline {
    agent { label 'ci-agent' }

    environment {
        DOCKER_IMAGE = "281644/web-app:${BUILD_NUMBER}"
        DOCKER_LATEST = "281644/web-app:latest"
        REGISTRY_CREDS = "docker-hub-credentials-id" // Configured in Jenkins Credentials
        K8S_NODE_IP = "172.31.31.221"
        SSH_CREDS_ID = "k8s-ssh-key-id"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/devops-cloud-lab/september_prt.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} -t ${DOCKER_LATEST} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDS}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USER')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                        sh "docker push ${DOCKER_LATEST}"
                        sh "docker logout"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy manifests via SSH to k8s-node
                    withCredentials([sshUserPrivateKey(credentialsId: "${SSH_CREDS_ID}", keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                        sh """
                            ssh -i \$SSH_KEY -o StrictHostKeyChecking=no \$SSH_USER@${K8S_NODE_IP} '
                            kubectl set image deployment/web-app-deployment web-app=${DOCKER_IMAGE} || kubectl apply -f deployment.yaml
                            '
                        """
                    }
                }
            }
        }
    }
}
