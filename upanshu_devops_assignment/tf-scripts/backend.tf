terraform {
  backend "gcs" {
    bucket  = "tf-state-test1999"
    prefix  = "terraform/state"
  }
}