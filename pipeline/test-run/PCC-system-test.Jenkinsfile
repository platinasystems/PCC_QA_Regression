pipeline {
    agent {
        node {
            label 'motor-host'
        }
    }
    
    environment {
        VERSION = '1.0.0'
        MOTOR_TEST_RUNNER = "mplatina/motor-test-runner:${VERSION}"
        RUN_MOTOR = "/usr/local/bin/run-pcc_qa.sh"
        PCC_KEY = "pcc_242"
    }

    stages {
        stage('Pull Test Runner') {
            steps {
                sh "docker pull ${MOTOR_TEST_RUNNER}"
            }
        }
        stage('Clean Test Results') {
            steps {
                sh "sudo rm -rf output"
                sh "sudo rm -f output.zip"
                sh "mkdir output"
            }
        }
        stage('Run Tests') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult:'FAILURE') {
                    sh "docker run -v ${WORKSPACE}:/PCC_QA_Regression ${MOTOR_TEST_RUNNER} ${RUN_MOTOR} ${MOTOR_TEST_NAME}"
                }
            }
        }  
        stage('Publish Test Results') {
            steps {
                step([$class: 'RobotPublisher',
                    outputPath: 'output',
                    outputFileName: 'output.xml',
                    reportFileName: 'report.html',
                    logFileName: 'log.html',
                    otherFiles: '*.log',
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
        stage('Zip the output') {
            steps {
                sh "zip -r output.zip output"
            }
        }     
        stage('Email Test Results') {
            steps {
                emailext (
                    subject: "Test Report: Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'",
                    body: '''${SCRIPT, template="managed:Groovy Email Template"}''',
                    mimeType: 'text/html',
                    to: "${MOTOR_EMAIL_RECIPIENTS_LIST}",
                    from: "msuman@platinasystems.com"
                )
            }
        }        
    }
}
