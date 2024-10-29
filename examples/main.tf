# main.tf
locals {
  repo = {
    name        = "github-workspace-test"
    create_repo = true
    repo_org    = "HappyPathway"
  }
}
resource "random_uuid" "bucket_id" {}

resource "aws_s3_bucket" "cache_bucket" {
  bucket = "${local.repo.repo_org}-${local.repo.name}-${random_uuid.bucket_id.result}"
}

module "github_actions" {
  source = "./.." # Path to the root of the module
  repo   = local.repo
  environments = [
    {
      name         = "production"
      cache_bucket = aws_s3_bucket.cache_bucket.bucket
      reviewers = {
        enforce_reviewers = true
        teams             = ["terraform-reviewers"]
      }
      deployment_branch_policy = {
        restrict_branches = false
      }
    }
  ]
}
