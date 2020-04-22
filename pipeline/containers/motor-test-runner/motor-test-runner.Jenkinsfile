pipeline {
    agent {
        node {
            label 'motor-host'
        }
    }
    
    environment {
        VERSION = '1.0.0'
        MOTOR_TEST_RUNNER = "mplatina/motor-test-runner:${VERSION}"
        MOTOR_TEST_RUNNER_DOCKERFILE = 'pipeline/containers/motor-test-runner/motor-test-runner.Dockerfile'
    }

    stages {
        stage('Docker Login') {
            steps {
                sh "docker login"
            }
        }

        stage('Remove Old Image') {
            steps {
                sh "docker image rm -f ${MOTOR_TEST_RUNNER} || true"
            }
        }

        stage('Build New Image') {
            steps {
                sh "docker build . -f ${MOTOR_TEST_RUNNER_DOCKERFILE} -t ${MOTOR_TEST_RUNNER}"
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh "docker push ${MOTOR_TEST_RUNNER}"
            }
        }
               stage('Clean Test Results') {
            steps {
                sh "rm -rf output"
                sh "mkdir output"
            }
        }
        stage('Run Tests') {
            steps {
                sh "docker run -v ${WORKSPACE}:/aa ${MOTOR_TEST_RUNNER} robot -x /aa/output/robot.xml --outputdir /aa/output /aa/pipeline/containers/motor-test-base/motor-test-base.robot"
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
