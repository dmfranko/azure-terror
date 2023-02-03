# What is this?
Use this to create an environment in Azure for discovery testing.

## Setup

Install terraform

Follow the directions here up until the 'Write configuration' section.
https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build

Create a terraform.tfvars file with the following values 

prefix = "disco"
location = "eastus2"
windows_count = 1
linux_count = 1

mid_user = "miduser"
mid_password = ""
mid_instance = "dev1232456"
mid_name = "MIDTEST"

# Run

terraform init
terraform apply

You should now have an environment with infrastructure you can discover against.

To tear down the environment run:
terraform destroy