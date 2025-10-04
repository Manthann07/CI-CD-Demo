pipeline {
  agent any
  environment {
    REPO = "your-dockerhub-user/ci-cd-demo"
    IMAGE = "\${REPO}:\${env.GIT_COMMIT.substring(0,7)}"
    EC2_HOST = "<EC2_PUBLIC_IP>"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Install & Test') { steps { sh 'npm ci && npm test' } }
    stage('Build Docker Image') { steps { sh "docker build -t \${IMAGE} ." } }
    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
          sh "docker push \${IMAGE}"
        }
      }
    }
    stage('Deploy to EC2') {
      steps {
        sshagent(['ec2-ssh-key']) {
          sh '''
          ssh -o StrictHostKeyChecking=no ubuntu@\${EC2_HOST} "
            docker pull \${IMAGE} &&
            docker stop ci_cd_demo || true &&
            docker rm ci_cd_demo || true &&
            docker run -d --restart unless-stopped --name ci_cd_demo -p 80:3000 \${IMAGE}
          "
          '''
        }
      }
    }
  }
}
