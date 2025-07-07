terraform {
  backend "http" {
    address = "https://api.backend.com/?token=token"
  }

  backend "s3" {
    bucket = "utopios"
    access_key = "credentials"
    key = "dev/terraform.tfstate" # fichier state dev
  }

  backend "azurerm" {
    container_name = "utopios"
    access_key = "crendials"
    key = "prod/terraform.tfstate" # fichier state prod
  }
#   backend "gcs" {
#     bucket = "utopios"
#     access_token = "crendials"
#   }

}