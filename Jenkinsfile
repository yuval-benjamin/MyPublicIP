IMAGE_NAME = 'my-public-ip'
IMAGE_TAG = '1.0.0'
REGISTRY_URL = 'yuvalbenjamin'
MAIN_BRANCH = 'main'

podTemplate(label: 'mypod',
    containers: [
        containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true),
        containerTemplate(name: 'helm', image: 'alpine/helm', command: 'cat', ttyEnabled: true)
    ],
    volumes: [hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),]) {
    node('mypod') {
        withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {

            def branch = env.BRANCH_NAME

            stage('Checkout') {
                checkout scm
            }
            
            stage('Run Tests & Build Docker Image') { 
                container('docker') {

                    // If on main branch, push Docker image
                    if (branch == MAIN_BRANCH) {
                        final_image_name = "${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}"
                        sh """
                            docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
                            docker build -t ${final_image_name} ./
                            docker push ${final_image_name}
                            docker tag ${final_image_name} ${REGISTRY_URL}/${IMAGE_NAME}:latest
                            docker push ${REGISTRY_URL}/${IMAGE_NAME}:latest
                        """
                    } else {
                        sh "docker build --target tester -t ${IMAGE_NAME}-test ./"
                    }
                }
            }

            stage('Install Helm Chart') {
                container('helm') {
                    // sh "helm package ./helm"
                    sh "helm upgrade --install ${IMAGE_NAME} ./helm --values ./helm/values.yaml"
                }
            }

            stage('Cleanup') {
                container('docker') {
                    sh 'docker system prune -af'
                }
            }
        }
    }
}
