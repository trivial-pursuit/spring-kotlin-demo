terraform {
  backend "s3" {
    region = "eu-central-1"
    bucket = "tbayer-micronaut-lambda-demo-tf-state"
    key    = "guestbook.json"
  }
}

provider "aws" {
  region  = "eu-central-1"
  version = "~> 1.9"
}
