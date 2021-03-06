resource "aws_iam_role" "codebuild_exec_role" {
  name = "lambda-demo-infrastructure-codebuild-exec-role"

  assume_role_policy = "${data.aws_iam_policy_document.codebuild-assume-role-policy.json}"
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = "${aws_iam_role.codebuild_exec_role.name}"
  policy_arn = "${aws_iam_policy.codebuild_execution.arn}"
}

data "aws_iam_policy_document" "codebuild-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "codebuild_execution" {
  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
            "apigateway:*",
            "acm:*",
            "codebuild:*",
            "codepipeline:*",
            "iam:*",
            "lambda:*",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "route53:*",
            "s3:*",
            "ssm:GetParameters"
           ],
           "Resource": "*"
       }
   ]
}
POLICY
}
