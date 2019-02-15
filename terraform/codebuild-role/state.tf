terraform {
  backend "s3" {
    bucket = "janrtr-infrastructure-terraform-state"
    key    = "lambda-demo/codebuild-role/terraform.tfstate"
    region = "eu-central-1"
  }
}
