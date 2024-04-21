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
                        nohup python3 -m uvicorn main:app --reload --host 0.0.0.0 --port 8000 > uvicorn.log 2>&1 &
                        disown -h
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