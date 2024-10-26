# main.tf
module "github_actions" {
  source    = "./.." # Path to the root of the module
  repo_name = "terraform-github-workspace"
  repo_org  = "HappyPathway"
  environments = [
    {
      name = "production"
      reviewers = {
        enforce_reviewers = true
        teams             = ["terrform-reviewers"]
      }
      #   state_config = {
      #     bucket         = "my-terraform-state-bucket"
      #     key_prefix     = "terraform/production/terraform-github-workspace"
      #     region         = "us-west-2"
      #     dynamodb_table = "terraform-lock-table"
      #     set_backend    = true
      #   }
      deployment_branch_policy = {
        restrict_branches = false
      }
      secrets = [
        {
          name  = "SECRET_KEY"
          value = "stagingsecretvalue"
        }
      ]
      vars = [
        {
          name  = "ENV_VAR"
          value = "staging"
        }
      ]
    }
  ]
}
