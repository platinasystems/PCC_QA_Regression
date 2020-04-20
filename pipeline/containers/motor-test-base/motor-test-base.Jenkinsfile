pipeline {
    agent {
        node {
            label 'motor-host'
        }
    }
    
   stages {
     stage('Info') {
         steps {
             sh "id"
             sh "pwd"
         }
      }
      stage('Docker Login') {
         steps {
             sh "docker login"
         }
      }

      stage('Remove Old Images!') {
         steps {
             sh "docker system prune -a -f || true"
         }
      }

      stage('Build New Image') {
         steps {
             sh "docker build . -f pipeline/containers/motor-test-base/motor-test-base.Dockerfile -t mplatina/motor-test-base:1.0.0"
         }
      }

      stage('Push to DockerHub') {
         steps {
             sh "docker push mplatina/motor-test-base:1.0.0"
         }
      }
        stage('Run Tests') {
            steps {
                sh "docker run -v ${WORKSPACE}:/motor mplatina/motor-test-base:1.0.0 robot -x /motor/output/robot.xml --outputdir /motor/output /motor/tests/smoke/motor-test-base.robot"
            }
        }
        stage('Publish Test Results') {
            steps {
                step([$class: 'RobotPublisher',
                    outputPath: 'output',
                    outputFileName: 'output.xml',
                    reportFileName: 'report.html',
                    logFileName: 'log.html',
                    otherFiles: '',
                    disableArchiveOutput: false,
                    enableCache: true,
                    unstableThreshold: 90,
                    passThreshold: 95,
                    onlyCritical: true
                ])
            }
            post {
                always {
                    junit 'output/robot.xml'
                }
            }
        }
   }
}
