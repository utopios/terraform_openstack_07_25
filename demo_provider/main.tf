terraform {
  required_providers {
    openstack = {
        source = "terraform-provider-openstack/openstack"
        version = "~> 1.53.0"
    }
  }
}

variable "password_openstack" {
  type = string
  sensitive = true
}

variable "user_openstack" {
  type = string
  sensitive = true
}

variable "tenant_name" {
  type = string
  sensitive = true
}

variable "url_cloud" {
  type = string
}

provider "openstack" {
  user_name = var.user_openstack
  tenant_name = "demo"
  password = var.tenant_name
  auth_url = var.url_cloud
  region = "microstack"
}