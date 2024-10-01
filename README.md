# Carbone Report Generator

## Deployment Guide
Follow these steps for deploying the application:

### Step 1: Clone the Git repository:
`git clone git@github.com:adexltd/adex-suite-proposal_generator.git <directory-name>`

### Step 2: Change into the project directory:
`cd <directory-name>`

### Step 3: Create variables for Terraform backend configuration:
Create a .env file for storing the variables required for Terraform backend configuration. Refer to the `.env-example` file in the project directory for values to provide to the variables:
```region         = <aws_region>
key            = <name_of_the_state_file>
bucket         = <bucket_for_storing_state_file>
dynamodb_table = <replace_with_tfstate_dynamodb>
acl            = <replace_with_s3_bucket_acl>
encrypt        = <replace_with_bool_value>
```

### Step 4: Install AWS CLI and configure the AWS Credentials:
[Install or update to the latest version of the AWS CLI - AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) This documentation has detailed steps for installing aws cli.

After aws cli is installed we need to configure it with our credentials. To configure, run the following command and provide your IAM User credentials as prompted:
`aws configure`

### Step 5: Install other dependencies: Terraform, Taskfile and Docker CLI:
Refer to this link for installing Terraform: [Install Terraform | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Refer to this link for installing Taskfile: [Installation | Task](https://taskfile.dev/installation/)

Refer to this link for installing Docker CLI: [Install](https://docs.docker.com/engine/install/)

#### Alternatively,
Instead of installing all the project dependencies gloablly, for managing dependencies, you can install **Devbox** (isolated environments) and initialize it in your project directory:
* Install Devbox:
`curl -fsSL https://get.jetify.com/devbox | bash`
* To create a new development environment with the packages you need, Initialize devbox and add the packages you need:
```
devbox init
devbox add awscli2@2.17.18 terraform@1.9.5 dotenv-cli@7.4.3 docker@27.2.0 go-task@3.38.0
```
* Start a new shell that has your packages and tools installed:
`devbox shell`
### Step 6: Use Taskfile to automate the infrastructure provisioning and cleanup.
i) To check the plan of the terraform, run:
`task init-plan`

ii) To provision the resources, run:
`task deploy`

iii) To destroy all the resources, run:
`task delete`

To change the project specific variables, Change the variables from `dev.tfvars` file in the terraform directory
