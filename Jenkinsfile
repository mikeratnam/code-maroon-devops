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

        stage('Check Terraform State') {
            steps {
                sh 'terraform state show aws_instance.machine-1'
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    try {
                        withCredentials([
                            sshUserPrivateKey(
                                credentialsId: 'tf-ec2-key',
                                keyFileVariable: 'SSH_KEY',
                                usernameVariable: 'SSH_USER'
                            )
                        ]) {
                            withCredentials([
                                [$class: 'AmazonWebServicesCredentialsBinding',
                                 credentialsId: 'aws-terraform']
                            ]) {
                                sh 'TF_VAR_ssh_key_path="$SSH_KEY" terraform apply -auto-approve'
                            }
                        }
                    } catch (err) {
                        sh 'terraform destroy -auto-approve'
                        throw err
                    }
                }
            }
        }

        stage('Ansible Configure') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'tf-ec2-key',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh '''
                        ansible-playbook \
                            -i ansible/inventory \
                            -u "$SSH_USER" \
                            --private-key "$SSH_KEY" \
                            ansible/playbook.yml
                    '''        
            }
        }
    }
}

