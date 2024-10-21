output "flask_backend_ip" {
  value = google_compute_instance.flask_backend.network_interface[0].access_config[0].nat_ip
  description = "Public IP of the Flask Backend"
}

output "frontend_url" {
  # value = "http://${google_storage_bucket.frontend_bucket.website_endpoint}"
  # value = google_storage_bucket.frontend_bucket.self_link
    value = "https://storage.googleapis.com/${google_storage_bucket.frontend_bucket.name}/${google_storage_bucket_object.index_html.name}"
  description = "URL of the frontend static website"
}
