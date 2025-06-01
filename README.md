# terraform-github-workspace

A comprehensive Terraform module for configuring GitHub repositories with environments, branch policies, and CI/CD workflows.

[![Terraform Validation](https://github.com/HappyPathway/terraform-github-workspace/actions/workflows/terraform.yaml/badge.svg)](https://github.com/HappyPathway/terraform-github-workspace/actions/workflows/terraform.yaml)

## Overview

This module automates the setup and configuration of GitHub repositories including:

- GitHub environments with appropriate deployment reviews and branch protections
- Terraform CI/CD workflows (plan and apply) specific to each environment
- Integration with AWS S3 for Terraform state and workflow caching
- GitHub Action secrets and environment variables

## Features

- **Environment Management**: Create and configure GitHub environments with custom settings
- **CI/CD Workflow Templates**: Auto-generated Terraform plan/apply workflows for each environment
- **AWS Integration**: Support for AWS-backed Terraform state management
- **Branch Protection**: Customizable branch policies with options for PR reviews and status checks
- **Secret Management**: Environment-specific secrets and variables for GitHub Actions

## Usage

```hcl
locals {
  repo = {
    name        = "example-repo"
    create_repo = true
    repo_org    = "YourOrgName"
    description = "Example repository managed by Terraform"
  }
}

resource "aws_s3_bucket" "cache_bucket" {
  bucket = "terraform-state-${local.repo.name}"
}

module "github_actions" {
  source = "HappyPathway/workspace/github"
  
  repo = local.repo
  
  environments = [
    {
      name         = "development"
      cache_bucket = aws_s3_bucket.cache_bucket.bucket
      deployment_branch_policy = {
        branch = "dev"
      }
    },
    {
      name         = "production"
      cache_bucket = aws_s3_bucket.cache_bucket.bucket
      reviewers = {
        enforce_reviewers = true
        teams             = ["terraform-reviewers"]
      }
      deployment_branch_policy = {
        branch = "main"
        protected_branches = true
      }
    }
  ]
}
```

## Requirements

- Terraform >= 0.14
- GitHub Provider
- AWS Provider (when using S3 backend)

## Components

This module creates:

1. GitHub environments with deployment review settings
2. Branch protection rules based on environment settings
3. GitHub Actions workflows for Terraform plan/apply
4. Terraform backend configuration files
5. Environment-specific secrets and variables

## Environment Configuration

Each environment can be configured with:

- Reviewers (users and teams)
- Deployment branch policies
- Wait timers for deployments
- AWS S3 backend settings
- Environment-specific secrets and variables

## CI/CD Workflow

The module generates GitHub Actions workflows that:

1. Initialize Terraform with the correct backend
2. Plan changes with environment-specific variables
3. Apply changes after approval (in the target environment)
4. Use S3 for caching Terraform artifacts between steps

## Advanced Features

- Self-review prevention
- Custom branch policies
- Admin bypass settings
- Support for custom GitHub Action composite actions

<!-- BEGIN_TF_DOCS -->
{{ .Content }}
<!-- END_TF_DOCS -->
