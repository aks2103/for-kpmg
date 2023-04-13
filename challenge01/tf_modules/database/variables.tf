variable "project_id" {
  description = "Google Cloud project ID"
}

variable "region" {
  description = "Google Cloud region"
  default     = "us-central1"
}

variable "instance_name" {
  description = "Name of the Cloud SQL database instance"
}

variable "database_name" {
  description = "Name of the Cloud SQL database created"
}

variable "username" {
  description = "Cloud SQL database username"
}

variable "password" {
  description = "Cloud SQL database password"
}
