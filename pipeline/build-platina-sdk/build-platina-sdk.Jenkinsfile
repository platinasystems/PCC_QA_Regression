pipeline {
    agent {
        node {
            label 'motor-host'
        }
    }
    
    environment {
        SDK_HOME = "/home/jenkins/aa"
    }

    stages {
        stage('Get Latest Code') {
            steps {
                sh "cd $SDK_HOME; git pull"
            }
        }
        stage('Build SDK') {
            steps {
                sh "sudo rm -rf $SDK_HOME/dist"
                sh "$SDK_HOME/build-aa.sh"
            }
        }     
    }
}
