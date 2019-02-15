resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-${var.repository}-${var.branch}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = "${aws_iam_role.codepipeline_role.name}"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "s3:PutObject*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.repository}-${var.branch}-artifacts-bucket*"
      ],
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket" "artifacts_bucket" {
  bucket        = "${var.repository}-${var.branch}-artifacts-bucket"
  acl           = "private"
  force_destroy = true
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.repository}-${var.branch}-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artifacts_bucket.bucket}"
    type     = "S3"
  }

  stage {
    name = "source"

    action {
      category         = "Source"
      name             = "source"
      output_artifacts = ["source-artifact"]
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"

      configuration {
        Owner  = "${var.github_owner}"
        Repo   = "${var.github_repo}"
        Branch = "${var.branch_raw}"
      }
    }
  }

  stage {
    name = "Build-Deploy"

    action {
      category        = "Build"
      input_artifacts = ["source-artifact"]
      name            = "${aws_codebuild_project.build_demo_app.name}"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.build_demo_app.name}"
      }
    }
  }
}
