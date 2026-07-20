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

        stage('Authenticate & Init') {
            steps {
                withCredentials([
                    file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    sh '''
                        set -euo pipefail
                        gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
                        gcloud config set project "$GOOGLE_CLOUD_PROJECT"
                    '''
                    
                    dir(params.TF_WORKING_DIR) {
                        // Using single quotes to prevent premature Groovy execution evaluation
                        sh '''
                            set -euo pipefail
                            terraform fmt -check -recursive
                            terraform init \
                                -backend-config="${BACKEND_CONFIG}" \
                                -input=false \
                                -no-color
                            terraform validate -no-color
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')
                ]) {
                    dir(params.TF_WORKING_DIR) {
                        script {
                            if (params.ACTION == 'apply') {
                                sh '''
                                    set -euo pipefail
                                    terraform plan \
                                        -no-color \
                                        -input=false \
                                        -var-file="${VAR_FILE}" \
                                        -out=tfplan.out \
                                        | tee tfplan.log
                                '''
                            } else {
                                sh '''
                                    set -euo pipefail
                                    terraform plan \
                                        -destroy \
                                        -no-color \
                                        -input=false \
                                        -var-file="${VAR_FILE}" \
                                        -out=tfplan.out \
                                        | tee tfplan.log
                                '''
                            }
                        }
                    }
                }
            }
        }

        stage('Manual Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        message: "Proceed with Terraform ${params.ACTION} action on ${env.GOOGLE_CLOUD_PROJECT}? Review the archived plan log first.",
                        ok: 'Proceed'
                    )
                }
            }
        }

        stage('Terraform Execution') {
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
                                | tee tfexecute.log
                        '''
                    }
                }
            }
        }

        stage('Display Terraform Outputs') {
            when {
                allOf {
                    expression { params.ACTION == 'apply' }
                    expression { currentBuild.currentResult == 'SUCCESS' }
                }
            }
            steps {
                dir(params.TF_WORKING_DIR) {
                    sh '''
                        set -euo pipefail
                        echo "===== Operational Stack Outputs ====="
                        terraform output -no-color | tee tfoutputs.log
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
