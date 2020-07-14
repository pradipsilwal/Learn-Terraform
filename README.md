Variables
 defined in variables.tf file

 variable "project" { }

variable "credentials_file" { }

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}

Acess variable using var. in main.tf file
eg. project = var.project


if nothing is given on variable block it it prompted with we do terraform applu

Assign variable using commandline
terraform plan -var 'project=<PROJECT_ID>'

Assigning variabled from file (using tfvars file)
project = "<PROJECT_ID>"
credentials_file = "<NAME>.json"

terraform apply \
  -var-file="secret.tfvars" \
  -var-file="production.tfvars"

From environment variables
Syntax : TF_VAR_name
eg : TF_VAR_region

Terraform variabel types
1. String
variable "project" {
  type = string
}

2. Numbers
variable "web_instance_count" {
  type    = number
  default = 1
}

3. Lists
variable "cidrs" { default = [] }
eg: cidrs = [ "10.0.0.0/16", "10.1.0.0/16" ]


4. Maps
variable "environment" {
  type    = string
  default = "dev"
}

variable "machine_types" {
  type    = map
  default = {
    dev  = "f1-micro"
    test = "n1-highcpu-32"
    prod = "n1-highcpu-32"
  }
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = var.machine_types[var.environment]
  tags         = ["web", "dev"]
  # ...
}

Assigning maps
terraform apply -var 'machine_types={ dev = "f1-micro", test = "n1-standard-16", prod = "n1-standard-16" }'