provider "google" {
  credentials = file("account.json")
  project     = "mostela-joao"
  region      = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = "moni-web-1"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["monitoramento"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-key = file("~/.ssh/id_rsa.pub")
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

output "ip-public" {
    value = "{mobi_web.network_interface.network_ip}"
}

output "nat_ip" {
    value = "{mobi_web.network_interface.network_ip.access_config.nat_ip}"
}