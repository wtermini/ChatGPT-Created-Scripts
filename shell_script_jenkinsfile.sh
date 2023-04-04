pipeline {
    agent any

    stages {
        stage('Run test.sh') {
            steps {
                sh './test.sh'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
