pipeline {
    options {
        timestamps()
    }
    parameters {
        string(name: 'BUILD_VERSION', defaultValue: '', description: 'The build version to deploy (optional)')
        choice(name: 'DEPLOY_TO', choices: 'CI', description: 'The deployment stage to trigger')
    }
    agent {
        label 'aws && build && linux && ubuntu'
    }
    triggers {
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Clean') {
            agent {
                label 'aws && build && linux'
            }
            steps {
                cleanWs()
            }
        }
        stage('Build Version') {
            when {
                expression {
                    return !params.BUILD_VERSION
                }
            }
            steps{
                script {
                    def packageJSON = readJSON file: 'package.json'
                    def packageJSONVersion = packageJSON.version

                    currentBuild.displayName = packageJSONVersion
                    env.BUILD_VERSION = packageJSONVersion
                }
            }
        }
        stage('Build - Linux') {
            when {
                expression {
                    return params.DEPLOY_TO == 'CI' && params.BUILD_VERSION == ''
                }
            }
            steps {
                sshagent (credentials: ['917d2cc8-84fe-4faf-89e5-25ea6649be83']) {
                    nodejs(configId: 'kw-npmrc', nodeJSInstallationName: 'Default Node.js') {
                        // Checkout source code
                        checkout scm

                        // Generate local service build distribution
                        sh """
                        git config --global url."git@github.com:".insteadOf "https://github.com/"
                        npm i --quiet --cache=${WORKSPACE}/npm-cache
                        NODE_OPTIONS=--max_old_space_size=4096 npm run build -- \
                        --destination=$WORKSPACE/$BUILD_VERSION \
                        --buildVersion=$BUILD_VERSION \
                        --npmCache=$WORKSPACE/npm-cache
                        """

                        script {
                            // See: https://jenkins.io/doc/book/pipeline/docker/#building-containers
                            docker.withRegistry(
                                "https://registry-1.docker.io/v2/",
                                "f16c74f9-0a60-4882-b6fd-bec3b0136b84"
                            ) {
                                // Build and push the images to the registry
                                def image = docker.build(
                                    "labshare/hedwig-storage-services:${env.BUILD_VERSION}",
                                    "--no-cache --build-arg SOURCE_FOLDER=./${env.BUILD_VERSION} ."
                                )
                                image.push("${env.BUILD_VERSION}")
                            }
                        }
                    }
                }
            }
        }
    }
}     
