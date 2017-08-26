terraform {
    backend "gcs" {
        bucket = "terraform.quartic.io"
        path   = "/terraform.tfstate"
    }
}