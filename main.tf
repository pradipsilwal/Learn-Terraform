provider "google" {
	version = "3.5.0"

	credentials = file(var.credentials_file)

	project = var.project
	region = var.region
	zone = var.zone
}
resource "google_compute_network" "vpc_network" {
	name = "terraform-network"
}
resource "google_compute_instance" "vm_instance" {
	name = "terraform-server"
	machine_type = "f1-micro"
	tags = ["web","dev"]

	provisioner "local-exec" {
    	command = "echo ${google_compute_instance.vm_instance.name}:  ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  	}

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    	nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}

resource "google_compute_address" "vm_static_ip" {
	name = "terraform-static-ip"
}

resource "google_storage_bucket" "test_bucket" {
	name = "thapaprabesh20201011"
	location = "US"


  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}


resource "google_compute_instance" "another_instance" {
	name = "second-instance"
	machine_type = "f1-micro"

	# Tells terraform to create instance after bucket has been created
	depends_on = [google_storage_bucket.test_bucket]


  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}