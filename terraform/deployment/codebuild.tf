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
  }

  source {
    buildspec = "buildspec.yml"
    type      = "CODEPIPELINE"
  }
}
