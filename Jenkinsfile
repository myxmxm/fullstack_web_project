pipeline {
    agent any

    stages {
        stage('Start Backend') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    script {
                        sh '''
                        #!/bin/bash
                        cd /home/alex/public_html/test/backend/
                        JENKINS_NODE_COOKIE=dontKillMe python3.9 -m uvicorn main:app --reload --host 0.0.0.0 --port 8000 >> /tmp/server.log 2>&1 &
                        '''
                    }
                }
            }
        }
        stage('Run Robot Test') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    script {
                    sh 'python3.9 -m robot /home/alex/public_html/test/robot_framework_tests/test.robot'
                    }
                }
            }
        }

        stage('Stop Backend') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    script {
                    sh '''
                        #!/bin/bash
                        cd /home/alex/public_html/test/shell_scripts/
                        ./kill_backend_on_port.sh 8000 >> /tmp/kill_script.log 2>&1 &
                        '''
                    }
                }
            }
        }
        
        stage('RobotFramework Status') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    robot '.'
                }
            }
        }
    }
}