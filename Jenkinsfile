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
                        setsid python3.9 main.py >> /tmp/server.log 2>&1 &
                        sleep 10
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
        
        stage('RobotFramework Status') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    robot '.'
                }
            }
        }
    }
}