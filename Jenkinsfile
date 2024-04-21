pipeline {
    agent any

    stages {
        stage('Run Robot Test') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    script {
                    sh '''
                    #!/bin/bash
                    cd /home/alex/public_html/test/backend/
                    python3 -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
                    '''
                    sh 'python3 -m robot /home/alex/public_html/test/robot_framework_tests/test.robot'
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