pipeline {
    agent any
    environment {
        GITNAME = 'shlim0118'
        GITMAIL = 'tim02366@naver.com'
        GITWEBADD = 'https://github.com/shlim0118/hama-wild.git'
        GITSSHADD = 'git@github.com:shlim0118/wild-deploy.git'
        GITCREDENTIAL = 'git_cre'
        ECR = '756266714368.dkr.ecr.ap-northeast-2.amazonaws.com/wild'
        AWSCREDENTIAL = 'aws_cre'
        WILD_BOT_TOKEN = credentials('WILD_BOT_TOKEN')  // Jenkins에서 가져온 WILD Bot Token
    }
    stages {
        stage('Checkout Github') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [[$class: 'CloneOption', depth: 1]], 
                userRemoteConfigs: [[credentialsId: GITCREDENTIAL, url: GITWEBADD]]])
            }
            post {
                failure {
                    sh 'echo clone failed'
                }
                success {
                    sh 'echo clone success'
                }
            }
        }
        stage('Update config.yml with WILD_BOT_TOKEN') {
            steps {
                // 정확한 경로로 config.yml 수정
                sh "sed -i 's@\\\${WILD_BOT_TOKEN}@${WILD_BOT_TOKEN}@g' plugins/DiscordSRV/config.yml"
            }
            post {
                failure {
                    sh 'echo config update failed'
                }
                success {
                    sh 'echo config update success'
                }
            }
        }
        stage('Docker 이미지 빌드') {
            steps {
                sh "docker build -t ${ECR}:${currentBuild.number} ."   // 현재 빌드 번호를 도커 이미지 태그로 사용
                sh "docker build -t ${ECR}:latest ."                   // 최신 태그로 이미지 빌드
            }
            post {
                failure {
                    sh 'echo image build failed'
                }
                success {
                    sh 'echo image build success'
                }
            }
        }
        stage('ECR 에 이미지 푸시') {
            steps {
                withDockerRegistry(credentialsId: 'ecr:ap-northeast-2:aws_cre', url: 'https://756266714368.dkr.ecr.ap-northeast-2.amazonaws.com/wild') {
                    sh "docker push ${ECR}:${currentBuild.number}"
                    sh "docker push ${ECR}:latest"
                }
            }
            post {
                failure {
                    sh "docker image rm -f  ${ECR}:${currentBuild.number}"
                    sh "docker image rm -f  ${ECR}:latest"
                    sh 'echo push failed'
                }
                success {
                    sh "docker image rm -f  ${ECR}:${currentBuild.number}"
                    sh "docker image rm -f  ${ECR}:latest"
                    sh 'echo push success'
                }
            }
        }
        stage('send to CD') {
            steps {
                    git credentialsId: GITCREDENTIAL, url: GITSSHADD, branch: 'main'
                    sh "git config --global user.email ${GITMAIL}"
                    sh "git config --global user.name ${GITNAME}"
                    sh "sed -i 's@${ECR}:.*@${ECR}:${currentBuild.number}@g' wild.yaml"

                    sh 'git add .'
                    sh 'git branch -M main'
                    sh "git commit -m 'fixed tag ${currentBuild.number}'"
                    sh 'git remote remove origin'
                    sh "git remote add origin ${GITSSHADD}"
                    sh 'git push origin main'
            }
            post {
                failure {
                    sh 'echo failed'
                }
                success {
                    sh 'echo naice hanseok1hjhjh'
                }
            }
        }
    }
}