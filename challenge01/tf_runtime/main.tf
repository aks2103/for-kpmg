# Variables for username and pwd called via tfvars which is ignored in .gitignore and other mentioned in modules or local vars

variable "username" {}
variable "password" {}

locals {
  project_id = "firebase-382215"
  region     = "asia-south1"
  roles = [
    "roles/run.admin",
    "roles/cloudsql.editor",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/iam.serviceAccountUser"
  ]
  enable_apis = [
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "storage-component.googleapis.com",
    "run.googleapis.com"
  ]
}

# enabling APIs

resource "google_project_service" "enable_apis" {
  project  = local.project_id
  for_each = toset(local.enable_apis)
  service  = each.value
}

# creating SA and assigning roles

resource "google_service_account" "webapp" {
  project      = local.project_id
  account_id   = "webapp-service-account"
  display_name = "Web App Service Account"
}

resource "google_project_iam_member" "webapp_roles" {

  for_each = toset(local.roles)
  project  = local.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.webapp.email}"
}
# enabling firewall ports

resource "google_compute_firewall" "allow_db_ports" {
  name      = "allow-db-ports"
  project   = local.project_id
  network   = "default"
  priority  = 1000
  direction = "INGRESS"

  # Allow TCP traffic on port 3306 for MySQL
  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }

  # Restrict traffic to a specific IP range if desired
  source_ranges = ["0.0.0.0/0"]
}

module "database" {
  depends_on = [
    google_project_service.enable_apis
  ]
  source        = "../tf_modules/database"
  project_id    = local.project_id
  region        = local.region
  instance_name = "webapp-db-instance"
  database_name = "webapp-db"
  username      = var.username
  password      = base64encode(var.password)
}

module "application" {
  depends_on = [
    google_project_service.enable_apis
  ]
  source                = "../tf_modules/application"
  project_id            = local.project_id
  region                = local.region
  service_name          = "webapp-demo"
  container_image       = "aks2103/webapp:latest"
  db_host               = module.database.public_ip_address
  db_user               = module.database.db_user
  db_password           = base64encode(module.database.db_password)
  db_name               = module.database.db_name
  service_account_email = google_service_account.webapp.email
}
