pipeline {
    agent any

    stages {
        stage('Run Robot Test') {
            steps {
                sh 'python3 -m robot /home/alex/public_html/test/robot_framework_tests/test.robot'
            }
        }
        
        stage('RobotFramework Status') {
            steps {
                robot '.'
            }
       }
    }
}