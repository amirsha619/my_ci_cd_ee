pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'amirsha99/todo-app'
        K8S_NAMESPACE = 'default'
        GITOPS_REPO = 'https://github.com/amirsha619/argo-todo-app.git'
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

        stage('Update K8s Manifests in GitOps Repo') 
        {
            steps 
            {
                script 
                {
                    withCredentials([usernamePassword(credentialsId: 'githubacc_ad', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) 
                    {
                        sh '''
                        rm -rf argo-todo-app
                        git clone --branch main https://github.com/amirsha619/argo-todo-app.git argo-todo-app
                        cd argo-todo-app
                        sed -i 's|image:.*|image: '"$DOCKER_IMAGE"':latest|' deploy.yaml
                        git config user.email "amirs035@gmail.com"
                        git config user.name "amirsha619"
                        git add deploy.yaml
                        git commit -m "Updated image to latest version"
                        git push origin main
                        '''
                    }
                }
            }
        }

        stage('Trigger ArgoCD Sync') 
        {
            steps {
                sh 'argocd app sync todo-app'
            }
        }

    } //end
}
