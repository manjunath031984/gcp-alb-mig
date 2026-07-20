pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 60, unit: 'MINUTES')
        ansiColor('xterm')
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select whether to apply or destroy the Terraform-managed infrastructure.'
        )

        string(
            name: 'TF_WORKING_DIR',
            defaultValue: '.',
            description: 'Relative path to the Terraform root module.'
        )

        string(
            name: 'VAR_FILE',
            defaultValue: 'gcp-alb-mig.tfvars',
            description: 'Primary Terraform variable file.'
        )

        string(
            name: 'BACKEND_CONFIG',
            defaultValue: 'gcp-alb-mig.tf',
            description: 'Terraform backend configuration file.'
        )
    }

    environment {
        GOOGLE_CLOUD_PROJECT = 'gcp-dev-july-2026'
        REGION               = 'us-central1'
        ZONE                 = 'us-central1-a'
        TF_IN_AUTOMATION     = 'true'
        TF_INPUT             = 'false'
        PATH                 = "${WORKSPACE}/.bin:${env.PATH}"
    }

    stages {

        stage('Checkout Source Code') {
            steps {
                checkout scm
                echo "Checked out ${env.GIT_BRANCH ?: 'unknown branch'} @ ${env.GIT_COMMIT ?: 'unknown commit'}"
            }
        }

        stage('Authenticate to GCP') {
            steps {
                withCredentials([
                    file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    sh '''
                        set -euo pipefail

                        gcloud auth activate-service-account \
                            --key-file="$GOOGLE_APPLICATION_CREDENTIALS"

                        gcloud config set project "$GOOGLE_CLOUD_PROJECT"
                    '''
                }
            }
        }

        stage('Terraform Format') {
            steps {
                dir(params.TF_WORKING_DIR) {
                    sh '''
                        terraform fmt \
                            -check \
                            -recursive \
                            -diff
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    dir(params.TF_WORKING_DIR) {
                        sh """
                            set -euo pipefail

                            terraform init \
                                -backend-config="${params.BACKEND_CONFIG}" \
                                -input=false \
                                -no-color
                        """
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir(params.TF_WORKING_DIR) {
                    sh '''
                        terraform validate -no-color
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }

            steps {
                withCredentials([
                    file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    dir(params.TF_WORKING_DIR) {
                        sh """
                            set -euo pipefail

                            terraform plan \
                                -no-color \
                                -input=false \
                                -var-file="${params.VAR_FILE}" \
                                -out=tfplan.out \
                                | tee tfplan.log
                        """
                    }
                }
            }
        }

        stage('Manual Approval') {
            steps {
                script {
                    timeout(time: 30, unit: 'MINUTES') {
                        input(
                            message: "Proceed with Terraform ${params.ACTION} action on ${env.GOOGLE_CLOUD_PROJECT}?",
                            ok: 'Proceed'
                        )
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }

            steps {
                withCredentials([
                    file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    dir(params.TF_WORKING_DIR) {
                        sh '''
                            set -euo pipefail

                            terraform apply \
                                -no-color \
                                -input=false \
                                -auto-approve \
                                tfplan.out \
                                | tee tfapply.log
                        '''
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }

            steps {
                withCredentials([
                    file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    dir(params.TF_WORKING_DIR) {
                        sh """
                            set -euo pipefail

                            terraform destroy \
                                -no-color \
                                -input=false \
                                -auto-approve \
                                -var-file="${params.VAR_FILE}" \
                                | tee tfdestroy.log
                        """
                    }
                }
            }
        }

        stage('Display Terraform Outputs') {
            when {
                allOf {
                    expression {
                        params.ACTION == 'apply'
                    }
                    expression {
                        currentBuild.currentResult == 'SUCCESS'
                    }
                }
            }

            steps {
                dir(params.TF_WORKING_DIR) {
                    sh '''
                        set -euo pipefail

                        echo "===== Operational Stack Outputs ====="

                        terraform output \
                            -no-color \
                            | tee tfoutputs.log
                    '''
                }
            }
        }
    }

    post {

        always {
            dir(params.TF_WORKING_DIR) {
                archiveArtifacts(
                    artifacts: '*.log, *.out',
                    allowEmptyArchive: true,
                    fingerprint: true
                )
            }
        }

        success {
            echo "Pipeline completed successfully for project ${env.GOOGLE_CLOUD_PROJECT}."
        }

        failure {
            echo "Pipeline FAILED for project ${env.GOOGLE_CLOUD_PROJECT}. Review the archived workspace logs for target errors."
        }

        cleanup {
            cleanWs(
                deleteDirs: true,
                notFailBuild: true
            )
        }
    }
}