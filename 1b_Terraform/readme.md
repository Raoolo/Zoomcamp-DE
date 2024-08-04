# Terraform GCP Project README

## Table of Contents
- [What is Terraform?](#what-is-terraform)
- [Main Terraform Commands and Flags](#main-terraform-commands-and-flags-for-wsl)
- [Using nano in WSL](#using-nano-in-wsl)
- [Terraform Resources: Storage Bucket and BigQuery Dataset](#terraform-resources-storage-bucket-and-bigquery-dataset)
- [Terraform Variables](#terraform-variables)
- [Terraform State Files](#terraform-state-files)

## What is Terraform?

Terraform is an Infrastructure as Code (IaC) tool that allows you to define and manage your cloud infrastructure using a declarative language. It interacts with various cloud providers, including Google Cloud Platform (GCP), through provider-specific APIs.

### How Terraform interacts with GCP:

1. You define your desired infrastructure in Terraform configuration files (.tf)
2. Terraform uses the GCP provider to translate your configuration into API calls
3. The GCP provider communicates with GCP services to create, modify, or delete resources

## Main Terraform Commands and Flags (for WSL)

- `terraform init`: Initialize a Terraform working directory
- `terraform plan`: Preview changes before applying
- `terraform apply`: Apply the changes to create/modify resources
- `terraform destroy`: Destroy the created infrastructure

Common flags:
- `-var-file=filename.tfvars`: Specify a variable file
- `-auto-approve`: Skip interactive approval of plan

## Using nano in WSL

nano is a simple text editor for Unix-like systems. To use it in WSL:

1. Open WSL terminal
2. Type `nano filename.extension` (e.g., `nano my-creds.json`)
3. Edit the file
4. Press `Ctrl + X` to exit, `Y` to save, and `Enter` to confirm

## Terraform Resources: Storage Bucket and BigQuery Dataset

### Storage Bucket

```hcl
resource "google_storage_bucket" "my_bucket" {
  name     = "my-unique-bucket-name"
  location = "US"
  
  # Optional fields
  storage_class = "STANDARD"
  force_destroy = true
}
```

Common fields:
- `name`: Globally unique bucket name
- `location`: Geographic location
- `storage_class`: Storage tier (e.g., STANDARD, NEARLINE, COLDLINE)
- `force_destroy`: Allow deletion of non-empty bucket

### BigQuery Dataset

```hcl
resource "google_bigquery_dataset" "my_dataset" {
  dataset_id  = "my_dataset"
  description = "My BigQuery dataset"
  location    = "US"
  
  # Optional fields
  default_table_expiration_ms = 3600000
  labels = {
    environment = "development"
  }
}
```

Common fields:
- `dataset_id`: Unique ID within the project
- `description`: Human-readable description
- `location`: Geographic location
- `default_table_expiration_ms`: Default expiration time for tables
- `labels`: Key-value pairs for organizing resources

## Terraform Variables

Variables in Terraform are defined in a `variables.tf` file:

```hcl
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "development"
}
```

- `description`: Explains the purpose of the variable
- `type`: Defines the variable type (string, number, bool, list, map, etc.)
- `default`: Optional default value

## Terraform State Files

Terraform uses state files (usually named `terraform.tfstate`) to:

1. Map real-world resources to your configuration
2. Keep track of metadata
3. Improve performance for large infrastructures

Key points:
- Store state files securely (they may contain sensitive data)
- Use remote state storage for team collaboration
- Don't edit state files manually

To configure remote state storage, use a `backend` block in your configuration:

```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "terraform/state"
  }
}
```

This setup stores the state file in a GCS bucket, allowing for better collaboration and versioning.
