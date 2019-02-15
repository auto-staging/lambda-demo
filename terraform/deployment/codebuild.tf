resource "aws_codebuild_project" "build_demo_app" {
  build_timeout = "60"
  name          = "build-deploy-${var.repository}-${var.branch}"
  service_role  = "${data.aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/golang:1.10"
    privileged_mode = true
    type            = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "TF_VAR_branch"
      "value" = "${var.branch}"
    }

    environment_variable {
      "name"  = "TF_VAR_branch_raw"
      "value" = "${var.branch_raw}"
    }

    environment_variable {
      "name"  = "TF_VAR_repository"
      "value" = "${var.repository}"
    }

    environment_variable {
      "name"  = "TF_VAR_github_repo"
      "value" = "${var.github_repo}"
    }

    environment_variable {
      "name"  = "TF_VAR_github_owner"
      "value" = "${var.github_owner}"
    }

    environment_variable {
      "name"  = "GITHUB_TOKEN"
      "type"  = "PARAMETER_STORE"
      "value" = "/CodeBuild/GITHUB_TOKEN"
    }
  }

  source {
    buildspec = "buildspec.yml"
    type      = "CODEPIPELINE"
  }
}
