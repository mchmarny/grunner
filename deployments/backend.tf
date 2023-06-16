terraform {
 backend "gcs" {
   bucket  = "grunner-terraform-state"
   prefix  = "demo"
 }
}