terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform/production/terraform-github-workspace/production.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock-table"
  }
}
