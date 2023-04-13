# Define a Cloud Run service
resource "google_cloud_run_service" "webapp" {
  name     = var.service_name
  project  = var.project_id
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image
      }

      container_concurrency = 80
      service_account_name = var.service_account_email
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.webapp.location
  project     = google_cloud_run_service.webapp.project
  service     = google_cloud_run_service.webapp.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
