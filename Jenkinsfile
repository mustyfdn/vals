pipeline {
    agent { 
        label agentLabel
    }
    environment {
        PATH=sh(script:"echo $PATH:/usr/local/bin", returnStdout:true).trim()
        GIT_FOLDER = sh(script:'echo ${GIT_URL} | sed "s/.*\\///;s/.git$//"', returnStdout:true).trim()
    }
    stages{
        stage('Test'){
            steps{
                script{
                    env.VAULT_IP = sh(script:"curl http://169.254.169.254/latest/meta-data/public-ipv4", returnStdout:true).trim() 
                    withCredentials([string(credentialsId: 'vault-token', variable: 'VAULT_TOKEN')]) {  // export VAULT_TOKEN=${VAULT_TOKEN}
                        sh """
                        
                        export VAULT_ADDR=https://${env.VAULT_IP}:8200
                        export VAULT_CACERT=${VAULT_CACERT}
                        echo "password: ref+vault://mehmet/crediantial#/password" | vals eval -f -
                        cat mysql.yml | vals eval -f - | tee all.yaml 
                        rm -rf all.yaml
                        """
                    }
                }
            }  
        }   
    }
    post {
        success {
            echo "You are great man"
        }
    }
}
