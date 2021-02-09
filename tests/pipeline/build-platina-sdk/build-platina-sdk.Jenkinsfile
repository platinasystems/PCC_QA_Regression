pipeline {
    agent {
        node {
            label 'motor-host'
        }
    }
    
    environment {
        SDK_HOME = "/home/jenkins/platina-sdk"
    }

    stages {
        stage('Get Latest Code') {
            steps {
                sh "cd $SDK_HOME; git pull"
            }
        }
        stage('Build SDK') {
            steps {
                sh "sudo rm -rf $SDK_HOME/python/dist"
                sh "cd $SDK_HOME/python; $SDK_HOME/python/build-sdk.sh"
            }
        }     
        stage('Push SDK binary') {
            steps {
                sh "sudo cp $SDK_HOME/python/dist/*.gz /var/www/html"
            }
        }     
    }
}
