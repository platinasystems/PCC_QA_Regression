pipeline {
    agent {
        node {
            label 'motor-host'
        }
    }
    
    environment {
        VERSION = '1.0.0'
        MOTOR_TEST_RUNNER = "mplatina/motor-test-runner:${VERSION}"
        RUN_MOTOR = "/motor/src/motorframework/scripts/run-motor.sh"
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
                sh "rm -rf output"
                sh "rm -f robot_output.zip"
                sh "mkdir output"
            }
        }
        stage('Truncate PCC Logs') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult:'FAILURE') {
                    sh "docker run -v ${WORKSPACE}:/motor ${MOTOR_TEST_RUNNER} ${RUN_MOTOR} /motor/pipeline/test-run/cli-truncate-pcc-logs.robot --variable testdata_key:${PCC_KEY}"
                }
            }
        }
        stage('Run Tests') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult:'FAILURE') {
                    sh "docker run -v ${WORKSPACE}:/motor ${MOTOR_TEST_RUNNER} ${RUN_MOTOR} /motor/${MOTOR_TEST_NAME}"
                }
            }
        }
        stage('Copy PCC Logs from PCC to motor-test-runner container') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult:'FAILURE') {
                    sh "docker run -v ${WORKSPACE}:/motor ${MOTOR_TEST_RUNNER} ${RUN_MOTOR} /motor/pipeline/test-run/cli-copy-pcc-logs.robot --variable testdata_key:${PCC_KEY}"
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
                sh "zip -r robot_output.zip output"
            }
        }
        stage('Email Test Results') {
            steps {
                emailext (
                    subject: "Test Report: Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'",
                    body: """
                    Check console output at ${env.BUILD_URL}
                    """,
                    to: "${MOTOR_EMAIL_RECIPIENTS_LIST}",
                    from: "msuman@platinasystems.com",
                    attachmentsPattern: "robot_output.zip"
                )
            }
        }        
    }
}
