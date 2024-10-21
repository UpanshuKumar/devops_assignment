provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "default" {
  name = "web-app-vpc"
}

resource "google_compute_subnetwork" "app_subnet" {
  name          = "app-subnet"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.default.id
  region        = var.region
}

resource "google_compute_firewall" "allow_flask_http" {
  name    = "allow-flask-http"
  network = google_compute_network.default.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["5000","8443"]
  }
  # destination_ranges = ["34.159.82.199/32"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.default.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # destination_ranges = ["34.159.82.199/32"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_sql_database_instance" "mysql_instance" {
  name             = "my-sql-instance"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "users_db" {
  name     = "users_db"
  instance = google_sql_database_instance.mysql_instance.name
}

resource "google_sql_user" "app_user" {
  name     = var.db_user
  instance = google_sql_database_instance.mysql_instance.name
  password = var.db_password
}

resource "google_compute_instance" "flask_backend" {
  name         = "flask-backend"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.default.self_link
    subnetwork = google_compute_subnetwork.app_subnet.id
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #! /bin/bash
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
    pip3 install Flask mysql-connector-python
  EOT
}

# Cloud Storage Bucket for Frontend Hosting
resource "google_storage_bucket" "frontend_bucket" {
  name     = "frontend-bucket-${var.project_id}"
  location = "US"

  website {
    main_page_suffix = "index.html"
  }
}

# Upload frontend files (optional if using manual upload)
resource "google_storage_bucket_object" "index_html" {
  name   = "index.html"
  bucket = google_storage_bucket.frontend_bucket.name
  source = "../app-scripts/frontend/index.html"
}
