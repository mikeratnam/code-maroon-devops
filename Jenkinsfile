pipeline {
    agent{
        label 'agent-max'
    }
    
    stages{
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
    }
}