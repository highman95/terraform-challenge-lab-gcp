resource "google_storage_bucket" "my-bucket" {
    name          = "tf-bucket-914868"
    location      = "US"
    force_destroy = true
    project       = var.project_id

    uniform_bucket_level_access = true
}