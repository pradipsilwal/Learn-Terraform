provider "google" {
	version = "3.5.0"

	project = "lithe-augury-282302"
	region = "us-central1"
	zone = "us-central1-c"
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