terraform {
  backend "gcs" {
    bucket  = "kpmg_gcs"
    prefix  = "tfstate"
  }
}
