terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.39.1"
    }
  }
}

provider "google" {
  # we need ways for terraform to get credentials, this is a bad way btw
  # credentials = "./keys/my_creds.json", otherwise we can use the GDK 
  credentials = file(var.credentials)
  project = var.project
  region  = var.region
}

# creates a resource with google_storage_bucket type and demo which is the LOCAL name 
resource "google_storage_bucket" "demo_bucket" {
  name          = var.gcs_bucket_name                 # name of the bucket, must be unique globally
  location      = "EU"                                # location of the bucket
  force_destroy = true                                # if the bucket is not empty, it will be destroyed

  # I'll keep this just for reference 
  #   lifecycle_rule {                                    # lifecycle rule for the bucket
  #     condition {                                      # condition for the lifecycle rule
  #       age = 3                                    # age of the object in days
  #     }       
  #     action {                                    # action to be taken
  #       type = "Delete"                        # delete the object
  #     }
  #   }


  # another lifecycle rule, we keep this just in case we need it, when you try to upload very large files, the upload is done in parts,
  # if the upload is not completed, the parts are kept in the bucket, this rule will delete those parts after 1 day
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload" # abort incomplete multipart uploads 
    }
  }
}


# creates a resource with google_bigquery_dataset type and dataset which is the LOCAL name
resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.bq_dataset_name   # name of the dataset
  location = var.location   # location of the dataset
}