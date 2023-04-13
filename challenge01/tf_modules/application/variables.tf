variable "project_id" {
  description = "Google Cloud project ID"
}

variable "region" {
  description = "Google Cloud region"
  default     = "us-central1"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
}

variable "container_image" {
  description = "Docker image to use for the Cloud Run service"
}

variable "service_account_email" {
  description = "Email of the service account for the Cloud Run service"
}
variable "db_host" {
  description = "DB hostname"
}
variable "db_user" {
  description = "DB username"
}
variable "db_password" {
  description = "DB password"
}
variable "db_name" {
  description = "DB name"
}
