@Library('my_shared_lib') _

pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'amirsha99/todo-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
        K8S_NAMESPACE = 'default'
        GITOPS_REPO = 'https://github.com/amirsha619/argo-todo-app.git'
    }
    stages {
        stage('Hello')
        {
            steps{
                script{
                    hello()
                }
            }

        }
        stage('Clone Repository') 
        {
            steps
            {
                script{
                    echo '####### clonning the repo'
                    clone("https://github.com/amirsha619/my_ci_cd_ee.git","main","githubacc_ad")
                    echo '################## Done clonnig the repo'
                }
                //git branch: 'main', 
                //credentialsId: 'githubacc_ad',  // Ensure this credential ID exists in Jenkins
                //url: 'https://github.com/amirsha619/my_ci_cd_ee.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script{
                    echo '##### calling docker build step'
                    docker_build(DOCKER_IMAGE,IMAGE_TAG)
                    echo '##### Completed docker build step'
                }
                //sh 'docker build -t $DOCKER_IMAGE:$IMAGE_TAG .'
            }
        }
        
        stage('Push Docker Image') {
            steps {

                script{
                    dockerpush('dockerhub_ad',DOCKER_IMAGE,IMAGE_TAG)
                }
                //withDockerRegistry([credentialsId: 'dockerhub_ad', url: '']) {
                    //sh 'docker push $DOCKER_IMAGE:$IMAGE_TAG'
                //}
            }
        }

        // Till here i have used  shared libraries to store and group the code for above stpes, 
        // PLease refer the jenkins_shared_libs repo..        


        stage('Update K8s Manifests in GitOps Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'githubacc_ad', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh '''
                        rm -rf argo-todo-app
                        git clone --branch main https://$GIT_USER:$GIT_PASS@github.com/amirsha619/argo-todo-app.git argo-todo-app
                        cd argo-todo-app
                        sed -i "s|image:.*|image: $DOCKER_IMAGE:$IMAGE_TAG|" deploy.yaml
                        git config user.email "amirs035@gmail.com"
                        git config user.name "amirsha619"
                        git add deploy.yaml
                        git commit -m "Updated image to $IMAGE_TAG"
                        git push https://$GIT_USER:$GIT_PASS@github.com/amirsha619/argo-todo-app.git main
                        '''
                    }
                }
            }
        }        

        
        stage('Trigger ArgoCD Sync') 
        {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'argocd_admin_password', usernameVariable: 'ARGOCD_USER', passwordVariable: 'ARGOCD_PASS')]) {
                        withEnv(["ARGOCD_SERVER=localhost:9090"]) 
                        {
                            sh '''
                            argocd login $ARGOCD_SERVER --username $ARGOCD_USER --password $ARGOCD_PASS --insecure
                            argocd app sync todo-app
                            '''
                        }
                    }
                }
            }
        }


    } //end
}
