IMAGE_NAME = 'my-public-ip'
IMAGE_TAG = '1.0.0'
REGISTRY_URL = 'yuvalbenjamin'
MAIN_BRANCH = 'fix/bump-versions'

podTemplate(label: 'mypod',
    serviceAccount: 'deployer',
    containers: [
        containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
        containerTemplate(name: 'helm', image: 'alpine/helm', command: 'cat', ttyEnabled: true),
        containerTemplate(name: 'uplift', image: 'gembaadvantage/uplift', command: 'cat', ttyEnabled: true)
    ],
    volumes: [hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),]) {
    node('mypod') {
        withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {

            try {
                stage('Checkout') {
                    checkout scm
                }

                // If on main branch, install the Helm chart
                if (env.BRANCH_NAME == MAIN_BRANCH) {

                    stage('Install Helm Chart') {
                        container('helm') {
                            sh "helm upgrade --install --debug ${IMAGE_NAME} ./helm --values ./helm/values.yaml"
                        }
                    }

                    stage('Bump Version & Tag') {
                        container('uplift') {
                            withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]) {
                                sh """
                                    git config --global --add safe.directory '${env.WORKSPACE}'
                                    git remote set-url origin https://${GIT_TOKEN}@github.com/yuval-benjamin/MyPublicIP.git
                                    git checkout ${env.BRANCH_NAME}
                                    uplift release --fetch-all
                                """
                            }
                        }
                    }

                }

                stage('Notify A Successfull Build To Slack') {
                    slackSend channel: 'all-jenkins-builds', color: 'good', message: "A Succeccfull Build :) \n Branch ${env.BRANCH_NAME}, Build ${env.BUILD_NUMBER}."
                }

            } catch (err) {

                stage('Notify A Failed Build To Slack') {
                    slackSend channel: 'all-jenkins-builds', color: 'danger', message: "A Failed Build :( \n Branch ${env.BRANCH_NAME}, Build ${env.BUILD_NUMBER}. \n Errors: ${err}"
                }

                throw err

            } finally {

                stage('Cleanup') {
                    container('docker') {
                        sh 'docker system prune -af'
                    }
                }

            }
        }
    }
}