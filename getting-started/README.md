# Contents
1. Infrastructure as Code (IAAC)
2. 

## What is IaaC (Infrastructure as Code)
IAAC means creating resources like physical infrastructure, compute resources, storage buckets etc using code. These resources can be defined in any order in terraform and it will understand in what order they should be created. 

Terraform uses HCL (Hashicorp Configuration Language) to define this resources.

## What is Terraform?
Terraform is a application which provides IAAC features to multiple cloud providers. Terraform can be compared to Cloudformation from amazon.

The major difference between cloudformation and terraform is that it is cloud agnostic meaning it is not dependent on single cloud service provider.

## Why Terraform?
There are 3 main advantages of terraform:
1. It is not platform dependent (Platform Agnostic)
2. It does state mangement (Will explain later)
3. Operator confidence (It will ask user before applying changes to your environment during terraform apply)

## Terraform flow
Terraform flow is simple and easy to understand.
1. Code
2. Initialize
3. Plan
4. Apply

## Code
Terraform code are written in HCL format. The file extension for terraform is ".tf". It is better to structure terraform files before getting started. We will use them when required. Go a head and create three files inside folder of your choice. 
1. main.tf
2. variables.tf
3. outputs.tf

We will see what it does later.

## Initialize
To initialize a terraform project you execute a command called terraform init. What this does is it checks from provider specified in the code and downloads the plugins for that provider. Provider here means cloud service providers like google, aws etc.

## Plan
We run terraform plan to verify what resource will be created during our creation process. It shows list of things that would be done when we apply the configuration

## Apply
After we run terraform plan, and verified our configuration is ok, we apply the configuration using terraform apply command. What this does is, it interacts with the provider specified and creates resources which were defined in our configuration file. It will prompt you to say yes to apply before actually applying changes.

Terraform also maintains state of the configuration. So if you run terraform apply command it creates a .tfstate file which is in json format and has information about the current state. This becomes the single source of truth to compare against future changes. So, be carefull not to delete this file. 

It also creates .terraform folder which contains information about plugins, metadata. We can just ignore that for now.