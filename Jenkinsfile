pipeline {
    environment {

        registry = "zoubeirezzine/eventsdevops"

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
        stage('Sonarqube') {
            steps {
                echo 'sonar test';
              sh 'mvn sonar:sonar -Dsonar.login=admin -Dsonar.password=223JMT0056t*'
            }
      }

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




       // stage('Building and deploying using docker-compose') {
       //     steps {
       //        sh 'docker-compose up -d'
       //     }
        //}

stage('Création du livrable') {

            steps {

                echo "📦 Génération du livrable (JAR, WAR...)"

                sh 'mvn package -DskipTests'

            }

        }
        stage('Trouver le fichier JAR') {
                    steps {
                script {
                    def jar = sh(script: "ls target/*.jar | grep -v original | head -n 1", returnStdout: true).trim()
                    env.JAR_NAME = jar.replaceAll("target/", "")
                    echo "🗂️ Fichier JAR détecté : ${env.JAR_NAME}"
                         }
                         }
                }


        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = "event-backend"
                    def jarFile = env.JAR_NAME ?: "app.jar"
                    echo "📦 Construction de l'image Docker avec le JAR : ${jarFile}"
                    sh "docker build --build-arg JAR_FILE=${jarFile} -t ${imageName}:latest ."
                }
            }
        }

        stage('Déploiement avec Docker Compose') {
            when {
                expression { fileExists('docker-compose.yml') }
            }
            steps {
                echo "🚀 Déploiement avec docker-compose..."
                sh 'docker compose stop event-backend'
                sh 'docker compose up -d --build event-backend'
                  sh 'sleep 40'
            }
        }


       stage('Grafana Prometheus') {
            steps {
                sh 'docker start prometheus'
                sh 'docker start grafana'
            }
        }



    }

}

