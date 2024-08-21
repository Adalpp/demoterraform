pipeline {
    agent any

    environment {
        // Ensure Terraform is installed in the PATH and AWS credentials are configured
        TF_VERSION = "1.8.2"
        AWS_REGION = "ap-south-1"
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')  // Replace with Jenkins credentials ID
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')  // Replace with Jenkins credentials ID
    }

    stages {
        stage('Initialize Terraform') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    // Create a Terraform plan
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the Terraform plan
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            // Cleanup terraform files
            cleanWs()
        }
    }
}
