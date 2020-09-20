provider "azurerm" {
  version = "~>2.0"
  features {}
}

# Create a resource Group
resource "azurerm_resource_group" "myTerraformResourceGroup" {
  name = "myResourceGroup"
  location = "australiaeast"

  tags = {
    environment = "Terraform Value"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "myTerraformVirtualNetwork" {
  name = "myVnet"
  address_space = ["192.168.0.0/16"]
  location = "australiaeast"
  resource_group_name = azurerm_resource_group.myTerraformResourceGroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

# Create a subnet
resource "azurerm_subnet" "myTerraformSubnet" {
  name = "mySubnet"
  resource_group_name = azurerm_resource_group.myTerraformResourceGroup.name
  virtual_network_name = azurerm_virtual_network.myTerraformVirtualNetwork.name
  address_prefixes = ["192.168.1.0/24"]
}

# Create public IP address
resource "azurerm_public_ip" "myTerraformPublicIP" {
  name = "myPublicIP"
  location = "australiaeast"
  resource_group_name = azurerm_resource_group.myTerraformResourceGroup.name
  allocation_method = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

# Create Network Security Group
resource "azurerm_network_security_group" "myTerraformNetworkSecurityGroup" {
  name = "myNetworkSecurityGroup"
  location = "australiaeast"
  resource_group_name = azurerm_resource_group.myTerraformResourceGroup.name
  
  security_rule {
    name = "SSH"
    priority = 1001
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Create Virtual Network Interface Card
resource "azurerm_network_interface" "myTerraformNetworkInterfaceCard" {
  name = "myNetworkInterfaceCard"
  location = "australiaeast"
  resource_group_name = azurerm_resource_group.myTerraformResourceGroup.name

  ip_configuration {
    name = "myNicConfiguration"
    subnet_id = azurerm_subnet.myTerraformSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.myTerraformPublicIP.id
    
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "myTerraformNsgAssociation" {
  network_interface_id = azurerm_network_interface.myTerraformNetworkInterfaceCard.id
  network_security_group_id = azurerm_network_security_group.myTerraformNetworkSecurityGroup.id
}

# Create storage account for diagnostics
# As each storage account must have a unique name,
# the following section generates some random text:
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.myTerraformResourceGroup.name
  }

  byte_length = 8
}

# The following section creates a storage account, with the
# name based on the random text generated in the preceding step:
resource "azurerm_storage_account" "myTerraformStorageAccount" {
    name = "diag${random_id.randomId.hex}"
    resource_group_name = azurerm_resource_group.myTerraformResourceGroup.name
    location = "australiaeast"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" { value = "tls_private_key.example_ssh.private_key_pem" }

resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location              = "australiaeast"
    resource_group_name   = azurerm_resource_group.myTerraformResourceGroup.name
    network_interface_ids = [azurerm_network_interface.myTerraformNetworkInterfaceCard.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.myTerraformStorageAccount.primary_blob_endpoint
    }

    tags = {
        environment = "Terraform Demo"
    }
}

