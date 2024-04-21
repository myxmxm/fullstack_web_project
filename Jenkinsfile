pipeline {
    agent any

    stages {
        stage('Start Backend') {
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    script {
                        sh '''
                        #!/bin/bash
                        cd /home/alex/public_html/test/shell_scripts/
                        sudo chmod +x kill_backend_on_port.sh
                        ./kill_backend_on_port.sh 8000 >> /tmp/kill_script.log 2>&1 &
                        sleep 5
                        cd /home/alex/public_html/test/backend/
                        sudo chmod o+w static
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

        stage('Deploy Application To Development Environment') {
            when {
                expression {
                    def buildResult = currentBuild.result
                    println "Current build result: ${currentBuild.result}"
                    currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    script {
                    sh '''
                        #!/bin/bash
                        echo start deploying application to development environment...
                        cd /home/alex/public_html/
                        sudo cp -r test /var/www/html/
                        cd /var/www/html/test/backend/
                        JENKINS_NODE_COOKIE=dontKillMe python3.9 -m uvicorn main:app --reload --host 0.0.0.0 --port 8000 >> /tmp/server.log 2>&1 &
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            step([
                $class              : 'RobotPublisher',
                outputPath          : '/var/lib/jenkins/workspace/test/',
                outputFileName      : "output.xml",
                reportFileName      : 'report.html',
                logFileName         : 'log.html',
                disableArchiveOutput: false,
                passThreshold       : 95.0,
                unstableThreshold   : 95.0,
                otherFiles          : "**/*.png",
            ])
            }  
        failure {
            script {
                sh '''
                    cd /var/www/html/test/backend/
                    JENKINS_NODE_COOKIE=dontKillMe python3.9 -m uvicorn main:app --reload --host 0.0.0.0 --port 8000 >> /tmp/server.log 2>&1 &
                '''
            }
        }
    }
}