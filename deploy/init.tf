terraform {
  backend "s3" {
    region = "eu-central-1"
    bucket = "tognibeni-terraform"
    key    = "guestbook.json"
  }
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 2.7"
}

