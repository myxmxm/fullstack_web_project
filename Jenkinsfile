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
                    python3.9 -m pip install uvicorn fastapi aiomysql pydantic pyjwt python-jose python-dotenv python-multipart 
                    '''
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