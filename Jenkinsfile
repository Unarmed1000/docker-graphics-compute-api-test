node 
{
    // some basic config
    def DOCKERHUB_USERNAME = 'NotDefined'

    def PUSH_BUILD_NUMBER = (env.BRANCH_NAME == 'master')
    def DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE = env.DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE    

    stage('Build image') 
    {
        parallel ubuntu14_04_trusty: 
        {
            node 
            {
                def IMAGE_TAG         = (env.BRANCH_NAME == 'master'  ? 'trusty' : 'dev-trusty')
                def IMAGE_TAG_SHORT   = IMAGE_TAG.substring(0,1)
                def IMAGE_TAG_REV     = "${IMAGE_TAG_SHORT}${env.BUILD_NUMBER}"
            
                def IMAGE_ARGS        = '-f Dockerfile-ubuntu14_04-trusty .'
                
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
                
                stage("Build image") 
                {
                    // We copy since symlinking wont work
                    sh 'cp -r "$DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE" cache'
               
                    // This builds the actual image; synonymous to docker build on the command line
                    app = docker.build("${IMAGE_NAME}:${IMAGE_TAG_REV}", "${IMAGE_ARGS}")
                }

                stage('Push image') 
                {
                    if (PUSH_BUILD_NUMBER)
                    {
                        app.push("${IMAGE_TAG_REV}")
                    }
                    app.push("${IMAGE_TAG}")
                }
            }
        },
        ubuntu16_04_xenial: 
        {
            node 
            {
                def IMAGE_TAG         = (env.BRANCH_NAME == 'master'  ? 'xenial' : 'dev-xenial')
                def IMAGE_TAG_SHORT   = IMAGE_TAG.substring(0,1)
                def IMAGE_TAG_REV     = "${IMAGE_TAG_SHORT}${env.BUILD_NUMBER}"
            
                def IMAGE_ARGS        = '-f Dockerfile-ubuntu16_04-xenial .'
                
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
                    sh 'cp -r "$DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE" cache'
               
                    // This builds the actual image; synonymous to docker build on the command line
                    app = docker.build("${IMAGE_NAME}:${IMAGE_TAG_REV}", "${IMAGE_ARGS}")
                }

                stage('Push image') 
                {
                    if (PUSH_BUILD_NUMBER)
                    {
                        app.push("${IMAGE_TAG_REV}")
                    }
                    app.push("${IMAGE_TAG}")
                }
            }
        },
        ubuntu17_10_artful: 
        {
            node 
            {
                def IMAGE_TAG         = (env.BRANCH_NAME == 'master'  ? 'artful' : 'dev-artful')
                def IMAGE_TAG_SHORT   = IMAGE_TAG.substring(0,1)
                def IMAGE_TAG_REV     = "${IMAGE_TAG_SHORT}${env.BUILD_NUMBER}"
            
                def IMAGE_ARGS        = '-f Dockerfile-ubuntu17_10-artful .'
                
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
                    sh 'cp -r "$DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE" cache'
               
                    // This builds the actual image; synonymous to docker build on the command line
                    app = docker.build("${IMAGE_NAME}:${IMAGE_TAG_REV}", "${IMAGE_ARGS}")
                }

                stage('Push image') 
                {
                    if (PUSH_BUILD_NUMBER)
                    {
                        app.push("${IMAGE_TAG_REV}")
                    }
                    app.push("${IMAGE_TAG}")
                }
            }
        },
        ubuntu16_04_xenial_mesa: 
        {
            node 
            {
                def IMAGE_TAG         = (env.BRANCH_NAME == 'master'  ? 'xenial-mesa' : 'dev-xenial-mesa')
                def IMAGE_TAG_SHORT   = IMAGE_TAG.substring(0,1)
                def IMAGE_TAG_REV     = "${IMAGE_TAG_SHORT}${env.BUILD_NUMBER}"
            
                def IMAGE_ARGS        = '-f Dockerfile-ubuntu16_04-xenial_mesa .'
                
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
                    sh 'cp -r "$DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE" cache'
               
                    // This builds the actual image; synonymous to docker build on the command line
                    app = docker.build("${IMAGE_NAME}:${IMAGE_TAG_REV}", "${IMAGE_ARGS}")
                }

                stage('Push image') 
                {
                    if (PUSH_BUILD_NUMBER)
                    {
                        app.push("${IMAGE_TAG_REV}")
                    }
                    app.push("${IMAGE_TAG}")
                }
            }
        },
        ubuntu17_10_artful_mesa: 
        {
            node 
            {
                def IMAGE_TAG         = (env.BRANCH_NAME == 'master'  ? 'artful-mesa' : 'dev-artful-mesa')
                def IMAGE_TAG_SHORT   = IMAGE_TAG.substring(0,1)
                def IMAGE_TAG_REV     = "${IMAGE_TAG_SHORT}${env.BUILD_NUMBER}"
            
                def IMAGE_ARGS        = '-f Dockerfile-ubuntu17_10-artful_mesa .'
                
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
                    sh 'cp -r "$DOCKERAPITESTUBUNTU_PATH_READONLY_CACHE" cache'
               
                    // This builds the actual image; synonymous to docker build on the command line
                    app = docker.build("${IMAGE_NAME}:${IMAGE_TAG_REV}", "${IMAGE_ARGS}")
                }

                stage('Push image') 
                {
                    if (PUSH_BUILD_NUMBER)
                    {
                        app.push("${IMAGE_TAG_REV}")
                    }
                    app.push("${IMAGE_TAG}")
                }
            }
        }
    }
}
