provider "google" {
  region      = "us-central1"
}

resource "google_project" "project" {
  name = "${var.environment}-deployment"
  project_id = "${var.environment}-interview"
  billing_account = "${var.billing}"
}

resource "google_project_service" "compute" {
  project = "${google_project.project.id}"
  service = "compute.googleapis.com"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  project      = "${google_project.project.id}"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
