pipeline {
    agent { label 'ci-agent' }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/devops-cloud-lab/september_prt.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t prt-web-app:latest .'
            }
        }
        stage('Verify Container') {
            steps {
                sh 'docker stop test-container || true'
                sh 'docker rm test-container || true'
                sh 'docker run -d --name test-container -p 8080:80 prt-web-app:latest'
            }
        }
    }
}
