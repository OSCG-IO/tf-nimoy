# tf-nimoy - Terraform & Ansible Nimoy

An InfrastuctureAsCode (IaC) example of the Spock Test driver, Nimoy.

On OSX run:

  brew install terraform
  brew install ansible
  brew install pv

## steps to run

### 1.) Add your AWS credentials to a local secure file called 'keys/aws-creds.sh' to look like this:

    export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXX
    export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

### 2.) Configure the top of the 'env.sh' with the machine type and locations

    MACHINE=c6g.medium
    N1=pdt
    N2=dub
    N3=syd

### 3.) Change the version of pgXX to use in 'variables.IO.tf'

### 4.) The provisioning & cloud-init info for setting up the 'driver' & 'node' vm's is in 'main.tf'

### 5.) run './launchServers.sh' and it will setupp a multi-region demo cluster as follows:

     # create new nodes/nn directory tree
        ## copying common terraform files
        ## copying IO variables file
        ## copy location files
        ## create node specfic variables
        ## setNodesVar() for NN
 
    # run 'terraform init & apply' to create driver & db node in each location
    # sleep for a couple mins so servers can run init & reboot
    # run './TF.sh all output' to show the Output variables for all the nodes in the '<cluster_name>.out' file
    # run 'python3 make_hosts_file.py' to create the 'hosts' & 'ansible_hosts' files from the 'my.out' file
    # copy ansible input files (ansible_hosts, add-key.yml, hosts, & catHosts.sh) to 'driver1-1')
    # generate an ssh key pair on driver1-1
    # use ansible playbook 'add-key.yml' to allow for passwordless ssh between 'driver1-1' and all other drivers & nodes.

### 6.) run './configServers.sh' to further setup the servers


### 7.) SSH to driver1-1; cd $RMT; cat README.md
    

### ![spock2](https://user-images.githubusercontent.com/1664798/186249698-08853672-a72e-4e39-b236-ad020faa9f94.png)
