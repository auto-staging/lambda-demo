terraform {
  backend "s3" {
    bucket = "janrtr-infrastructure-terraform-state"
    key    = "lambda-demo/terraform.tfstate"
    region = "eu-central-1"
  }
}
