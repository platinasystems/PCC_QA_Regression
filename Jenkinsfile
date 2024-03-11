def SDK_URL='https://github.com/platinasystems/platina-sdk.git';
def REGRESSION_URL='https://github.com/platinasystems/PCC_QA_Regression.git';


pipeline {

    agent {
        docker { image 'python:3' }
    }

    environment {
        SDK_HOME='platina-sdk';
        REGRESSION_HOME='PCC_QA_Regression';
    }

    stages {

        /**
         * Platina SDK
         **/
        stage('Build Platina SDK') {
            steps {
                cleanWs()

                // Download From Git
                dir(SDK_HOME) {
                    git credentialsId: '${GIT_CREDENTIALS}',
                        url: SDK_URL,
                        branch: '${PLATINA_SDK_BRANCH}'
                }

                // Compile and Install
                dir(SDK_HOME + '/python') {
                    sh 'python3 setup.py sdist'
                    sh 'pip3 install dist/platina_sdk-*.tar.gz'
                }
            }
        }

        /**
        * PCC QA Regression
        **/
        stage('Build PCC QA Regression') {
            steps {
                // Download From Git
                dir(REGRESSION_HOME) {
                    // Download From Git
                    git credentialsId: '${GIT_CREDENTIALS}',
                        url: REGRESSION_URL,
                        branch: '${PCC_QA_REGRESSION_BRANCH}'

                    // Compile and Install
                    sh 'python3 setup.py sdist bdist_wheel'
                    sh 'pip3 install dist/PCC_QA_Regression-*.tar.gz'
                }
            }
        }

        /**
        * RUN Tests
        **/
        stage('Run Tests') {
            steps {
                // Install Robot Framework
                sh 'pip3 install robotframework robotframework-requests'
                // sh 'robot -x output/robot.xml --outputdir output $REGRESSION_HOME/pipeline/containers/motor-test-base/motor-test-base.robot'

                dir(REGRESSION_HOME){
                    catchError(buildResult: 'SUCCESS', stageResult:'FAILURE') {
                        sh '''
                            export PYTHONPATH=/usr/local/robot
                            robot -x robot.xml --outputdir output ${TEST_NAME}
                        '''
                    }
                }
            }
        }

        /**
        * Results
        **/
        stage('Publish Test Results') {
            steps {
                dir(REGRESSION_HOME) {
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
            }
            post {
                always {
                    dir(REGRESSION_HOME) {
                        junit 'output/robot.xml'
                    }
                }
            }
        }

        /**
        * Sending Results
        **/
        stage('Email Test Results') {
            steps {
                emailext (
                    subject: "Test Report: Job '${env.JOB_NAME} ${env.BUILD_NUMBER}'",
                    body: '''${SCRIPT, template="groovy-email.template"}''',
                    mimeType: 'text/html',
                    to: "${EMAIL_RECIPIENTS_LIST}",
                    from: "aucta.tenant@gmail.com"
                )
            }
        }
    }
}
