terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
    vultr = {
      source  = "vultr/vultr"
      version = "2.18.0"
    }
  }

  required_version = "1.6.6"
}
