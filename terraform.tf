terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">5"
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}


provider "aws" {
  region = var.region
}
