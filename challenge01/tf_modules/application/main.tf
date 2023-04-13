# Define a Cloud Run service
resource "google_cloud_run_service" "webapp" {
  name     = var.service_name
  project  = var.project_id
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image
        env = [
          {
            name  = "DB_HOST"
            value = var.db_host
          },
          {
            name  = "DB_USER"
            value = var.db_user
          },
          {
            name  = "DB_PASSWORD"
            value = var.db_password
          },
          {
            name  = "DB_NAME"
            value = var.db_name
          },
        ]
      }

      # Configure the service to require authentication
      container_concurrency = 80
      service_account_email = var.service_account_email
      container_port        = 8080
    }
  }

  # Allow unauthenticated access to the service
  metadata {
    disable_auth = true
  }
}
