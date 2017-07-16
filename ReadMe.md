This project builds this AMI for use on AWS as a Docker host.  The AMI consists of this:

- Ubuntu 16.04 Xenial
- The current Docker Community Edition version
- AWS Command Line tools
- AWS ECR Credential Helper (see note below)

The AMI is built by launching a local Docker container, installing the build tool (Packer), and then running two shell scripts 
to install the necessary components.

If you have Packer installed locally, you can use it directly as well.

### Setup

#### Install Docker

If you don't have Docker installed, visit https://www.docker.com/community-edition and install it.
The current version as of this writing (16 Jul 2017) is Docker 17.06

#### Compile the AWS ECR Credential Helper

The AWS ECR Credential Helper isn't included in this repository.  The ECR Credential Helper is roughly 9MB in size, and it's a compiled binary.

Visit this link for instructions on compiling and building: https://github.com/awslabs/amazon-ecr-credential-helper

Add the binary to the files folder in this repo.

#### Add AWS access keys as environment variables

Set two environment variables in your shell.  

    export AWS_ACCESS_KEY_ID=AKIAUYHNJIKWGPVDUMMY
    export AWS_SECRET_ACCESS_KEY=R7inVG1prjkP98/asdSD+NFHumVZykeHJgUDUMMY
    
#### Chose the base Ubuntu AMI

Choose a valid Ubuntu base AMI.   Ubuntu releases AWS optimized images frequently; find valid listings here:

https://cloud-images.ubuntu.com/locator/

To find an image for your needs, search for something like this "us-east-2 xenial hvm-ssd 201706", where 201706 is the current month in YYYYMM format.

For example, here's that listing for the us-east-2 AWS Region:

    Amazon AWS	us-east-2	xenial	16.04	amd64	hvm-ssd	20170619.1	ami-8b92b4ee
    
Edit the JSON file for Packer, and the source_ami_id to the AMI ID.


### Create the AMI

#### Run this command

    ./build-ami.sh
    
On a successful AMI build, the last lines will read:

    ==> Builds finished. The artifacts of successful builds are:
    --> ubuntu-xenial-docker-ce-base: AMIs were created:

    us-east-2: ami-a55bc27b


### Create the AMI - alternative method

This uses a local Packer installation, rather than a Docker container.

#### Install Packer

https://www.packer.io/docs/install/index.html

After downloading and unzipping, copy the file packer to /usr/local/bin/, or anywhere on your $PATH

    mv packer /usr/local/bin/

Verify the version installed

    packer -v

#### Run Packer

Run packer with this command, which creates the AMI and returns their IDs:

    packer build us-east-2_create-dockerhost-ami.json

On a successful AMI build, the last lines will read:

    ==> Builds finished. The artifacts of successful builds are:
    --> ubuntu-xenial-docker-ce-base: AMIs were created:

    us-east-2: ami-a55bc27b


