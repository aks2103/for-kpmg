# Define a Cloud SQL instance
resource "google_sql_database_instance" "webapp_db" {
  name                = var.instance_name
  project             = var.project_id
  database_version    = "MYSQL_5_7"
  region              = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    # Configure automatic backups
    backup_configuration {
      enabled = false
    }
  }
}

# Create a database in the instance
resource "google_sql_database" "webapp_db" {
  project  = var.project_id
  name     = var.database_name
  instance = google_sql_database_instance.webapp_db.name
}

# Create a user with the specified username and password
resource "google_sql_user" "webapp_db_user" {
  project  = var.project_id
  name     = var.username
  password = var.password
  instance = google_sql_database_instance.webapp_db.name
}

# Outputs from the database instance

output "public_ip_address" {
  value = google_sql_database_instance.webapp_db.public_ip_address
}
output "db_name" {
  value = google_sql_database.webapp_db.name
}
output "db_user" {
  value = google_sql_user.webapp_db_user.name
}
output "db_password" {
  value = google_sql_user.webapp_db_user.password
}
