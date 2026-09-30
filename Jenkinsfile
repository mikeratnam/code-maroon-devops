pipeline {
    agent {
        label 'agent-max'
    }

    stages {

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'tf-ec2-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh 'TF_VAR_ssh_key_path="$SSH_KEY" terraform apply -auto-approve'
                }
            }
        }
    }
}