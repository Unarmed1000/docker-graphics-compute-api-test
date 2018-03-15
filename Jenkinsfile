#!/usr/bin/env groovy
node
{
    // some basic config
    def DOCKERHUB_USERNAME = 'NotDefined'

    def IMAGE_TAG         = (env.BRANCH_NAME == 'u17_10_mesa'  ? 'u17_10_mesa' : 'u17_10-dev_mesa')

    def DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE = env.DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE    

    def IMAGE_ARGS        = '--pull .'
    
    // Workaround a current issue with docker.withRegistry
    // https://issues.jenkins-ci.org/browse/JENKINS-38018 
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker-hub-cred-s',
                    usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) 
    {
      sh 'docker login -u "$USERNAME" -p "$PASSWORD"'
      DOCKERHUB_USERNAME = USERNAME
    }      

    def IMAGE_NAME        = "$DOCKERHUB_USERNAME/graphics-compute-api-test"

    def app
    
    stage('Checkout SCM') 
    {
        // Let's make sure we have the repository cloned to our workspace
        checkout scm
    }

    stage('Build image') 
    {
        // We copy since symlinking wont work
        sh 'rsync -avv ${DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE}/ cache'
   
        // This builds the actual image; synonymous to docker build on the command line
        app = docker.build("${IMAGE_NAME}:${IMAGE_TAG}", "${IMAGE_ARGS}")
    }

    stage('Push image') 
    {
        app.push("${IMAGE_TAG}")
    }
}
