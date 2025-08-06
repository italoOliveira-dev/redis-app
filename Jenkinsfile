pipeline {
   agent any
   stages {
      stage('Rodar testes com cobertura') {
         steps {
            sh 'npm install'
            script {
               try {
                  sh 'npm test'
               } catch (err) {
                  echo "Testes falharam, mas continuando para gerar cobertura"
               }
            }
         }
      }

      stage('Verificar cobertura') {
         steps {
            sh 'ls -lh coverage'
            sh 'cat coverage/lcov.info | head -n 10'
         }
      }

      stage('SonarQube validation') {
         steps {
            script {
               scannerHome = tool 'sonar-scanner';
            }
            withSonarQubeEnv('sonar-server') {
               sh "${scannerHome}/bin/sonar-scanner \
                  -Dsonar.projectKey=redis-app \
                  -Dsonar.sources=. \
                  -Dsonar.host.url=${env.SONAR_HOST_URL} \
                  -Dsonar.token=${env.SONAR_AUTH_TOKEN} \
                  -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                  -Dsonar.exclusions=coverage/**,**/*.html,**/*.spec.js,node_modules/**"
            }
         }
      }

      stage('Quality Gate') {
         steps {
            waitForQualityGate abortPipeline: true
         }
      }

      stage('build da imagem docker') {
         steps {
            sh 'docker build -t devops/app .'
         }
      }

      stage('subir docker compose - redis e app') {
         steps {
            sh 'docker compose up --build -d'
         }
      }

      stage('sleep para subida de containers') {
         steps {
            sh 'sleep 10'
         }
      }

      stage('teste da aplicação') {
         steps {
            sh 'chmod +x ./teste-app.sh'
            sh './teste-app.sh'
         }
      }

      stage('shutdown dos container de teste') {
         steps {
            sh 'docker compose down --rmi all -v --remove-orphans'
         }
      }
   }
}
