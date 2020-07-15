## Contents
In this module we will learn following things:
1. Learn more about Hashicorp configuration language (HCL)
2. Create VPC network in GCP using terraform 
3. Create an intance in GCP using terraform
4. Changing resource
5. Destroy create resource using <code>terraform destory</code> command

## HCL Language
HCL is the standard configuration language for terraform. These configuration as written in a <code>.tf</code> file. These file contains different blocks defined inside them which tells terraform what configuration to apply when we apply using <code>terraform apply</code>

Some blocks are:</br>
<b>Providers block</b> which tells terraform which plugin to download when we initialize terraform using <code>terraform init</code>. Provider handles all all operations of creating and managing resource. We can use different providers inside same configuration.

<b>Resource block</b> which resource should terraform interact with and what to do on those resource. For example resource block can be of type "google compute instance" which when defined handles operations defined inside that block in google compute. Resource block when defined as 2 strings on it. First one is resource type and second one is resource name. This two combine together to become resource ID.

There are others providers and resources which we will interact as we go.

The basic syntax for a resuorce block in terraform is:
```
resource "RESOURCE_TYPE" "RESOURCE_NAME" {
	...
}
```

## Create a VPC network in GCP
For this follow this steps:
1. Go inside the folder where you create main.tf file and open main.tf file created before and add provider block. Now run <code>terraform init</code>. It will download provider plugins for google cloud. This will generate <i>.terraform</i> file.

```
provider "google" {
	version = "3.5.0"
	project = "lithe-augury-282302"
	region = "us-central1"
	zone = us-central1-c"
}
```
2. Now, lets add a resource block called "google_compute_network" with resource name "terraform_vpc". Let's name this network my-network.
```
provider "google" {
	version = "3.5.0"

	region = "us-central1"
	zone = us-central1-c"
}

resource "google_compute_network" "terraform_vpc" {
	name = "my-network"
}
```
3. From above code we can see that terraform is using google as provider, it is creating a resource named terraform_vpc which is of type google_compute_network and we have named it "my-network". Run <code>terarform plan</code> to see what terraform is going to do.
4. We see output something like this
```
 # google_compute_network.terraform_vpc will be created
  + resource "google_compute_network" "terraform_vpc" {
      + auto_create_subnetworks         = true
      + delete_default_routes_on_create = false
      + gateway_ipv4                    = (known after apply)
      + id                              = (known after apply)
      + ipv4_range                      = (known after apply)
      + name                            = "my-network"
      + project                         = (known after apply)
      + routing_mode                    = (known after apply)
      + self_link                       = (known after apply)
    }
```
There are various things that needs to be understood from this. "+" means terraform will add this configuration when it is applied. 

We can also see that we only gave name attribute to the resource block but terraform added other attributes as well automatically which are required to build a vpc network.

(known after apply) means that the configuration value will be populated when we do terraform apply.

You might have notices that we still have not generated tfstate file. This is because, we are currently planning the configuration but have not applied it. Once we apply, terraform will apply configuration and create a tfstate file for out current setup.

That tfstate file will be our single source of truth.

5. Now lets apply the terraform configuration using <code>terraform apply</code>. It will prompt you asking whether you will allow terraform to take actions defined in out configuration. Hit yes and it should start creating your VPC in google cloud. output will be something like this
```
oogle_compute_network.terraform_vpc: Creating...
google_compute_network.terraform_vpc: Still creating... [10s elapsed]
google_compute_network.terraform_vpc: Still creating... [20s elapsed]
google_compute_network.terraform_vpc: Still creating... [30s elapsed]
...
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## Create an instance in GCP using terraform
In previous part, we created our VPC. If you go to gcp console and see you should see your VPC has been created. Please make sure you look in specific region and zone defined in the configuration file.

Now, let's create an isntance in that vpc.
1. On the same configuration file we will add another resource block called "google_compute_instance". So let's create a new resource block and name it "vm_instance". We will add some more parameters inside there but these are easy to understand.
```
provider "google" {
	version = "3.5.0"

	region = "us-central1"
	zone = us-central1-c"
}

resource "google_compute_network" "terraform_vpc" {
	name = "my-network"
}

resource "google_compute_instance" "vm_instance" {
	name = "my-instance"
	machine_type = "f1-micro"

	 boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.terraform_vpc.name
    access_config {
    }
  }
}

```

You can see we create a a resource block and provided name. We added some more arguments to this resource block like boot_disk and network_interface which provides which os to choose and which network interface should the vm should be connected respectively.

One thing to notice over there is in network_interface block, you can see we added a argument called network and its value it linked to the vpc that we created before. This is because, we want this vm to connect to a network inside our defined vpc. So, to attach network to vpc, we use the resource ID (resource_type + resource_name), i.e google_compute_network.terraform_vpc.name. This takes the value of network from VPC and adds to vm network configuration during creation of VM.

2. Let's apply using <code>terraform plan</code> and <code>terraform apply</code>. This will create a VM in GCP in our defined region and zone. You can verify that from the console.

```
One thing to remember is that, terraform knows on what order the resource should be created. It knows vpc should be created before vm. Even if you add vm resource block before vpc, it know the order of creation of resource and create it in the same fashion. Same goes when you issue <code>terraform destory</code> command.
```

## Changing resource
There are two main type of change when you change anything on terraform configuration.
1. Updating change
2. Destructive change

When you change the name of instance, or add tags to instance, add ip to instance etc. these are called updating change. These change just updates the defined resource variables.

When you change the instance from debian to centos, then terraform needs to delete the resource and create a new one. This is called destructive change. It requires terraform to replace the resource rather than updating it.
```
Info : -/+/~ signs that you see  during plan and apply means same as github. "-" means it will destory it, and "+" means it will add it. "~" means it will update it.
```

## Destroy create resource using <code>terraform destory</code> command
You can destory all the resource created using <code>terraform destory</code>command. It destroys all the configuration that were recorded in tfstate file. To destory, all resource created, issue command <code>terraform destory</code>.