data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../bin/"
  output_path = "${path.module}/auto-staging-lambda-demo.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = "auto-staging-lambda-demo-${var.branch}"
  handler          = "auto-staging-lambda-demo"
  runtime          = "go1.x"
  filename         = "${path.module}/auto-staging-lambda-demo.zip"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  timeout          = 30
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogFullAccess" {
  role       = "${aws_iam_role.lambda_exec_role.name}"
  policy_arn = "${aws_iam_policy.lambda_execution.arn}"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "auto-staging-lambda-demo-exec-role-${var.branch}"

  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "lambda_execution" {
  name = "auto-staging-lambda-demo-policy-${var.branch}"

  policy = <<POLICY
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
           ],
           "Resource": "*"
       }
   ]
}
POLICY
}
