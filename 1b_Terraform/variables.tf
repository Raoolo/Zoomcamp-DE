variable "credentials" {
  description = "Path to the service account key file"
  type        = string
  default     = "./keys/my_creds.json"
}

variable "project" {
  description = "Project description"
  type        = string
  default     = "dtc-de-course-431213"
}

variable "location" {
  description = "Location of the resources"
  type        = string
  default     = "EU"
}

variable "region" {
  description = "Region of the resources"
  type        = string
  default     = "europe-west1"
}

variable "bq_dataset_name" {
  description = "BigQuery dataset name"
  type        = string
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket name"
  type        = string
  default     = "dtc-de-course-431213-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket storage class"
  default     = "STANDARD"
}