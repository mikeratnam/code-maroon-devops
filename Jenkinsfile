pipeline {
    agent {
        label 'agent-max'
    }

    stages {

        stage('Terraform') {
            steps {
                script {
                    try {

                        // AWS credentials for Terraform + S3 backend
                        withCredentials([
                            [$class: 'AmazonWebServicesCredentialsBinding',
                             credentialsId: 'aws-terraform']
                        ]) {

                            sh 'terraform init'

                            sh 'terraform state show aws_instance.machine-1'

                            // EC2 SSH key for Terraform remote-exec
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

                    } catch (err) {

                        // Cleanup if Terraform apply fails
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
}