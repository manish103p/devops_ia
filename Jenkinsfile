pipeline {
    agent { label "master"}
    stages {
        stage('Update Ubuntu') {
            steps {
                sh 'sudo apt-get update'
            }    
        }
        stage('Install ChefDK') {
            steps {
                script {
                    def chefdkExists = fileExists '/usr/bin/chef-client'
                    if (chefdkExists) {
                        echo 'Skipping Chef install...already installed'
                    }else{
                        sh 'wget https://packages.chef.io/files/stable/chefdk/3.9.0/ubuntu/16.04/chefdk_3.9.0-1_amd64.deb'
                        sh 'sudo dpkg -i chefdk_3.9.0-1_amd64.deb'
                    }
                }
            }
        }
        stage('Download Cookbook') {
            steps {
                sh 'git clone https://github.com/manish103p/devops_ia'
                sh 'cd devops_ia'
            }
        }
        stage('Install Docker ') {
            steps {
                script {
                    def dockerExists = fileExists '/usr/bin/docker'
                    if (dockerExists) {
                        echo 'Skipping Docker install...already installed'
                    }else{
                        sh 'wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/containerd.io_1.2.5-1_amd64.deb'
                        sh 'wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce-cli_18.09.6~3-0~ubuntu-xenial_amd64.deb'
                        sh 'wget https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_18.09.6~3-0~ubuntu-xenial_amd64.deb'
                        sh 'sudo dpkg -i containerd.io_1.2.5-1_amd64.deb'
                        sh 'sudo dpkg -i docker-ce-cli_18.09.6~3-0~ubuntu-xenial_amd64.deb'
                        sh 'sudo dpkg -i docker-ce_18.09.6~3-0~ubuntu-xenial_amd64.deb'
                        sh 'sudo usermod -aG root,docker azureuser'
                    }    
                    sh 'sudo docker run hello-world'
                }
            }
        }
        stage('Install Ruby and Test Kitchen') {
            steps {
                sh 'sudo apt-get install -y rubygems ruby-dev'
                sh 'chef gem install kitchen-docker'
                // sh 'yes'
            }
        }
        stage('Run Test Kitchen') {
            steps {
                sh 'pwd'
            //    sh 'sudo kitchen test' 
            }
        }
        stage('Upload Cookbook to Chef Server, Converge Nodes') {
            steps {
                withCredentials([zip(credentialsId: 'chef-server-creds', variable: 'CHEFREPO')]) {
                    sh 'mkdir -p $CHEFREPO/chef-repo/cookbooks/apache'
                    sh 'sudo rm -rf $WORKSPACE/Berksfile.lock'
                    sh 'mv $WORKSPACE/* $CHEFREPO/chef-repo/cookbooks/apache'
                    sh "knife cookbook upload apache --force -o $CHEFREPO/chef-repo/cookbooks -c $CHEFREPO/chef-repo/.chef/config.rb"
                    withCredentials([sshUserPrivateKey(credentialsId: 'agent-creds', keyFileVariable: 'AGENT_SSHKEY', passphraseVariable: '', usernameVariable: '')]) {
                        sh "knife ssh 'recipe:apache' -x ubuntu -i $AGENT_SSHKEY 'sudo chef-client' -c $CHEFREPO/chef-repo/.chef/config.rb"      
                    }
                }

                // sh '''#!/bin/bash

                //     echo "Hello from bash"
                //     echo "Who I'm $SHELL"
                //     sudo su
                //     cd /home/azureuser/
                //     python ssh.py
                // '''
            }
        }
    }
}
