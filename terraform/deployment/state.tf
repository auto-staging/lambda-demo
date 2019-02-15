terraform {
  backend "s3" {
    bucket = "janrtr-infrastructure-terraform-state"
    key    = "lambda-demo/deployment/terraform.tfstate"
    region = "eu-central-1"
  }
}
