pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'amirsha619/todo-app'
        K8S_NAMESPACE = 'default'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                    credentialsId: 'githubacc_ad',  // Ensure this credential ID exists in Jenkins
                    url: 'https://github.com/amirsha619/my_ci_cd_ee.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }

        
        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub_ad', url: '']) {
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }
        

        /*
        stage('Update K8s Manifests') 
        {
            steps {
                sh "sed -i 's|image:.*|image: $DOCKER_IMAGE:latest|' deploy.yaml"
                sh "git add deploy.yaml"
                sh "git commit -m 'Update image to latest version'"
                sh "git push origin main"
            }
        }
        */
    }
}
