pipeline {
    agent {
        node {
            label 'motor-host'
        }
    }
    
    environment {
        VERSION = '1.0.0'
        MOTOR_TEST_RUNNER = "mplatina/motor-test-runner:${VERSION}"
        RUN_MOTOR = "/usr/local/bin/run-aa.sh"
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
                    sh "docker run -v ${WORKSPACE}:/aa ${MOTOR_TEST_RUNNER} ${RUN_MOTOR} ${MOTOR_TEST_NAME}"
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
                    body: """
                    Check console output at ${env.BUILD_URL}
                    <%
                    import java.text.DateFormat
                    import java.text.SimpleDateFormat
                    %>
                    <!-- Robot Framework Results -->
                    <%
                    def robotResults = false
                    def actions = build.actions // List<hudson.model.Action>
                    actions.each() { action ->
                        if( action.class.simpleName.equals("RobotBuildAction") ) { // hudson.plugins.robot.RobotBuildAction
                            robotResults = true %>
                    
                        <p><h4>Robot Test Summary:</h4></p>
                        <table cellspacing="0" cellpadding="4" border="1" align="left">
                            <thead>
                            <tr bgcolor="#F3F3F3">
                                <td><b>Type</b></td>
                                <td><b>Total</b></td>
                                <td><b>Passed</b></td>
                                <td><b>Failed</b></td>
                                <td><b>Pass %</b></td>
                            </tr>
                            </thead>
                    
                            <tbody>
                    
                            <tr><td><b>All Tests</b></td>
                                <td><%= action.result.overallTotal %></td>
                                <td><%= action.result.overallPassed %></td>
                                <td><%= action.result.overallFailed %></td>
                                <td><%= action.overallPassPercentage %></td>
                            </tr>
                    
                            <tr><td><b>Critical Tests</b></td>
                                <td><%= action.result.criticalTotal %></td>
                                <td><%= action.result.criticalPassed %></td>
                                <td><%= action.result.criticalFailed %></td>
                                <td><%= action.criticalPassPercentage %></td>
                            </tr>
                    
                            </tbody>
                        </table><%
                        } // robot results
                    }
                    if (!robotResults) { %>
                    <p>No Robot Framework test results found.</p>
                    <%
                    } %>
                    """,
                    to: "${MOTOR_EMAIL_RECIPIENTS_LIST}",
                    from: "msuman@platinasystems.com",
                    attachmentsPattern: "output.zip"
                )
            }
        }        
    }
}
