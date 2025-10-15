############################
# Trust policy for Lambda
############################
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

############################
# Execution role for Lambda
############################
resource "aws_iam_role" "remediator" {
  count              = var.enable_apply ? 1 : 0
  name               = "${var.lambda_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

############################
# Inline policy: S3 + Logs
############################
data "aws_iam_policy_document" "remediator_policy" {
  statement {
    sid     = "S3AclAndPolicy"
    effect  = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:PutBucketAcl",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy"
    ]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    sid     = "LogsWrite"
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "remediator_inline" {
  count  = var.enable_apply ? 1 : 0
  name   = "${var.lambda_name}-policy"
  policy = data.aws_iam_policy_document.remediator_policy.json
}

resource "aws_iam_role_policy_attachment" "remediator_attach" {
  count      = var.enable_apply ? 1 : 0
  role       = aws_iam_role.remediator[0].name
  policy_arn = aws_iam_policy.remediator_inline[0].arn
}

