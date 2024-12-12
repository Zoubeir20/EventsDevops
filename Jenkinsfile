pipeline {
    environment {

        registry = "Zoubeir20/eventsdevops"

        registryCredential = 'dockerhub_id'

        dockerImage = ''

    }

    agent any

    stages {
        stage('git') {
            steps {
                echo 'pulling from github';
                git branch : 'main',
                url : 'https://github.com/Zoubeir20/EventsDevops'
            }
        }
         stage('maven build ') {
            steps {
                echo 'maven build';
                sh """mvn clean install """
            }
        }
          stage('testing with mockito') {
            steps {
                echo 'maven testing';
                sh "mvn test"

        }
          }
       /*  stage('Sonarqube') {
            steps {
                echo 'sonar test';
              sh 'mvn sonar:sonar -Dsonar.login=admin -Dsonar.password=223JMT0056t*'
            }
      }*/

       stage('nexus') {
           steps {
               echo 'Deploy to nexus';
                sh 'mvn deploy -DskipTests'

           }
        }
         stage('Building our image') {

            steps {

                script {

                    dockerImage = docker.build registry + ":$BUILD_NUMBER"

                }

            }

       }
         stage('Deploy our image') {

           steps {

                script {

                    docker.withRegistry( '', registryCredential ) {

                        dockerImage.push()

                  }

               }

            }

       }

        stage('Cleaning up') {

            steps {

                sh "docker rmi $registry:$BUILD_NUMBER"

        }

        }
     //  stage('Install Docker Compose') {
   // steps {
       // sh 'sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
    //    sh 'sudo chmod +x /usr/local/bin/docker-compose'
   // }
//}

        stage('Building and deploying using docker-compose') {
            steps {
               sh 'docker-compose up -d'
            }
        }


       stage('Grafana Prometheus') {
            steps {
                sh 'docker start prometheus'
                sh 'docker start grafana'
            }
        }



    }
    post {
        always {
            publishHTML(target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: './target/site/jacoco',
                reportFiles: 'index.html',
                reportName: 'Jacoco Code Coverage Report'
            ])
            emailext (
                to: "zoubeir.ezzine@esprit.tn",
                from: "Jenkins@example.com",
                replyTo: "Jenkins@example.com" ,
                mimeType: 'text/html',
      subject: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
               <p>Build Status: ${currentBuild.result}</p>
        <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>;</p>
        <img src="https://www.phpro.be/uploads/media/sulu-400x400/09/469-jenkins%404x.png?v=1-0?62b3251db82aa489a7ee194a74cc6fb1" alt="jenkins">""",
        attachmentsPattern: 'target/site/jacoco/*.html'
    )
        }
    }
}

