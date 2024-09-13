terraform {
  backend "s3" {
    region         = "us-east-1"
    key            = "426857564226/proposal_generator.tfstate"
    bucket         = "adex-terraform-state"
    dynamodb_table = "adex-terraform-state"
    acl            = "bucket-owner-full-control"
    encrypt = true
  }
}