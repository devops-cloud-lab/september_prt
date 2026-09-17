pipeline {
    agent { label 'ci-agent' }

    environment {
        DOCKER_IMAGE = "281644/web-app:${BUILD_NUMBER}"
        DOCKER_LATEST = "281644/web-app:latest"
        REGISTRY_CREDS = "docker-hub-credentials-id" // Configured in Jenkins Credentials
        K8S_NODE_IP = "172.31.31.221"
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
                    docker.withRegistry('https://index.docker.io/v1/', "${REGISTRY_CREDS}") {
                        sh "docker push ${DOCKER_IMAGE}"
                        sh "docker push ${DOCKER_LATEST}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy manifests via SSH to k8s-node
                    sshagent(credentials: ['k8s-ssh-key-id']) {
                        sh """
                            scp -o StrictHostKeyChecking=no deployment.yaml service.yaml ubuntu@${K8S_NODE_IP}:/tmp/
                            ssh -o StrictHostKeyChecking=no ubuntu@${K8S_NODE_IP} 'kubectl apply -f /tmp/deployment.yaml && kubectl apply -f /tmp/service.yaml'
                        """
                    }
                }
            }
        }
    }
}
