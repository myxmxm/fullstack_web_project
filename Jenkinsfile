pipeline {
    agent any

    stages {
        stage('Run Robot Test') {
            steps {
                sh 'python3 -m robot /home/alex/public_html/simple_test.robot'
            }
        }
        
        stage('RobotFramework Status') {
            steps {
                robot '.'
            }
       }
    }
}