pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "dineshpatil0908/self-healing-platform:v1"
        GIT_REPO = "https://github.com/dinshpatil5615/Self-Healing-Platform.git"
    }

    stages {

        stage('Checkout') {
            steps {
                git url: "${GIT_REPO}", branch: "main"
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(
                        credentialsId: 'dockerhub-creds',
                        url: 'https://index.docker.io/v1/'
                    ) {
                        sh """
                          docker build -t ${DOCKER_IMAGE} .
                          docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Update Manifest') {
            steps {
                sh """
                  sed -i 's|image:.*|image: ${DOCKER_IMAGE}|' k8s/deployment.yaml
                  git config user.email "jenkins@example.com"
                  git config user.name "jenkins"
                  git add k8s/deployment.yaml
                  git diff --cached --quiet || git commit -m "Update image version"
                """

                withCredentials([usernamePassword(
                    credentialsId: 'github-creds',
                    usernameVariable: 'GIT_USER',
                    passwordVariable: 'GIT_TOKEN'
                )]) {
                    sh """
                      git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/dinshpatil5615/Self-Healing-Platform.git
                      git push origin main
                    """
                }
            }
        }
    }
}
